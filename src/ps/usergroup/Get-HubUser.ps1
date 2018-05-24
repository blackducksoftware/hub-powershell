function Get-HubUser {
    <#
      .SYNOPSIS
        Obtains users defined on the hub instance
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.User])]
    Param(
        [Parameter(HelpMessage='The maximum number of users to return',ParameterSetName='ListUsers')]
        [int] $Limit = $hubDefaultLimit,

        [Parameter(HelpMessage='If set, only active users will be returned',ParameterSetName='ListUsers')]
        [switch] $ActiveOnly,

        # Parameter help description
        [Parameter(HelpMessage='A username to look up', ParameterSetName='SingleUser',Mandatory=$True)]
        [string] $UserName
    )


    VerifyHubLogin



    if ($UserName){
        $url="${Global:hubUrl}/api/users?q=userName:$([System.Web.HttpUtility]::UrlEncode($UserName))"
    } else {
        $url="${Global:hubUrl}/api/users?limit=${Limit}"
    }

    if ($ActiveOnly) {
        $url="${url}&activeOnly=true"
    }


    $raw=Invoke-RestMethod -Uri $url @Global:hubInvocationParams        
    $items = $raw.items

    #The query API returns lexicographic substring matches as well as the full match. Filter out the excesses
    if ($UserName) {
        $items = $items | ? {$_.userName -eq $UserName}
    }

    return $items| ForEach-Object { 
        [BlackDuck.Hub.User]::Parse($_)
    }
}
