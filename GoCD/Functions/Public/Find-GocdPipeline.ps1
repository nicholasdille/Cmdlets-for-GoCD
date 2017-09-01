function Find-GocdPipeline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Pipeline
    )

    $Groups = Get-GocdPipelineGroup -Raw

    foreach ($Group in $Groups) {
        $Group.pipelines | Where-Object { $_.name -ieq $Pipeline } | ForEach-Object {
            [pscustomobject]@{
                Group      = $Group.name
                Name       = $_.name
                PSTypeName = 'GocdPipeline'
            }
        }
    }
}