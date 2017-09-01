function Get-GocdAgent {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('Unknown', 'Idle', 'Building', 'LostContact', 'Missing')]
        [string]
        $State = '*'
        ,
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path '/api/agents' -Accept 'application/vnd.go.cd.v4+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    $Agents = ConvertFrom-Bytes -Data $ContentBytes -Encoding ASCII | ConvertFrom-Json

    $Agents = $Agents._embedded.agents | Where-Object { $_.agent_state -like $State }

    if ($Raw) {
        $Agents
        return
    }

    $Agents | ForEach-Object {

        $Resources = @()
        if ($_.resources.Length -gt 0) {
            $Resources = $_.resources
        }

        $Environments = @()
        if ($_.environments.Length -gt 0) {
            $Environments = $_.environments
        }

        [pscustomobject]@{
            Name         = $_.hostname
            IPAddress    = $_.ip_address
            Enabled      = $_.agent_config_state -ieq 'Enabled'
            State        = $_.agent_state
            Resources    = $Resources
            Environments = $Environments
            Uuid         = $_.uuid
            PSTypeName   = 'GocdAgent'
        }
    }
}