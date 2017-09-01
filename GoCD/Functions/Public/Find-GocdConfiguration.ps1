function Find-GocdConfiguration {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [datetime]
        $Start
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [datetime]
        $End = (Get-Date)
    )

    if (-Not $Start) {
        $Start = $End.AddDays(-1)
    }

    $BasePath = '/api/config/revisions'

    $ContinueProcessing = $true
    $Offset = 0
    while ($ContinueProcessing) {
        $Response = Invoke-GocdApi -Path "$BasePath/$Offset"
        $Revisions = $Response | Select-Object -ExpandProperty Content | ConvertFrom-Json
        $Offset += $Revisions.Length

        foreach ($Revision in $Revisions) {
            $NewRevision = [pscustomobject]@{
                Time       = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Revision.time / 1000))
                User       = $Revision.username
                MD5        = $Revision.MD5
                CommitHash = $Revision.commitSHA
            }

            if ($NewRevision.Time -ge $Start -and $NewRevision.Time -le $End) {
                $NewRevision
            }

            if ($NewRevision.Time -lt $Start) {
                $ContinueProcessing = $false
            }
        }
    }
}