function Get-GocdConfiguration {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $MD5 = 'current'
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path "/api/admin/config/$MD5.xml"
    $Content = $Response | Select-Object -ExpandProperty Content

    if ($Raw) {
        $Content
        return
    }

    [xml]$Content
}