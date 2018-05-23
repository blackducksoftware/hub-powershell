function Login-BlackDuckHub {
     <#
      .SYNOPSIS
      Logs into to an instance of the Black Duck Hub. Required before running any other Hub CMDlets

      .DESCRIPTION
      Performs a Log-in operation with the Hub instance.

      .EXAMPLE
      Login-BlackDuckHub -Url https://myhubinstance -AlwaysTrustCert
      ---------------------------------------------------------------
      Logs into an instance of the Hub the specified URL, where there certificate may be self-signed. A secure prompt for the user-name and password will appear. Note: due to the necessary manual entry of credentials, this authentication method is not suitable for scripting.


      Login-BlackDuckHub -Url https://myhubinstance -Token $myToken
      ---------------------------------------------------------------
      Logs into an instance of the Hub the specified URL using an API token stored in $myToken. Because this approach eliminates the need to enter credentials, it is suitable (and necessary) for scripting. 


    #>
    [cmdletbinding(
        DefaultParameterSetName='CredAuth'
    )]
    Param(
        #The URL of the Hub instance
        [Parameter(HelpMessage = 'Hub URL', Mandatory = $true, Position = 1)]
        [string]$Url,
    
        #Whether or not Hub's certificate should be trusted if its signer is unknown
        [Parameter(HelpMessage = 'If true, connecting to hub instance with an untrusted certificate signer will be allowed.')]
        [switch]$AlwaysTrustCert=$false,

        #The Hub API token to use for authentication.
        [Parameter(HelpMessage = 'Hub API Token. If specified, it will be used in leau of username and password for authentication', ParameterSetName='TokenAuth', Mandatory=$true, Position=2)]
        [string]$Token,

        #The Username/Password credential for authentication. This authentication mechanism may be deprecated in the future, so use token authentication whenever possible.
        [Parameter(HelpMessage='Hub Username&Password credential', ParameterSetName='CredAuth', Position=2)]
        [PSCredential] $Credential
    )
    
    $hubInvocationParams = @{
        'SkipCertificateCheck'=$AlwaysTrustCert
    }

    #Remove trailing slash from URL
    $Url = $Url.TrimEnd('/')

    if ($Token){
        $authHeaders = @{'Authorization' = "token ${Token}"}
        $responseBody = Invoke-RestMethod -Method Post -Uri "${Url}/api/tokens/authenticate" -Headers $authHeaders -ResponseHeadersVariable loginResponse @hubInvocationParams
        $invocationHeaders = @{'Cookie'= "AUTHORIZATION_BEARER=$($responseBody.bearerToken)" }  
    }
    else {    
        if (!$Credential){
            $Credential = Get-Credential -Message "Please enter your Black Duck Hub login credentials." -Title "Black Duck Hub Login"
        }
        $body="j_username=$([System.Web.HttpUtility]::UrlEncode($Credential.UserName))&j_password=$([System.Web.HttpUtility]::UrlEncode($Credential.GetNetworkCredential().Password))"
        Invoke-RestMethod -Method Post -ContentType "application/x-www-form-urlencoded" -Uri "${url}/j_spring_security_check" -Body $body @hubInvocationParams -ResponseHeadersVariable loginResponse
        Remove-Variable body
        $invocationHeaders = @{'Cookie'= $loginResponse['Set-Cookie'][0]}  
    }
    
    if ($loginResponse['X-CSRF-TOKEN']){
        $invocationHeaders['X-CSRF-TOKEN']=$loginResponse['X-CSRF-TOKEN'][0]
    }

    #Populate hub invocation data in the session
    $global:hubUrl=$Url
    $global:hubInvocationParams = $hubInvocationParams
    $global:hubInvocationParams['Headers'] = $invocationHeaders

}