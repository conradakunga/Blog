---
layout: post
title: Writing Operating Specific Test Assertion For xUnit In C# & .NET
date: 2025-11-24 17:43:32 +0300
categories:
    - C#
    - .NET
    - Testing
    - xUnit
---

As I have mentioned before, my development environment is as follows:

- [MacBook Pro](https://www.apple.com/ke/macbook-pro/), running macOS [Sequoia](https://apps.apple.com/us/app/macos-sequoia/id6596773750?mt=12)
- My primary development environment is [JetBrains](https://www.jetbrains.com/) [Rider](https://www.jetbrains.com/rider/)
- Virtualized [Windows 11](https://en.wikipedia.org/wiki/Windows_11) Environment on [Parallels Desktop Pro](https://www.parallels.com/products/desktop/pro/)
- The development environment is [Visual Studio 2022](https://visualstudio.microsoft.com/vs/older-downloads/) and [Visual Studio Code](https://code.visualstudio.com/)

Recently, I was writing tests for a component that behaved differently on **Windows**.

The test itself is as follows:

```c#
public void Config_Is_Constructed_Correctly_With_EventLog_Issues()
{
    var settings = ElasticSearchSettings.GetSettings(TestConstants.ConnectionString, "Application", "1.0", true);
    var config = LoggerBuilder.GetElasticSearchLogger(settings, _output);
    config.Should().NotBeNull();
  	// Check whether log message is written to the Windows Event log
    _output.Output.Should().Contain("Application is not registered as an event source");
}
```

The code in question is this:

```c#
// Check whether log message is written to the Windows Event log
_output.Output.Should().Contain("Application is not registered as an event source");
```

This code, obviously, only works on **Windows**. There is no [EventLog](https://learn.microsoft.com/en-us/shows/inside/event-viewer) on **macOS** and **Linux**.

This test would therefore **pass** on **Windows** but **fail** on **macOS**.

How to go about fixing this?

I ended up **checking the platform just before running the assertion**, using the [IsOSPlatform](https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.runtimeinformation.isosplatform?view=net-10.0) like so:

```c#
if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
	_output.Output.Should().Contain("Application is not registered as an event source");
```

The assertion, written with [AwesomeAssertions](https://awesomeassertions.org/), now runs only on Windows.

Happy hacking!
