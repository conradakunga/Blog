---
layout: post
title: Quickly generating A Voice Prompt on Windows
date: 2025-07-02 21:56:51 +0300
categories:
    - .NET
    - C#
    - Windows
    - Text To Speech
---

Yesterday, I wrote a post on [Quickly Generating a Voice Prompt on macOS]({% post_url 2025-07-01-quickly-generating-a-voice-prompt-on-macos %}).

Is the same possible on Windows?

Yes. However, it requires a bit more work because the 'say' command is not available on Windows.

First, you will need to download and install the [System.Speech](https://www.nuget.org/packages/System.Speech/) nuget package.

```bash
dotnet add package System.Speech
```

Next, we tweak our code slightly as follows:

```c#
// create a new synthesizer object
var synth = new SpeechSynthesizer();
// Some basic parameters
var name = "Conrad";
var timeOfDay = "evening";
// Dummy here to capture how long the task took
var span = TimeSpan.FromMinutes(8);
// Shell to execute the command
synth.SpeakAsync($"Good {timeOfDay}, {name}. The task took {span.TotalMinutes} minutes to execute");
```

This works just as effectively, provided, of course, that your **Windows has speech enabled and has the appropriate voices installed**.

You can check as follows:

```c#
var synth = new SpeechSynthesizer();
// Get a list of installed voices
var voices = synth.GetInstalledVoices();
// If there aren't any, the system isn't setup
if (voices.Count == 0)
  Console.WriteLine("Speech does not seem to be configured");
else
{
  // List all the voices
  Console.WriteLine("Available voices:");
  foreach (var voice in voices)
  {
    var info = voice.VoiceInfo;
    Console.WriteLine($"- {info.Name} ({info.Culture})");
  }
}
```

Happy hacking!
