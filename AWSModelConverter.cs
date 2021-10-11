using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.IO;

namespace AWSModelConverter
{
    class Program
    {
        static void Main(string[] args)
        {
            var listEnvs = Environment.GetCommandLineArgs();
            var fileToRead = File.ReadAllText(listEnvs[1]).Replace("\r\n", "").Trim();
            JObject toWrite = new JObject();
            toWrite.Add("language", "GRAPHQL");
            toWrite.Add("text", fileToRead);
            File.WriteAllText(listEnvs[2], toWrite.ToString());

        }
    }
}
