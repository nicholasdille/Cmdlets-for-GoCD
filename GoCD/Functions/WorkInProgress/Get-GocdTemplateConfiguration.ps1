function Get-GocdTemplateConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Server
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $User
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Token
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Template
    )

    $Response = Invoke-GocdApi -Path "/api/admin/templates/$Template" -Accept 'application/vnd.go.cd.v3+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    $Content = ConvertFrom-Bytes -Data $ContentBytes -Encoding ASCII
    $Content
}