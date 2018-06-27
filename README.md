# PowerShell Core modules for Hub

With PowerShell, it is easier than ever to perform and automate routine Black Duck Hub tasks and generate custom reports not provided by the web interface.

# Under Construction :construction:
**Caution:** These tools are currently are still under development. They are not presently supported by Black Duck, and your use of them is entirely at your own risk.

# Installation from PowerShell Gallery

In Power-Shell, enter:

```
    Install-Module BlackDuck.Hub
```

# Building
*Requires .Net Core 2.0+*

Switch to the `src` directory and run `dotnet build`

# Installing from Local Build

Copy the "publish" directory into the PowerShell Modules directory with the name `BlackDuck.Hub`. e.g.

```
Copy-Item -Recurse  -Recurse ./publish "$(($env:PSModulePath -split ':')[0])/BlackDuck.Hub" 
```

# Publishing to PSGallery

1. Increment the version number in BlackDuck.Hub.psd1
2. Build and install using the instructions above
3. Run 
```
    Publish-Module -Name Blackduck.Hub -NuGetApiKey $nugetApiKey
```

(Your Nuget API key can be obtained from your profile at https://www.powershellgallery.com/account)

# Examples

Show all component versions in the BOM of project 'madplay1'
```
Get-HubProject -name madplay | Get-HubProjectVersion | Get-HubComponentVersion 
```

Show all component versions in the BOM of project 'madplay1' with high risks.
```
Get-HubProject -name madplay | Get-HubProjectVersion | Get-HubComponentVersion | ? {$_.LicenseRiskProfile.High -gt 0 }     
```

Generate a license notification file for a project
```
# First, we get all the component versions as above
$allComponents = Get-HubProject -name madplay  | Get-HubProjectVersion | Get-HubComponentVersion

# Then, we get all the licenses fields of all the versions (these don't contain license texts),
# and expand any conjunctive or disjunctive licenses (unwrap) into their constituent parts
$unwrappedLicenses = $allComponents | select -ExpandProperty Licenses | Unwrap-HubLicense 

# Remove duplicate licenses and get license texts from the Hub
$licenseTexts = $unwrappedLicenses | select -Unique | Get-HubLicenseText

# Finally, combine the license texts into a single string and write them to a file
$separator = "`n`n==============================================================`n`n"
[string]::Join($separator, $licenseTexts) | Out-File /var/tmp/licenses.txt 
```

Get all the project versions affected by vulnerability notifications.
```
Get-HubNotifications | ? Type -eq 'Vulnerability' | select -Expand AffectedProjectVersions | Get-HubProjectVersion
```

Copyright © 2018 Synopsys, Inc. All Rights Reserved.
