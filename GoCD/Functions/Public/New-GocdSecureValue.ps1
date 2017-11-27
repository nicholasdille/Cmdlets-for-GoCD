function New-GocdSecureValue {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        "PSUseShouldProcessForStateChangingFunctions", 
        "", 
        Justification = "Creates in-memory object only."
    )]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Value
    )

    $Data = '{"value":"' + $Value + '"}'
    $Response = Invoke-GocdApi -Path '/api/admin/encrypt' -Accept 'application/vnd.go.cd.v1+json' -Headers @{'Content-Type' = 'application/json'} -Body $Data -Method Post
    $Response | ConvertFrom-Json | Select-Object -ExpandProperty encrypted_value
}