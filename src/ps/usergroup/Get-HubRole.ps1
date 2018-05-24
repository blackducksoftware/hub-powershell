function Get-HubRole {
    <#
      .SYNOPSIS
        Obtains available user roles
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.Role])]
    Param(
        [Parameter(HelpMessage='The maximum number of users to return',ParameterSetName='ListUsers')]
        [int] $Limit = $hubDefaultLimit
    )

    VerifyHubLogin

    $url="${Global:hubUrl}/api/roles"
   
    $raw=Invoke-RestMethod -Uri $url @Global:hubInvocationParams        
    return $raw.items | ForEach-Object { 
        [BlackDuck.Hub.Role]::Parse($_)
    }
}
