function Get-GocdRole {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Role = '*'
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path "/api/admin/security/roles" -Accept 'application/vnd.go.cd.v1+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    $Roles = ConvertFrom-ByteArray -Data $ContentBytes -Encoding ASCII | ConvertFrom-Json
    $Roles = $Roles._embedded.roles | Where-Object { $_.name -like $Role }

    if ($Raw) {
        $Roles
        return
    }

    foreach ($Item in $Roles) {
        $Item.attributes.users | ForEach-Object {
            [pscustomobject]@{
                Role = $Item.name
                User = $_
            }
        }
    }
}