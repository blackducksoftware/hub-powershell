function Remove-HubCodeLocation {
    <#
      .SYNOPSIS
     Removes a hub code location
      .DESCRIPTION
      
      .EXAMPLE      
  #>

    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'The code location to be deleted', Mandatory = $true)]
        [BlackDuck.Hub.CodeLocation] $CodeLocationToRemove
    )
  
    begin {
      #  VerifyHubLogin
    } 
    process {
        $url = ''

        if ($CodeLocationToRemove -and ![string]::IsNullOrEmpty($CodeLocationToRemove.href)) {
            $url = $CodeLocationToRemove.href 
        } 
        else {
            throw "Not a valid code location to remove: ${CodeLocationToRemove}"
        }

        Invoke-RestMethod -Uri $url -Method Delete @global:hubInvocationParams -FollowRelLink > $null
    }
}