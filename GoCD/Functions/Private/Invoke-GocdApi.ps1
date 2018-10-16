#requires -Version 4

function Invoke-GocdApi {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
        ,
        [Parameter()]
        [ValidateSet('Delete', 'Get', 'Post', 'Put')]
        [string]
        $Method = 'Get'
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $Headers = @{}
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Accept = 'application/json'
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Body
    )

    if ($Headers.ContainsKey('Accept')) {
        $Headers.Accept = $Accept

    } else {
        $Headers.Add('Accept', $Accept)
    }

    $Gocd = Get-GocdServer
    $AuthString = Get-BasicAuthentication -User $Gocd.User -Token $Gocd.Token
    $Headers.Add('Authorization', "Basic $AuthString")

    $IwrParams = @{
        Uri     = "$($Gocd.Server)$Path"
        Method  = $Method
        Headers = $Headers
    }
    if ($Body) {
        $IwrParams.Add('Body', $Body)
    }
    Invoke-WebRequest @IwrParams
}