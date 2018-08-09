function Remove-HubUserGroupV1 {
    <#
      .SYNOPSIS
     Deprecated. Do not use.
      .DESCRIPTION
      
      .EXAMPLE      
  #>

    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'The project to be deleted', Mandatory = $true)]
        [BlackDuck.Hub.UserGroup] $UserGroupToRemove
    )
  
    begin {
      #  VerifyHubLogin
    } 
    process {
        $url = ''

        if ($UserGroupToRemove -and ![string]::IsNullOrEmpty($UserGroupToRemove.href)) {
            $url = $UserGroupToRemove.href.replace("/api/", "/api/v1/")
        } 
        else {
            throw "Not a valid user group to remove: ${UserGroupToRemove}"
        }
        try{
            $result = Invoke-RestMethod -Uri $url -Method Delete @global:hubInvocationParams -FollowRelLink
        } catch {
            handleHubError($_)
        }
    }
}
