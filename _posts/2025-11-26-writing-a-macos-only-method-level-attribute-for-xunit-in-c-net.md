---
layout: post
title: Writing A macOS-only method-level attribute for xUnit in C# & .NET
date: 2025-11-26 22:31:54 +0300
categories:
    - C#
    - .NET
    - xUnit
---

Yesterday's post, " [Writing A Windows-only method-level attribute for xUnit in C# & .NET]({% post_url 2025-11-25-writing-a-windows-only-method-level-attribute-for-xunit-in-c-net %})", looked at how to write an attribute for the [xUnit](https://xunit.net/) test framework to mark a test as only to be run if the platform it is running under is **Windows**.

In this post, we will do the same for **macOS**.

We will leverage the same technique as before and use the [OperatingSystem](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem?view=net-10.0) class to determine the **current operating system**.

The complete attribute will look like this:

```c#
using Xunit;

namespace Rad.xUnit.Extensions;

/// <summary>
/// Marks a test as only runnable in macOS
/// </summary>
[AttributeUsage(AttributeTargets.Method)]
public sealed class MacOSOnlyFactAttribute : FactAttribute
{
    public MacOSOnlyFactAttribute()
    {
        if (!OperatingSystem.IsMacOS())
        {
            Skip = "This is a macOS Only Test";
        }
    }
}
```

You use it like this:

```c#
[MacOSOnlyFactAttribute]
public void Config_Is_Constructed_Correctly_With_EventLog_On_macOS_Issues()
{
  //
  // Test code here
  //
}
```

### TLDR

**We can use an `xUnit` `attribute` to designate tests as platform-specific (macOS).**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/xUnitExtensions).

Happy hacking!
