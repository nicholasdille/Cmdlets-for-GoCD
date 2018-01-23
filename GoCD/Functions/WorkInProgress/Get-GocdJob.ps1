function Get-GocdJob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Pipeline
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Stage
    )

    $Config = Get-GocdPipelineConfiguration -Pipeline $Pipeline
    $Config | ConvertFrom-Json | Select-Object -ExpandProperty stages | Where-Object { $_.name -ieq $Stage } | Select-Object -ExpandProperty jobs | Select-Object -ExpandProperty name
}