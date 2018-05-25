function Remove-HubProjectVersion {
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'The version to be deleted', Mandatory = $true)]
        [HubProjectVersion] $VersionToRemove
    )
  
    begin {
        VerifyHubLogin
    }
    process {
        $url = ''

        if ($VersionToRemove -and ![string]::IsNullOrEmpty($VersionToRemove.href)) {
            $url = $VersionToRemove.href 
        } 
        else {
            throw "Not a valid version to remove: ${VersionToRemove}"
        }

        try{
            $result = Invoke-RestMethod -Uri $url -Method Delete @global:hubInvocationParams
        } catch {
            handleHubError($_)
        }
    }
}