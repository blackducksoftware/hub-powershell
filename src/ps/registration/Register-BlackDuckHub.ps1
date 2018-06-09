function Register-BlackDuckHub {
    <#
     .SYNOPSIS
     Activates a Black Duck Hub installation with the specified registration key

     .EXAMPLE
     Register-BlackDuckHub -RegistrationKey "my_hub_registration_key"
     ---------------------------------------------------------------
     Attempts to activate the current Hub instance (from the most recent call to the Login-BlackDuckHub command) with the registration key "my_hub_registration_key"

   #>
    Param(
        #The URL of the Hub instance
        [Parameter(HelpMessage = 'RegistrationKey', Mandatory = $true, Position = 1)]
        [string]$RegistrationKey

    )
   
    VerifyHubLogin

    $registerUrl = "${global:hubUrl}/api/v1/registrations"

    # Get the current registration state
    $registrationRequest = Invoke-RestMethod -Uri $registerUrl -Method Get @global:hubInvocationParams 
    # Update the registration key
    $registrationRequest.registrationId = $RegistrationKey 
    $result = Invoke-RestMethod -Uri $registerUrl -Method Post -Body ($registrationRequest | convertto-json) -ContentType "application/json"  @global:hubInvocationParams        

    if (!$result -or $result.state -ne 'VALID'){
        Write-Error "Registration has not been successful. Please check your registration key."
    } else {
        Write-Host "Hub successfully activated."
    }
}
