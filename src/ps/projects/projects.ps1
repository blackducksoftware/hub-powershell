class HubProject{
    [string] $Id
    [string] $Name
    [string] $Source
    [boolean] $ProjectLevelAdjustments
    hidden [string] $href

    HubProject($name, $source, $projectLevelAdjustments, $href){
        $this.href = $href
        $this.Name = $name
        $this.Source = $source
        $this.ProjectLevelAdjustments = $projectLevelAdjustments
        $this.Id = $href.Substring("${global:hubUrl}/api/projects/".Length)

    }

    static [HubProject] Parse($jsonProject){
        return [HubProject]::new(
           $jsonProject.name,
           $jsonProject.source,
           "true".Equals($jsonProject.projectLevelAdjustments),
           $jsonProject._meta.href)
    }

    [string] ToString(){
        return "$($this.Name) [$($this.Source)]"
    }
}

class HubProjectVersion{
    [string] $Id
    [string] $Name
    [HubLicense] $License
    [string] $Phase
    [string] $Distribution
    [string] $Source
    hidden [string] $href

    static [HubProjectVersion] Parse($jsonProjectVersion){
        $versionHref=$jsonProjectVersion._meta.href
        
        return New-Object HubProjectVersion -Property @{
            Id = $versionHref.Substring($versionHref.LastIndexOf('/') + 1);
            Name = $jsonProjectVersion.versionName;
            Phase = $jsonProjectVersion.phase;
            Distribution = $jsonProjectVersion.distribution;
            Source = $jsonProjectVersion.source;
            License = ParseLicense $jsonProjectVersion.license;
            href = $versionHref;
        }
    }
}