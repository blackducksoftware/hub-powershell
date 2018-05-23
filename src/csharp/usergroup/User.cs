using System;
using System.Collections.Generic;
using System.Management.Automation;
using System.Collections.Immutable;

namespace BlackDuck.Hub {

    public class User {

        public string UserName {get; private set; }

        public string FirstName {get; private set; }

        public string LastName {get; private set; }

        public string Email {get; private set; }

        public string Type {get; private set; }

        public bool Active { get; private set; }

        [Hidden]
        public string href { get; private set; }

        private User () { }

        public static User Parse(PSObject input){
             if (input is null) return null;
            var props = input.Properties;
            return new User {
                UserName = (string) props["userName"]?.Value,
                FirstName = (string) props["firstName"]?.Value,
                LastName = (string) props["lastName"]?.Value,
                Email = (string) props["email"]?.Value,
                Type = (string) props["type"]?.Value,
                Active = (bool) props["active"]?.Value,
                href = (string) (props["_meta"]?.Value as PSObject)?.Properties?["href"]?.Value
            };
        }

        public static IList<User> Parse(Object[] inputs){
            if (inputs is null){
                return ImmutableList<User>.Empty;
            }
            var builder = ImmutableList.CreateBuilder<User>();
            foreach (var input in inputs){
                builder.Add(User.Parse(input as PSObject));
            }
            return builder.ToImmutableList();
        }

    }

}