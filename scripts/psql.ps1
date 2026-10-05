<#
.SYNOPSIS
  Open an interactive psql prompt inside the container. Type \q to quit.
#>
. (Join-Path $PSScriptRoot 'common.ps1')
Assert-DbRunning
& docker compose -f $script:ComposeFile exec db psql -U practice -d oa
