function Remove-HubUserGroup {
    <#
      .SYNOPSIS
     Removes a hub user group
      .DESCRIPTION
      
      .EXAMPLE      
  #>

    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'The user group to be deleted', Mandatory = $true)]
        [BlackDuck.Hub.UserGroup] $UserGroupToRemove
    )
  
    begin {
      #  VerifyHubLogin
    } 
    process {
        $url = ''

        if ($UserGroupToRemove -and ![string]::IsNullOrEmpty($UserGroupToRemove.href)) {
            $url = $UserGroupToRemove.href 
        } 
        else {
            throw "Not a valid user group to remove: ${UserGroupToRemove}"
        }

        $result = Invoke-RestMethod -Uri $url -Method Delete @global:hubInvocationParams -FollowRelLink
    }
}