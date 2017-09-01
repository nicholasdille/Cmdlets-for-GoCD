function Get-GocdConfigurationHistory {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Offset = ''
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path "/api/config/revisions$Offset"
    $Revisions = $Response | Select-Object -ExpandProperty Content | ConvertFrom-Json

    if ($Raw) {
        $Revisions
        return
    }

    foreach ($Revision in $Revisions) {
        [pscustomobject]@{
            Time       = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Revision.time / 1000))
            MD5        = $Revision.MD5
            CommitHash = $Revision.commitSHA
        }
    }
}