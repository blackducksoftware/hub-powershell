. ${PSScriptRoot}/init.ps1
add-type -Path ${PSScriptRoot}/Blackduck.Hub.Powershell.dll 

function VerifyHubLogin() {
    if (!$global:hubInvocationParams) {
        throw 'Please use Login-BlackDuckHub to log in to hub prior to running other Hub CMDLets'
    }
}
function UrlEncode($url) {
    return [System.Web.HttpUtility]::UrlEncode($url)
}

function CombineQueryParams($paramMap) {
    $result = (New-Object 'System.Text.StringBuilder')
    ForEach-Object -InputObject $paramMap.Keys -Process {
        $value = $paramMap[$_]
        $result = $result.Append(",").Append((UrlEncode("${_}:${value}")))
    }
    $result = $result.Remove(0, 1)
    return $result.ToString()
}

# Login CMDLets
. ${PSScriptRoot}/login/Login-BlackDuckHub.ps1
. ${PSScriptRoot}/login/Logout-BlackDuckHub.ps1

# License CMDLets
. ${PSScriptRoot}/licenses/Unwrap-HubLicense.ps1
. ${PSScriptRoot}/licenses/Get-HubLicenseText.ps1

# Component CMDLets
. ${PSScriptRoot}/components/Get-HubComponentVersion.ps1

# Notifications CMDLets
. ${PSScriptRoot}/notifications/Get-HubNotifications.ps1

# Project CMDLets
. ${PSScriptRoot}/projects/Get-HubProject.ps1
. ${PSScriptRoot}/projects/Get-HubProjectVersion.ps1
. ${PSScriptRoot}/projects/Remove-HubProjectVersion.ps1
. ${PSScriptRoot}/projects/Remove-HubProject.ps1

# Upload CMDLets
. ${PSScriptRoot}/upload/Upload-HubBom.ps1
. ${PSScriptRoot}/upload/Upload-HubScan.ps1

# User/Group CMDLets
. ${PSScriptRoot}/usergroup/Get-HubUserGroup.ps1
. ${PSScriptRoot}/usergroup/New-HubUserGroup.ps1
. ${PSScriptRoot}/usergroup/Remove-HubUserGroup.ps1
. ${PSScriptRoot}/usergroup/Remove-HubUserGroupV1.ps1
. ${PSScriptRoot}/usergroup/Get-HubUser.ps1
. ${PSScriptRoot}/usergroup/New-HubUser.ps1
