<#
.SYNOPSIS
  Run arbitrary SQL and print the result as a table.
.EXAMPLE
  .\scripts\run.ps1 "SELECT * FROM Employee"
  .\scripts\run.ps1 -File exercises\05-having-three-orders\answer.sql
#>
param(
    [Parameter(Position = 0)][string]$Query,
    [string]$File
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')
Assert-DbRunning

if ($File) {
    $full = (Resolve-Path $File).Path
    if (-not $full.StartsWith($script:Root, [StringComparison]::OrdinalIgnoreCase)) {
        throw "The file must be inside the project folder ($script:Root)."
    }
    $container = '/workspace' + $full.Substring($script:Root.Length).Replace('\', '/')
    $run = Invoke-Psql -PsqlArgs @('-f', $container)
} elseif ($Query) {
    $run = Invoke-Psql -PsqlArgs @('-c', $Query)
} else {
    throw 'Pass a query string or -File <path>.'
}
$run.Lines | ForEach-Object { Write-Host $_ }
exit $run.ExitCode
