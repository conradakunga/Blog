---
layout: post
title: Quickly Generating a Voice Prompt on macOS
date: 2025-07-01 21:38:48 +0300
categories:
    - .NET
    - MacOS
---

Recently, I was executing a series of long-running jobs in a [LinqPad](https://www.linqpad.net/) script, and wondered if there was a way to be **alerted** when the work was complete, so that I didn't have to wait near my computer and could keep myself busy.

It turns out that this is rather simple to accomplish - all I needed to do was [shell](https://www.techtarget.com/searchdatacenter/definition/shell) to the [macOS](https://www.apple.com/macos/macos-sequoia/) terminal and execute the [say](https://ss64.com/mac/say.html) command, and let macOS do the heavy lifting for me.

The code took all of a few seconds to write.

```c#
//
// Insert some long-running task here
//

// Shell to the terminal and have your message read

// Some basic parameters
var name = "Conrad";
var timeOfDay = "evening";
// Dummy here to capture how long the task took
var span = TimeSpan.FromMinutes(8);
// Shell to execute the command
Process.Start("say", $"Good {timeOfDay}, {name}. The task took {span.TotalMinutes} minutes to execute");
```

Worked like a charm.

When the task was completed, I could hear the announcement from across the room.

Happy hacking!
