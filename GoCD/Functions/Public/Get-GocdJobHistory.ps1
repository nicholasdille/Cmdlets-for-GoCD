function Get-GocdJobHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Pipeline
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Stage
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Job
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path "/api/jobs/$Pipeline/$Stage/$Job/history"
    $Jobs = $Response | Select-Object -ExpandProperty Content | ConvertFrom-Json
    $Jobs = $Jobs | Select-Object -ExpandProperty jobs

    if ($Raw) {
        $Jobs
        return
    }

    foreach ($Item in $Jobs) {
        [pscustomobject]@{
            JobId           = $Item.id
            Pipeline        = $Item.pipeline_name
            PipelineCounter = $Item.pipeline_counter
            Stage           = $Item.stage_name
            StageCounter    = $Item.stage_counter
            Job             = $Item.name
            Scheduled       = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($Item.scheduled_date / 1000))
            State           = $Item.state
            Result          = $Item.result
        }
    }
}