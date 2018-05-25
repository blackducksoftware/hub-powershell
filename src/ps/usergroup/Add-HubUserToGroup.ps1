function Add-HubUserToGroup {
    <#
      .SYNOPSIS
       Adds a hub user to a user group
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.User])]
    Param(
        [Parameter(HelpMessage='The user to be added to the group', Mandatory=$true, Position=1)]
        [BlackDuck.Hub.User] $User,

        [Parameter(HelpMessage='The group to which the user is to be added', Mandatory=$true, Position=2)]
        [BlackDuck.Hub.UserGroup] $UserGroup
    )


    VerifyHubLogin

    $postBody="[$(
        @{
            "userGroupUrl" = $UserGroup.href
        } | ConvertTo-Json
    )]"
    $postUrl = "$($User.href)/usergroups"
    try{
        $raw=Invoke-RestMethod -Method Post -Uri $postUrl  -ContentType "application/json" -Body $postBody @Global:hubInvocationParams        
        return $?
    } catch {
        handleHubError($_)
    }
}
