using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Management.Automation;

namespace BlackDuck.Hub {
    public class CodeLocation{
        
        public string Name { get; private set; }
        public string Url { get; private set; }
        public DateTime CreatedAt { get; private set; }
        public DateTime UpdatedAt { get; private set; }
        public long? ScanSize { get; private set; }

        [Hidden]
        public string mappedProjectVersionHref { get; private set; }

        [Hidden]
        public string href { get; private set; }

        private CodeLocation() {}

        public static CodeLocation Parse (PSObject input) {
            if (input is null) return null;
            var props = input.Properties;
            
            return new CodeLocation {
                Name = (string) props["name"]?.Value,
                Url = (string) props["url"]?.Value,
                ScanSize = (long?) props["scanSize"]?.Value,
                CreatedAt = (DateTime) props["createdAt"]?.Value,
                UpdatedAt = (DateTime) props["updatedAt"]?.Value,
                mappedProjectVersionHref = (string) props["mappedProjectVersion"]?.Value,
                href = (string) (props["_meta"]?.Value as PSObject)?.Properties?["href"]?.Value
            };
        }

        public static IList<CodeLocation> Parse(Object[] inputs){
            if (inputs is null){
                return ImmutableList<CodeLocation>.Empty;
            }
            var builder = ImmutableList.CreateBuilder<CodeLocation>();
            foreach (var input in inputs){
                builder.Add(CodeLocation.Parse(input as PSObject));
            }
            return builder.ToImmutableList();
        }
    }
}
