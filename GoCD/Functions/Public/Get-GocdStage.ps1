function Get-GocdStage {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Pipeline = '*'
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $PipelineGroups = Get-GocdPipelineGroup -Raw

    $Pipelines = foreach ($Group in $PipelineGroups) {
        $Group.pipelines | Where-Object { $_.name -like $Pipeline }
    }

    if ($Raw) {
        $Pipelines
        return
    }

    foreach ($Item in $Pipelines) {
        [pscustomobject]@{
            Pipeline = $Item.name
            Stages   = @($Item.stages | Select-Object -ExpandProperty name)
        }
    }
}