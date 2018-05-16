function Get-HubProjectVersion {
    [OutputType([HubProjectVersion])]

    Param(
        # Project name to get
        [Parameter(ValueFromPipeline, HelpMessage = 'The Project whose version to retrieve', Mandatory = $true, ParameterSetName = 'ProjectInPipeline')]
        [HubProject] $Project,

        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $true, ParameterSetName = 'ReferencesProjectVersions', DontShow )]
        [string] $projectVersionHref
    )
    
    begin {
        VerifyHubLogin
        Write-Debug "$($Projects.Length)"
    }
    process {
        if ($Project) { #Querying all versions for a project
            $url = "${global:hubUrl}/api/projects/$($Project.Id)/versions?limit=${hubDefaultLimit}" 
            $projectsJson = (Invoke-RestMethod $url @global:hubInvocationParams)
            return $projectsJson.items | ForEach-Object {
                [HubProjectVersion]::Parse($_)
            }
        } else { #Querying single version from an argument
            try {
                $rawResult = (Invoke-RestMethod -FollowRelLink $projectVersionHref @global:hubInvocationParams)
                return [HubProjectVersion]::Parse($rawResult)
            }
            catch [Microsoft.PowerShell.Commands.HttpResponseException]{
                if ($_.Exception.Response.StatusCode -eq "NotFound") {
                    Write-Error -Category ObjectNotFound "Project Version not found: $($projectVersionHref.TrimStart($global:hubUrl))"
                    return $null
                } else {
                    Write-Error "Unable to access ${projectVersionHref}: `n$($_.Exception)"
                    return $null
                }
            }
        }
    }
}