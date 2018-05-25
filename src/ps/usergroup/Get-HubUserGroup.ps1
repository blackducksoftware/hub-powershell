function Get-HubUserGroup {
    <#
      .SYNOPSIS
        Obtains user groups defined on the hub instance
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.UserGroup])]
    Param(
        #The maximum number of groups to return
        [Parameter(HelpMessage='The maximum number of user groups to return')]
        [int] $Limit = $hubDefaultLimit,

        #If set, only active user grousp will be returned
        [Parameter(HelpMessage='If set, only active user groups will be returned')]
        [switch] $ActiveOnly,

        #A custom query (e.g. a substring of the group name)
        [Parameter(HelpMessage='Query narowing the range of results to return', ParameterSetName="Query")]
        [string] $Query,

        #The name of the group to return
        [Parameter(HelpMessage='The name of the user group to look up', ParameterSetName="ByName")]
        [string] $Name
    )


    VerifyHubLogin

    $url="${Global:hubUrl}/api/usergroups?limit=${Limit}"

    if ($ActiveOnly) {
        $url="${url}&activeOnly=true"
    }

    if ($Name){
        $Query = $Name
    }
    if ($Query){
        $url="${url}&q=${Query}"
    }

    $raw=Invoke-RestMethod -Uri $url @Global:hubInvocationParams     
    $items = $raw.items

    #Remove surplus matches that may have resulted in query lookup for a specific name
    if ($Name) {
        $items = $items | Where-Object {$_.name -eq $Name}
    }
    
    return $items | ForEach-Object { 
        [BlackDuck.Hub.UserGroup]::Parse($_)
    }
}
