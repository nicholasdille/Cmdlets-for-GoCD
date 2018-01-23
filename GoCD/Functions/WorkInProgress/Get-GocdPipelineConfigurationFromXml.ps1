function Get-GocdPipelineConfigurationFromXml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [xml]
        $Configuration
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Pipeline
    )

    process {
        $Configuration.cruise.pipelines.pipeline | Where-Object { $_.name -like $Pipeline }
    }
}