---
layout: post
title: .NET 11 Preview - Getting A Handle To The NULL Device
date: 2026-07-19 21:22:06 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

When working with **files**, or **streamed** data, there are times when you want to signal that you **don't care about where the data is going**.

It is these occasions where you use the [NULL](https://en.wikipedia.org/wiki/Null_device) device.

On **Linux** this is `/dev/null`

On **Windows**, this is `NUL`

Take a scenario where you want to capture the contents of a file listing to a file, using the [ls](https://en.wikipedia.org/wiki/Ls) command.

```bash
ls > list.txt
```

This will work on **Unix**, **macOS** and **Linux**, on most shells ([bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)), [fish](https://fishshell.com/), [zsh](https://en.wikipedia.org/wiki/Z_shell), etc).

It will also work on **Windows** if you are using [PowerShell](https://learn.microsoft.com/en-us/powershell/).

The case arises of what to do when you **don't care about the results**.

In which case you would do the following:

On **Unix**, **macOS** and **Linux**:

```c#
ls > /dev/null
```

On Windows:

```c#
ls > NUL
```

Is this possible to do this **programmatically**?

In .NET 11, you can now do this easily via the new [OpenNullHandle](https://learn.microsoft.com/en-us/dotnet/api/system.io.file.opennullhandle?view=net-11.0) API in the [File](https://learn.microsoft.com/en-us/dotnet/api/system.io.file?view=net-11.0) `class`.

You use it like this:

```c#
using (var handle = File.OpenNullHandle())
{
	// Can now use handle in here
}
```

### TLDR

**The `OpenNullHandle` method in the `File` class allows you to get a handle to the system `NULL` device.**

Happy hacking!
