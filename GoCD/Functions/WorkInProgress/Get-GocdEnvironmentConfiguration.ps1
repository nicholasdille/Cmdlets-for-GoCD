function Get-GocdEnvironmentConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Environment
    )

    $Response = Invoke-GocdApi -Path "/api/admin/environments/$Environment" -Accept 'application/vnd.go.cd.v2+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    ConvertFrom-Bytes -Data $ContentBytes -Encoding ASCII | ConvertFrom-Json
}