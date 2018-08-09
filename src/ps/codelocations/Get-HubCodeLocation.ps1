function Get-HubCodeLocation {
    [OutputType([BlackDuck.Hub.CodeLocation])]
    Param(
   
    )
    VerifyHubLogin
    $url="${global:hubUrl}/api/codelocations"
    $result = Invoke-RestMethod -Uri $url @global:hubInvocationParams
    return $result.items | ForEach-Object {
        [BlackDuck.Hub.CodeLocation]::Parse($_)
    }
}
