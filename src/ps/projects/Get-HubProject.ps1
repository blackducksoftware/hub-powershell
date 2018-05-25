function Get-HubProject {
     <#
      .SYNOPSIS
      Retrieves information about projects in the hub
      .DESCRIPTION
      
      .EXAMPLE      
  #>
  [OutputType([HubProject])]
  
  Param(
      # Project name to get
      [Parameter(HelpMessage='The name of the project to search for')]
      [string] $Name,

      # General purpose query parameter
      [Parameter(HelpMessage='An all-purpose query parameter')]
      [string] $Query
  )

    VerifyHubLogin

    $params=@{}

    if ($Name -and $Query){
        throw '-Name and -Query cannot be used together.'
    }


    if ($Name){
        $params['name']=$Name
        $urlQuery=CombineQueryParams($params)
    }

    if ($Query){
        $urlQuery=UrlEncode($Query)
    }

    $url="${global:hubUrl}/api/projects?limit=${hubDefaultLimit}&q=${urlQuery}" 
    try{ 
        $projectsJson=(Invoke-RestMethod $url @global:hubInvocationParams)
        $items = $projectsJson.items
        Remove-Variable projectsJson
        if ($Name) {
            $items = $items | Where-Object {$_.name -eq $Name}
        }

        return $items | ForEach-Object {[HubProject]::Parse($_)}
    } catch {
        handleHubError($_)
    }
}
