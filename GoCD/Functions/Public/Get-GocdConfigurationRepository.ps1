function Get-GocdConfigurationRepository {
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]
        $Raw
    )

    & git clone "https://$script:GocdUser:$script:GocdToken@$script:GocdServer/api/config-repository.git"
}