function Compare-GocdPipelineConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [xml]
        $Reference
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [xml]
        $Difference
    )

    Compare-Object -ReferenceObject $Reference -DifferenceObject $Difference -PassThru
}