function Get-HubLicenseText {
    <#
      .SYNOPSIS
        Obtains the text of a single (i.e. not conjunctive or disjunctive) license.
      .DESCRIPTION
        Obtains the text of a single (i.e. not conjunctive or disjunctive) license. If applying to licenses that may be single or compound, pipe the licenses to ForEach-Object {Unwrap-HubLicense $_} first.
      .EXAMPLE     
  #>
    [OutputType([HubLicense])]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'The license whose text is to be retrieved', Mandatory = $true)]
        [HubSingleLicense] $License
    )
    begin {
        VerifyHubLogin
    }
    process {
        Write-Debug "Retrieving text of $($License.LicenseDisplay)"
        Invoke-RestMethod "$($License.licenseHref)/text" @hubInvocationParams
    }
}
