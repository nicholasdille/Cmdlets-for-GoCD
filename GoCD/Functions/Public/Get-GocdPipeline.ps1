function Get-GocdPipeline {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $PipelineGroup = '*'
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Groups = Get-GocdPipelineGroup -Raw
    $Groups = $Groups | Where-Object { $_.name -like $PipelineGroup }

    if ($Raw) {
        $Groups
        return
    }

    foreach ($Group in $Groups) {
        foreach ($Pipeline in $Group.pipelines) {
            [pscustomobject]@{
                Group      = $Group.name
                Name       = $Pipeline.name
                PSTypeName = 'GocdPipeline'
            }
        }
    }
}