function Get-GocdBuildingJob {
    [CmdletBinding()]
    param()

    $Agents = Get-GocdAgent -State Building

    $Agents | ForEach-Object {
        $_.build_details._links.job.href
    }
}