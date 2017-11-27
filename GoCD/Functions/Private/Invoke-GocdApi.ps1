#requires -Version 4
#requires -Modules WebRequest

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
    $IwrParams = @{
        Uri     = "$($Gocd.Server)$Path"
        Method  = $Method
        User    = $Gocd.User
        Token   = $Gocd.Token
        Headers = $Headers
    }
    if ($Body) {
        $IwrParams.Add('Body', $Body)
    }
    Invoke-AuthenticatedWebRequest @IwrParams
}