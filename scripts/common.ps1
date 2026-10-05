# Shared helpers for the PowerShell scripts. Dot-sourced, not run directly.

$script:Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$script:ComposeFile = Join-Path $script:Root 'docker-compose.yml'

# Runs `docker compose exec -T db psql ...` with extra arguments.
# Returns @{ Lines = <string[]>; ExitCode = <int> } (stdout and stderr merged).
function Invoke-Psql {
    param([string[]]$PsqlArgs, [string[]]$ExecArgs = @())
    $dockerArgs = @('compose', '-f', $script:ComposeFile, 'exec', '-T') + $ExecArgs +
                  @('db', 'psql', '-U', 'practice', '-d', 'oa', '-X', '-q', '-v', 'ON_ERROR_STOP=1') + $PsqlArgs
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'   # psql/docker write to stderr; don't treat that as a terminating error
    $lines = @(& docker @dockerArgs 2>&1 | ForEach-Object { "$_" })
    $code = $LASTEXITCODE
    $ErrorActionPreference = $prev
    return @{ Lines = $lines; ExitCode = $code }
}

function Assert-DbRunning {
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $null = & docker compose -f $script:ComposeFile exec -T db pg_isready -U practice -d oa 2>&1
    $code = $LASTEXITCODE
    $ErrorActionPreference = $prev
    if ($code -ne 0) {
        Write-Host "The database is not running. Start it first:" -ForegroundColor Yellow
        Write-Host "    docker compose up -d --wait" -ForegroundColor Yellow
        Write-Host "(run that from the project folder, with Docker Desktop open)" -ForegroundColor Yellow
        exit 2
    }
}

function Get-ExerciseDir {
    param([int]$Number)
    $prefix = '{0:D2}-' -f $Number
    $dir = Get-ChildItem -Path (Join-Path $script:Root 'exercises') -Directory |
           Where-Object { $_.Name.StartsWith($prefix) } | Select-Object -First 1
    if (-not $dir) { throw "No exercise folder starting with '$prefix' in exercises\" }
    return $dir
}

function Get-AllExerciseDirs {
    Get-ChildItem -Path (Join-Path $script:Root 'exercises') -Directory |
        Where-Object { $_.Name -match '^\d{2}-' } | Sort-Object Name
}

# True when the file contains nothing but comments / whitespace.
function Test-SqlFileEmpty {
    param([string]$Path)
    $code = (Get-Content -LiteralPath $Path -Raw)
    if ($null -eq $code) { return $true }
    $code = [regex]::Replace($code, '/\*[\s\S]*?\*/', '')
    $code = [regex]::Replace($code, '--[^\r\n]*', '')
    return [string]::IsNullOrWhiteSpace($code)
}

function Get-CleanLines {
    param($Lines)
    @($Lines | ForEach-Object { "$_".TrimEnd() } | Where-Object { $_ -ne '' })
}

function Write-Block {
    param([string]$Title, $Lines)
    Write-Host $Title
    if (@($Lines).Count -eq 0) { Write-Host '    (no rows)' -ForegroundColor DarkGray }
    foreach ($l in $Lines) { Write-Host "    $l" }
}

# Runs one exercise and compares with expected.csv.
# Returns 'PASS', 'FAIL' or 'SKIP'.
function Test-Exercise {
    param([int]$Number, [switch]$Solution, [switch]$Brief)

    $dir = Get-ExerciseDir $Number
    $label = "Exercise $('{0:D2}' -f $Number) ($($dir.Name))"
    if ($Solution) {
        $local = Join-Path $script:Root "solutions\$($dir.Name).sql"
        $container = "/workspace/solutions/$($dir.Name).sql"
        $label += ' [official solution]'
    } else {
        $local = Join-Path $dir.FullName 'answer.sql'
        $container = "/workspace/exercises/$($dir.Name)/answer.sql"
    }

    if (Test-SqlFileEmpty $local) {
        Write-Host "SKIP: $label - no query written yet in $([IO.Path]::GetFileName($local))" -ForegroundColor DarkYellow
        return 'SKIP'
    }

    $run = Invoke-Psql -PsqlArgs @('--csv', '-f', $container)
    $expected = Get-CleanLines (Get-Content -LiteralPath (Join-Path $dir.FullName 'expected.csv'))

    if ($run.ExitCode -ne 0) {
        Write-Host "FAIL: $label" -ForegroundColor Red
        if (-not $Brief) { Write-Block 'Your query raised an error:' (Get-CleanLines $run.Lines) }
        return 'FAIL'
    }

    $received = Get-CleanLines $run.Lines
    # Row comparison ignores the header line (HackerRank checks values, not column names).
    $expRows = @($expected | Select-Object -Skip 1)
    $gotRows = @($received | Select-Object -Skip 1)

    if (($expRows -join "`n") -ceq ($gotRows -join "`n") -and $received.Count -gt 0) {
        Write-Host "PASS: $label" -ForegroundColor Green
        if (-not $Brief -and $received[0] -ne $expected[0]) {
            Write-Host "  note: column names differ (expected '$($expected[0])', got '$($received[0])')." -ForegroundColor DarkYellow
            Write-Host "        The values are right; use the aliases from prompt.md to match exactly." -ForegroundColor DarkYellow
        }
        return 'PASS'
    }

    Write-Host "FAIL: $label" -ForegroundColor Red
    if (-not $Brief) {
        if ($received.Count -eq 0) {
            Write-Host '  Your query produced no output at all (is there a SELECT in the file?).' -ForegroundColor Yellow
        } elseif ((($expRows | Sort-Object) -join "`n") -ceq (($gotRows | Sort-Object) -join "`n")) {
            Write-Host '  Hint: you have the right rows in the WRONG ORDER. Check your ORDER BY against prompt.md.' -ForegroundColor Yellow
        } elseif ($expRows.Count -ne $gotRows.Count) {
            Write-Host "  Hint: expected $($expRows.Count) row(s), received $($gotRows.Count)." -ForegroundColor Yellow
        }
        Write-Block 'Expected:' $expected
        Write-Block 'Received:' $received
    }
    return 'FAIL'
}
