using System;
using System.Collections.Generic;
using System.Management.Automation;

namespace BlackDuck.Hub {

    
    public enum NotificationType {
        Vulnerability,
        RuleViolation,
        PolicyOverride
    }

    public class Notification {
        public NotificationType Type { get; private set; }
        protected Notification (NotificationType type) {
            this.Type = type;
        }
    }

    public class GenericNotification : Notification {
        public GenericNotification(NotificationType type, string message) : base(type){
            this.Message = message;
        }

        public String Message {get; private set;}
    }

    public class RuleViolationNotification : Notification {
        public string ProjectName {get; private set;}
        public string ProjectVersionName {get; private set;}
        public string[] Policies {get; private set;}
        public long? ComponentVersionsInViolation {get; private set;}

        private RuleViolationNotification() : base(NotificationType.RuleViolation){
        }

        public static RuleViolationNotification Parse (PSObject input) {
            var props = input.Properties;
            var content = ((PSObject) props["content"]?.Value)?.Properties;
            if (content is null) return null;

            object[] policyInfos = (object[])content["policyInfos"]?.Value;
            string[] policyNames = null;
            if (!(policyInfos is null)){
                policyNames = new string[policyInfos.Length];
                for (int i = 0; i < policyInfos.Length; ++i) {
                    policyNames[i]=((PSObject)policyInfos[i])?.Properties["policyName"]?.Value as string;
                }
            }
            return new RuleViolationNotification {
                ProjectName = (string) content["projectName"]?.Value,
                ProjectVersionName = (string) content["projectVersionName"]?.Value,
                Policies = policyNames,
                ComponentVersionsInViolation = (long?) content["componentVersionsInViolation"]?.Value
            };
            
        }
    }

    public class VulnerabilityNotification : Notification {

        public VulnerabilityNotification () : base (NotificationType.Vulnerability) { }

        public string ComponentVersionOriginName { get; private set; }
        public string ComponentVersionOriginId { get; private set; }
        public string ComponentName {get; private set;}
        public string VersionName {get; private set;}

        public IList<VulnerabilityId> NewVulnerabilityIds { get; private set; }
        public IList<VulnerabilityId> UpdatedVulnerabilityIds { get; private set; }
        public IList<VulnerabilityId> DeletedVulnerabilityIds { get; private set; }

        public IList<AffectedProjectVersionInfo> AffectedProjectVersions {get; private set;}
        

        [Hidden]
        public string componentVersionHref { get; private set; }

        public static VulnerabilityNotification Parse (PSObject input) {
            var props = input.Properties;
            var content = ((PSObject) props["content"]?.Value)?.Properties;
            
            if (content is null) return null;

            return new VulnerabilityNotification {
                ComponentVersionOriginName = (string) content["componentVersionOriginName"]?.Value,
                ComponentVersionOriginId = (string) content["componentVersionOriginId"]?.Value,
                ComponentName = (string) content["componentName"]?.Value,
                VersionName = (string) content["versionName"]?.Value,

                NewVulnerabilityIds = VulnerabilityId.Parse ((object[]) content["newVulnerabilityIds"]?.Value),
                UpdatedVulnerabilityIds = VulnerabilityId.Parse ((object[]) content["updatedVulnerabilityIds"]?.Value),
                DeletedVulnerabilityIds = VulnerabilityId.Parse ((object[]) content["deletedVulnerabilityIds"]?.Value),
                
                AffectedProjectVersions = AffectedProjectVersionInfo.Parse ((object[]) content["affectedProjectVersions"]?.Value),

                componentVersionHref = (string) content["componentVersion"]?.Value
            };
        }
    }
}