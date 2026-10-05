<#
.SYNOPSIS
  Test every exercise. Exercises whose answer.sql is still empty are reported as SKIP.
.EXAMPLE
  .\scripts\test-all.ps1               # your answers, one line per exercise
  .\scripts\test-all.ps1 -Detailed     # also print Expected/Received for failures
  .\scripts\test-all.ps1 -Solutions    # verify the official solutions
#>
param([switch]$Solutions, [switch]$Detailed)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')
Assert-DbRunning

$counts = @{ PASS = 0; FAIL = 0; SKIP = 0 }
foreach ($dir in Get-AllExerciseDirs) {
    $n = [int]$dir.Name.Substring(0, 2)
    $r = Test-Exercise -Number $n -Solution:$Solutions -Brief:(-not $Detailed)
    $counts[$r]++
}
$total = $counts.PASS + $counts.FAIL + $counts.SKIP
Write-Host ''
Write-Host ("{0} passed, {1} failed, {2} not attempted (of {3})" -f $counts.PASS, $counts.FAIL, $counts.SKIP, $total)
if ($counts.FAIL -gt 0) { exit 1 }
