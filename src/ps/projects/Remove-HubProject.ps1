function Remove-HubProject {
    <#
      .SYNOPSIS
     Removes a hub project
      .DESCRIPTION
      
      .EXAMPLE      
  #>

    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'The project to be deleted', Mandatory = $true)]
        [HubProject] $ProjectToRemove
    )
  
    begin {
        VerifyHubLogin
    } 
    process {
        $url = ''

        if ($ProjectToRemove -and ![string]::IsNullOrEmpty($ProjectToRemove.href)) {
            $url = $ProjectToRemove.href 
        } 
        else {
            throw "Not a valid project to remove: ${ProjectToRemove}"
        }

        $result = Invoke-RestMethod -Uri $url -Method Delete @global:hubInvocationParams
    }
}