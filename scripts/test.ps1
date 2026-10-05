<#
.SYNOPSIS
  Test one exercise.
.EXAMPLE
  .\scripts\test.ps1 5              # runs exercises\05-*\answer.sql
  .\scripts\test.ps1 5 -Solution    # runs solutions\05-*.sql instead
#>
param(
    [Parameter(Mandatory = $true, Position = 0)][int]$Number,
    [switch]$Solution
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'common.ps1')
Assert-DbRunning
$result = Test-Exercise -Number $Number -Solution:$Solution
if ($result -ne 'PASS') { exit 1 }
