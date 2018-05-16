class RiskProfileCounts {
    [int] $Unknown;
    [int] $Ok;
    [int] $Low;
    [int] $Medium;
    [int] $High;

    [string] ToString(){
        return "Ok: $($this.Ok), Low: $($this.Low), Medium: $($this.Medium), High: $($this.High), Unknown: $($this.Unknown)"
    }

    static [RiskProfileCounts] Parse($fromApi){
        $counts=@{}
        $fromApi | ForEach-Object {
            $countType=[System.Globalization.CultureInfo]::InvariantCulture.TextInfo.ToTitleCase($_.countType.ToLower())
            $counts[$countType]=$_.count
        }
        return New-Object RiskProfileCounts -Property $counts
    }
}

class HubComponentVersion {
    [string] $ComponentName;
    [string] $VersionName;
    [int] $TotalFileMatchCount;
    [HubLicense[]] $Licenses;
    [string[]] $Usages; 
    [string[]] $MatchTypes;
    [string] $ReleasedOn; #TODO: Make Date
    [PSCustomObject] $ActivityData; #TODO: Create static types for these fields
    [PSCustomObject[]] $Origins;
    [RiskProfileCounts] $LicenseRiskProfile;
    [RiskProfileCounts] $SecurityRiskProfile;
    [RiskProfileCounts] $VersionRiskProfile;
    [RiskProfileCounts] $ActivityRiskProfile;
    [RiskProfileCounts] $OperationalRiskProfile;
    [string] $ReviewStatus;
    [string] $ApprovalStatus;
    [string] $PolicyStatus;
    hidden [string] $componentHref;
    hidden [string] $href;

    static [HubComponentVersion] Parse ($jsonComponentVersion){
        $convertedLicenses=@()
        if ($jsonComponentVersion.licenses){
            $convertedLicenses+=ForEach-Object -InputObject $jsonComponentVersion.licenses -Process {ParseLicense $_}
        } 
        if ($jsonComponentVersion.license){
            $convertedLicenses+= ParseLicense $jsonComponentVersion.license
        }

        return New-Object HubComponentVersion -Property @{
            ComponentName=$jsonComponentVersion.componentName;
            VersionName=$jsonComponentVersion.componentVersionName;
            TotalFileMatchCount=$jsonComponentVersion.totalFileMatchCount;
            Licenses=$convertedLicenses
            ReleasedOn=$jsonComponentVersion.releasedOn;
            Usages=$jsonComponentVersion.usages;
            MatchTypes=$jsonComponentVersion.matchTypes;
            ActivityData=$jsonComponentVersion.activityData;
            Origins=$jsonComponentVersion.origins;
            LicenseRiskProfile=[RiskProfileCounts]::Parse($jsonComponentVersion.licenseRiskProfile.counts);
            SecurityRiskProfile=[RiskProfileCounts]::Parse($jsonComponentVersion.securityRiskProfile.counts);
            VersionRiskProfile=[RiskProfileCounts]::Parse($jsonComponentVersion.versionRiskProfile.counts);
            ActivityRiskProfile=[RiskProfileCounts]::Parse($jsonComponentVersion.activityRiskProfile.counts);
            OperationalRiskProfile=[RiskProfileCounts]::Parse($jsonComponentVersion.operationalRiskProfile.counts);
            ReviewStatus=$jsonComponentVersion.reviewStatus;
            ApprovalStatus=$jsonComponentVersion.approvalStatus;
            PolicyStatus=$jsonComponentVersion.policyStatus;
            componentHref=$jsonComponentVersion.component;
            href=$jsonComponentVersion._meta.href;
        }
    }
    
}