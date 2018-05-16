function Unwrap-HubLicense {
    <#
      .SYNOPSIS
        Unwraps compound (conjunctive/disjunctive) license.
      .DESCRIPTION
        If the -License argument is a compound license (conjunctive or disjunctive), this CMDlet returns its constituent licenses. If any of those constituent licenses is itself compound, it unwraps that license. The returned list of licenses contains individual licenses only with all compound descendant licenses unwrapped. 

        If the -License argument is not a compound license, this CMDlet merely returns that argument.
      .EXAMPLE      
  #>
    [OutputType([HubSingleLicense])]
    Param(
        [Parameter(ValueFromPipeline, HelpMessage = 'The license to be unwrapped', Mandatory = $true)]
        [HubLicense] $License
    )
    process {
        Write-Debug "Unwrapping $License"
        if (($License.GetType() -eq [HubCompoundLicense]) -or
            ($License.GetType().IsSubclassOf([HubCompoundLicense]))) {
            $unwrappedLicenses = @()
            $License.Licenses | ForEach-Object {
                $unwrappedLicenses += Unwrap-HubLicense $_
            }
            Write-Debug "returning ${unwrappedLicenses}"
            return $unwrappedLicenses
        }
        else {
            return $License
        }
    }

}