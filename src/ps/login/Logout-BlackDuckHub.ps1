function Logout-BlackDuckHub {
     <#
      .SYNOPSIS
      Logs out of the Black Duck Hub
      .DESCRIPTION
      Logs out of the Black Duck Hub and removes session information from the session
      .EXAMPLE
      Logout-BlackDuckHub
    #>

    VerifyHubLogin

    $res=Invoke-WebRequest "${global:hubUrl}/j_spring_security_logout" @global:hubInvocationParams  
    
    #Handle error code
    if ($res.StatusCode -lt 200 -or $res.Status -ge 300 ) {
        throw "Error $($res.StatusCode). Unable to log out."
    }

    Remove-Variable hubUrl -Scope global -Force
    Remove-Variable hubInvocationParams -Scope global -Force

}