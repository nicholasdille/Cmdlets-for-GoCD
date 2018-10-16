function Get-GocdEnvironment {
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch]
        $Raw
    )

    $Response = Invoke-GocdApi -Path '/api/admin/environments' -Accept 'application/vnd.go.cd.v2+json'
    $ContentBytes = $Response | Select-Object -ExpandProperty Content
    $Content = ConvertFrom-ByteArray -Data $ContentBytes -Encoding ASCII | ConvertFrom-Json

    if ($Raw) {
        $Content
        return
    }

    $Content._embedded.environments | ForEach-Object {

        $Pipelines = @()
        if ($_.pipelines.Length -gt 0) {
            $Pipelines = @($_.pipelines.name)
        }

        $Agents = @()
        if ($_.agents.Length -gt 0) {
            $Agents = @($_.agents.uuid)
        }

        $Variables = @()
        if ($_.environment_variables.Length -gt 0) {
            $Variables = @($_.environment_variables.name)
        }

        [pscustomobject]@{
            Name       = $_.name
            Pipelines  = $Pipelines
            Agents     = $Agents
            Variables  = $Variables
            PSTypeName = 'GocdEnvironment'
        }
    }
}