﻿// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

using Newtonsoft.Json;
using System.IO;

namespace WinDynamicDesktop
{
    class DebugLogger
    {
        public static void WriteLogFile()
        {
            if (!File.Exists("debug.log"))
            {
                return;
            }

            AppConfig settings = null;

            try
            {
                string jsonText = File.ReadAllText("settings.json");
                settings = JsonConvert.DeserializeObject<AppConfig>(jsonText);
            }
            catch { /* Do nothing */ }

            using (StreamWriter debugLog = new StreamWriter("debug.log"))
            {
                if (settings != null)
                {
                    settings.location = "redacted";
                    settings.latitude = "0";
                    settings.longitude = "0";
                    debugLog.WriteLine("./settings.json");
                    debugLog.WriteLine(JsonConvert.SerializeObject(settings, Formatting.Indented));
                }
                else
                {
                    debugLog.WriteLine("WARNING: Settings file not found or invalid");
                }

                if (Directory.Exists("themes"))
                {
                    foreach (string path in Directory.EnumerateFiles("themes", "*", SearchOption.AllDirectories))
                    {
                        debugLog.WriteLine("./" + path.Replace('\\', '/'));

                        if (Path.GetExtension(path) == ".json")
                        {
                            debugLog.WriteLine(File.ReadAllText(path));
                        }
                    }
                }
                else
                {
                    debugLog.WriteLine("WARNING: Themes directory not found");
                }
            }
        }
    }
}
