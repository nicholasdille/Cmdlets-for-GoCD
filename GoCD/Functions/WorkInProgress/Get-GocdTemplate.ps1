function Get-GocdTemplate {
    [CmdletBinding()]
    param()

    $Response = Invoke-GocdApi -Path "/api/admin/templates" -Accept 'application/vnd.go.cd.v3+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    $Content = ConvertFrom-Bytes -Data $ContentBytes -Encoding ASCII | ConvertFrom-Json
    $Content._embedded.templates.name
}