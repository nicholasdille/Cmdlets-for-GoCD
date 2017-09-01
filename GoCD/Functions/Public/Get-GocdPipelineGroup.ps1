function Get-GocdPipelineGroup {
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path '/api/config/pipeline_groups'
    $Groups = $Response | Select-Object -ExpandProperty Content | ConvertFrom-Json

    if ($Raw) {
        $Groups
        return
    }
    
    $Groups | ForEach-Object {
        $_.name
    }
}