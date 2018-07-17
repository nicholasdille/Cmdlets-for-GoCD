function Set-GocdServer {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Server
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $User
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Token = (Read-Host -Prompt 'Password' -AsSecureString | Get-PlaintextFromSecureString)
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    process {
        if ($Force -or $PSCmdlet.ShouldProcess("Update credentials to user server '$Server' and user '$User'?")) {
            $script:GocdServer = $Server
            $script:GocdUser   = $User
            $script:GocdToken  = $Token
        }
    }
}
