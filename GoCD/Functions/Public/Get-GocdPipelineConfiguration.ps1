function Get-GocdPipelineConfiguration {
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

    $Response = Invoke-GocdApi -Path "/api/admin/pipelines/$Pipeline" -Accept 'application/vnd.go.cd.v4+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    $Content = ConvertFrom-ByteArray -Data $ContentBytes -Encoding ASCII

    if ($Raw) {
        $Content
        return
    }

    $Content | ConvertFrom-Json
}