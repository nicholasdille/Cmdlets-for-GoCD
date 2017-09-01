function Get-GocdJobFeed {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $Id
        ,
        [Parameter()]
        [switch]
        $Xml
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    process {
        foreach ($JobId in $Id) {
            $Response = Invoke-GocdApi -Path "/api/jobs/$JobId.xml"

            if ($Xml) {
                $Response.Content
                return
            }

            [xml]$Content = $Response.Content

            if ($Raw) {
                $Content
                return
            }
            
            $Job = $Content.job
            $Pipeline = $Job.pipeline
            $Stage = $Job.stage
            $Properties = $Job.properties.property

            [pscustomobject]@{
                JobId           = $Properties | Where-Object { $_.name -ieq 'cruise_job_id' } | Select-Object -ExpandProperty '#cdata-section'
                PipelineName    = $Pipeline.name
                PipelineCounter = $Pipeline.counter
                StageName       = $Stage.name
                StageCounter    = $Stage.counter
                JobName         = $Job.name
                JobString       = "$($Pipeline.name)/$($Pipeline.counter)/$($Stage.name)/$($Stage.counter)/$($Job.name)"
                Scheduled       = $Properties | Where-Object { $_.name -ieq 'cruise_timestamp_01_scheduled'  } | Select-Object -ExpandProperty '#cdata-section'
                Assigned        = $Properties | Where-Object { $_.name -ieq 'cruise_timestamp_02_assigned'   } | Select-Object -ExpandProperty '#cdata-section'
                Preparing       = $Properties | Where-Object { $_.name -ieq 'cruise_timestamp_03_preparing'  } | Select-Object -ExpandProperty '#cdata-section'
                Building        = $Properties | Where-Object { $_.name -ieq 'cruise_timestamp_04_building'   } | Select-Object -ExpandProperty '#cdata-section'
                Completing      = $Properties | Where-Object { $_.name -ieq 'cruise_timestamp_05_completing' } | Select-Object -ExpandProperty '#cdata-section'
                Completed       = $Properties | Where-Object { $_.name -ieq 'cruise_timestamp_06_completed'  } | Select-Object -ExpandProperty '#cdata-section'
                Duration        = $Properties | Where-Object { $_.name -ieq 'cruise_job_duration'            } | Select-Object -ExpandProperty '#cdata-section'
                Result          = $Job.result
                AgentName       = $Properties | Where-Object { $_.name -ieq 'cruise_agent' } | Select-Object -ExpandProperty '#cdata-section'
                AgentUuid       = $Job.agent.uuid
                Resources       = $Job.resources.resource
                PSTypeName      = 'GocdJobFeed'
            }
        }
    }
}