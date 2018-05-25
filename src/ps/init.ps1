$hubDefaultLimit = [int]::MaxValue

function handleHubError($hubError) {
    if ($hubError.ErrorDetails -and $hubError.ErrorDetails.Message) {
        $returnData = ConvertFrom-Json $hubError.ErrorDetails.Message
        Write-Error "$($returnData.errorMessage) (Status $($_.Exception.Response.StatusCode.value__))"
    } else {
        Write-Error "StatusCode: $($_.Exception.Response.StatusCode.value__)"       
    }
}

. ${PSScriptRoot}/licenses/licenses.ps1
. ${PSScriptRoot}/components/components.ps1
. ${PSScriptRoot}/projects/projects.ps1
