function Get-GocdResource {
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]
        $ByAgent
    )

    $Agents = Get-GocdAgent

    foreach ($Agent in $Agents) {
        $Agent.Resources | ForEach-Object {
            [pscustomobject]@{
                Agent = $Agent.Name
                Resource = $_
            }
        }
    }
}