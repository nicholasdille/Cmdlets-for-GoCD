#requires -Version 4
#requires -Modules Helper

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
    )

    if ($Headers.ContainsKey('Accept')) {
        $Headers.Accept = $Accept
    
    } else {
        $Headers.Add('Accept', $Accept)
    }

    $Gocd = Get-GocdServer
    Invoke-AuthenticatedWebRequest -Uri "$($Gocd.Server)$Path" -Method $Method -User $Gocd.User -Token $Gocd.Token -Headers $Headers
}