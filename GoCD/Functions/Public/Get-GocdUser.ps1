function Get-GocdUser {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $UserName = '*'
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Login = '*'
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path "/api/users" -Accept 'application/vnd.go.cd.v1+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    $Users = ConvertFrom-Bytes -Data $ContentBytes -Encoding ASCII | ConvertFrom-Json
    $Users = $Users._embedded.users | Where-Object { $_.display_name -like $UserName -and $_.login_name -like $Login }

    if ($Raw) {
        $Users
        return
    }

    foreach ($User in $Users) {
        [pscustomobject]@{
            Name = $User.display_name
            Login = $User.login_name
            Email = $User.email
            Enabled = $User.enabled
        }
    }
}