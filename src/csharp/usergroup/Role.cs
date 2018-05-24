using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Collections.Immutable;

namespace BlackDuck.Hub {
    public class Role {
        public string Name {get; private set; }
        public string Description {get; private set; }

        [Hidden]
        public string href {get; private set; }

        private Role(){}

        public static Role Parse(PSObject input){
             if (input is null) return null;
            var props = input.Properties;
            return new Role {
                Name = (string) props["name"]?.Value,
                Description = (string) props["description"]?.Value,
                href = (string) (props["_meta"]?.Value as PSObject)?.Properties?["href"]?.Value
            };
        }

        public static IList<Role> Parse(Object[] inputs){
            if (inputs is null){
                return ImmutableList<Role>.Empty;
            }
            var builder = ImmutableList.CreateBuilder<Role>();
            foreach (var input in inputs){
                builder.Add(Role.Parse(input as PSObject));
            }
            return builder.ToImmutableList();
        }
    }
}