function Add-HubRole {
    <#
      .SYNOPSIS
       Adds a role to a Hub user or group
      .DESCRIPTION
        
      .EXAMPLE     
  #>

    [CmdletBinding()]
    Param(
        #The role to be added
        [Parameter(HelpMessage = 'The Role to be added', Mandatory = $true, Position = 1)]
        [BlackDuck.Hub.Role] $Role,

        #The user to which the role is to be added
        [Parameter(HelpMessage = 'The user to be added to the group', Mandatory = $true, Position = 2, ParameterSetName = 'User')]
        [BlackDuck.Hub.User] $User,

        #The group to which the role is to be added
        [Parameter(HelpMessage = 'The group to which the user is to be added', Mandatory = $true, Position = 2, ParameterSetName = 'Group')]
        [BlackDuck.Hub.UserGroup] $UserGroup,

        #Whether or not the legacy group API needs to be used. Use only with Hub v3.x
        [Parameter(HelpMessage = 'Use legacy group API', ParameterSetName = 'Group')]
        [switch] $Legacy

    )


    VerifyHubLogin

    $postBody = @{
        "role" = $Role.href;
        "name" = $Role.Name
    }
    
    if ($User) {
        $postUrl = "$($User.href)/roles"
    }
    else {
        $postUrl = "$($UserGroup.href)/roles"
        if ($Legacy) {
            #For 3.x APIs
            $postUrl = $postUrl.Replace("/api/", "/api/internal/")
            $postBody["role"] = $Role.href.replace("/api/", "/api/internal/")
        }
    }

    Write-Verbose "Sending `n $($postBody.ToString())"
    try {
        $raw = Invoke-RestMethod -Method Post -Uri $postUrl  -ContentType "application/json" -Body ($postBody | ConvertTo-Json) @Global:hubInvocationParams        
        return $?
    }
    catch {
        handleHubError($_)
    }
}
