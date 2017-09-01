function Set-GocdServer {
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
    )

    $script:GocdServer = $Server
    $script:GocdUser   = $User
    $script:GocdToken  = $Token
}
