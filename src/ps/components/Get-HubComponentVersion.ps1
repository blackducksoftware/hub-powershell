function Get-HubComponentVersion {
    Param(
        [Parameter(parameterSetName = 'ProjectVersion', ValueFromPipeline, HelpMessage = 'The project version whose BOM component-versions are to be listed', Mandatory = $true, Position = 0)]
        [HubProjectVersion] $ProjectVersion,

        [Parameter(parameterSetName = 'ComponentVersionHref', ValueFromPipelineByPropertyName, HelpMessage = 'The project version whose BOM component-versions are to be listed', Mandatory = $true, Position = 0, DontShow)]
        [string] $componentVersionHref
    )

    begin{
        VerifyHubLogin
    }
    process {
        if ($componentVersionHref){
            $raw = Invoke-RestMethod $componentVersionHref @global:hubInvocationParams 
            return [HubComponentVersion]::Parse($raw) 
        }
        elseIf ([string]::IsNullOrEmpty($ProjectVersion.href)) {
            throw 'Bad or invalid ProjectVersion argument (missing href)'
        } else {
            $url = "$($ProjectVersion.href)/components"

            $componentsJson = Invoke-RestMethod $url @global:hubInvocationParams  
            return $componentsJson.items | ForEach-Object {[HubComponentVersion]::Parse($_)}
        }
    }
}