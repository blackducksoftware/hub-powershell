function Get-HubUserGroup {
    <#
      .SYNOPSIS
        Obtains user groups defined on the hub instance
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.UserGroup])]
    Param(
        [Parameter(HelpMessage='The maximum number of user groups to return')]
        [int] $Limit = $hubDefaultLimit,

        [Parameter(HelpMessage='If set, only active user groups will be returned')]
        [switch] $ActiveOnly,

        # Parameter help description
        [Parameter(HelpMessage='Query narowing the range of results to return')]
        [string] $Query
    )


    VerifyHubLogin

    $url="${Global:hubUrl}/api/usergroups?limit=${Limit}"

    if ($ActiveOnly) {
        $url="${url}&activeOnly=true"
    }

    if ($Query){
        $url="${url}&q=${Query}"
    }

    $raw=Invoke-RestMethod -Uri $url @Global:hubInvocationParams        
    return $raw.items | ForEach-Object { 
        [BlackDuck.Hub.UserGroup]::Parse($_)
    }
}
