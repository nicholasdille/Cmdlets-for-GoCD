function Test-GocdServer {
    [CmdletBinding()]
    param()

    $script:GocdServer -and $script:GocdUser -and $script:GocdToken
}