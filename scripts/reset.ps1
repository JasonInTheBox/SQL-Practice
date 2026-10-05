<#
.SYNOPSIS
  Drop every table and reload db\schema.sql + db\seed.sql.
  Your answer.sql files are NOT touched.
#>
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')
Assert-DbRunning
$run = Invoke-Psql -ExecArgs @('-e', 'PGOPTIONS=--client-min-messages=warning') `
                   -PsqlArgs @('-f', '/workspace/db/schema.sql', '-f', '/workspace/db/seed.sql')
if ($run.ExitCode -ne 0) {
    $run.Lines | ForEach-Object { Write-Host $_ }
    Write-Host 'Reset FAILED.' -ForegroundColor Red
    exit 1
}
Write-Host 'Database reset: schema.sql + seed.sql reloaded.' -ForegroundColor Green
