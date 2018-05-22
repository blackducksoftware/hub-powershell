using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Collections.Immutable;

namespace BlackDuck.Hub {

    public class UserGroup {
        public string CreatedFrom { get; private set; }
        public string Name { get; private set; }
        public bool Active { get; private set; }

        [Hidden]
        public string href { get; private set; }

        private UserGroup () { }

        public static UserGroup Parse(PSObject input){
             if (input is null) return null;
            var props = input.Properties;
            return new UserGroup {
                CreatedFrom = (string) props["createdFrom"]?.Value,
                Name = (string) props["name"]?.Value,
                Active = (bool) props["active"]?.Value,
                href = (string) (props["_meta"]?.Value as PSObject)?.Properties?["href"]?.Value
            };
        }

        public static IList<UserGroup> Parse(Object[] inputs){
            if (inputs is null){
                return ImmutableList<UserGroup>.Empty;
            }
            var builder = ImmutableList.CreateBuilder<UserGroup>();
            foreach (var input in inputs){
                builder.Add(UserGroup.Parse(input as PSObject));
            }
            return builder.ToImmutableList();
        }

    }

}