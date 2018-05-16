function Get-HubNotifications {
    <#
      .SYNOPSIS
        Obtains all hub notifications available to the logged-in user
      .DESCRIPTION
        
      .EXAMPLE     
  #>
    [OutputType([BlackDuck.Hub.Notification])]
    Param(
        [Parameter(HelpMessage='The maximum number of notifications to return')]
        [int] $Limit = $hubDefaultLimit
    )


    VerifyHubLogin

    $raw=Invoke-RestMethod "${Global:hubUrl}/api/notifications?limit=${Limit}" @Global:hubInvocationParams        
    return $raw.items | ForEach-Object { 
        if ('VULNERABILITY'.Equals($_.type)){
            return [BlackDuck.Hub.VulnerabilityNotification]::Parse($_)    
        }
        elseif ('RULE_VIOLATION'.Equals($_.type)) {
            return [BlackDuck.Hub.RuleViolationNotification]::Parse($_)    
        } 
        else {
            Write-Error "Notifications of type $($_.type) are not yet supported. Skipping."
        }
     }
}
