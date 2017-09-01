function Get-GocdServer {
    [CmdletBinding()]
    param()

    if (-Not (Test-GocdServer)) {
        throw 'Credentials not set. Please use Set-GocdServer first.'
    }

    @{
        Server = $script:GocdServer
        User   = $script:GocdUser
        Token  = $script:GocdToken
    }
}