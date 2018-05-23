function New-HubUser {
    <#
      .SYNOPSIS
       Creates a new Hub user
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.User])]
    Param(
        [Parameter(HelpMessage='The username and password of the user to create', Mandatory=$true)]
        [pscredential] $Credential,

        [Parameter(HelpMessage='The first name of the group to create', Mandatory=$true)]
        [string] $FirstName,

        [Parameter(HelpMessage='The last name of the group to create', Mandatory=$true)]
        [string] $LastName,

        [Parameter(HelpMessage='Email Address of the user to create', Mandatory=$true)]
        [string] $Email,

        [Parameter(HelpMessage='Make the group inactive')]
        [switch] $Inactive

    )


    VerifyHubLogin

    #Using V1 API for backward compatibility
    $url="${Global:hubUrl}/api/users"

    $postParams=@{
        "userName" = $Credential.UserName
        "firstName" = $FirstName;
        "lastName" = $LastName;
        "email" = "$Email";
        "active" = $(!$Inactive.IsPresent);
        "type" = "INTERNAL";
        "password" = $Credential.GetNetworkCredential().Password;
    }
    try{
        $raw=Invoke-RestMethod -Method Post -Uri $url  -ContentType "application/json" -Body ($postParams | ConvertTo-Json) @Global:hubInvocationParams        
        return [BlackDuck.Hub.User]::Parse($raw)
    } catch {
        Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"       
        throw $_.Exception
    }
}
