function New-HubUserGroup {
    <#
      .SYNOPSIS
       Creates a new Hub user group
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.UserGroup])]
    Param(
        [Parameter(HelpMessage='The name of the group to create', Mandatory=$true, Position=1)]
        [string] $Name,

        [Parameter(HelpMessage='Make the group inactive')]
        [switch] $Inactive
    )


    VerifyHubLogin

    #Using V1 API for backward compatibility
    $url="${Global:hubUrl}/api/v1/usergroups"

    $postParams=@{
        "name" = $Name;
        "active" = $(!$Inactive.IsPresent)
        "createdFrom" = "INTERNAL"
    }
    try{
        $raw=Invoke-RestMethod -Method Post -Uri $url  -ContentType "application/json" -Body ($postParams | ConvertTo-Json) @Global:hubInvocationParams        
        #Uncomment after switching from V1 API
        #return [BlackDuck.Hub.UserGroup]::Parse($raw)
        return Get-HubUserGroup -Query "$($raw.Name)"
    } catch {
        Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"       
        throw $_.Exception
    }
}
