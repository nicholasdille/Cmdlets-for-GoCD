function Get-GocdResourceUsage {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Pipeline = '*'
    )

    $Pipelines = Get-GocdPipeline | Where-Object { $_.Name -like $Pipeline } | Select-Object -ExpandProperty Name
    foreach ($PipelineName in $Pipelines) {
        $PipelineConfiguration = Get-GocdPipelineConfiguration -Pipeline $PipelineName
        
        foreach ($Stage in $PipelineConfiguration.stages) {
            foreach ($Job in $Stage.jobs) {
                foreach ($Resource in $Job.resources) {
                    [pscustomobject]@{
                        Pipeline = $PipelineName
                        Stage    = $Stage.Name
                        Job      = $Job.Name
                        Resource = $Resource
                    }
                }
            }
        }
    }
}