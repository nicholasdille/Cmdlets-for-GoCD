function Get-GocdPipelineHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Pipeline
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path "/api/pipelines/$Pipeline/history"
    $History = $Response | Select-Object -ExpandProperty Content | ConvertFrom-Json

    if ($Raw) {
        $History
        return
    }

    #
}