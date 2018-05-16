class HubLicense {
    [string] $Type
    [string] $LicenseDisplay

    [string] ToString(){
        return $this.LicenseDisplay
    }
}

class HubSingleLicense : HubLicense {
    hidden [string] $licenseHref;

    HubSingleLicense($licenseHref){
        $this.licenseHref = $licenseHref
    }
}

class HubCompoundLicense : HubLicense {
    [HubLicense[]] $Licenses;

    HubCompoundLicense([HubLicense[]] $licenses){
        $this.Licenses = $licenses
    }
}

 function ParseLicense ($jsonLicense) {
    #On Projects, LicenseType is represented as "type", elsewhere as "licenseType"
    $licenseType = if ($jsonLicense.licenseType) {$jsonLicense.licenseType} else {$jsonLicense.type}

    $licenseProps=@{
        Type = $licenseType;
        LicenseDisplay = $jsonLicense.licenseDisplay;
    }

    if ("CONJUNCTIVE".Equals($licenseType) -or "DISJUNCTIVE".Equals($licenseType)){
        $childLicenses = $jsonLicense.licenses | ForEach-Object { ParseLicense $_ }
        return New-Object HubCompoundLicense -Property $licenseProps -ArgumentList @(,$childLicenses)
    }
    else {
        $licenseHref=$jsonLicense.license
        return New-Object HubSingleLicense -ArgumentList $licenseHref -Property $licenseProps
    }
}

