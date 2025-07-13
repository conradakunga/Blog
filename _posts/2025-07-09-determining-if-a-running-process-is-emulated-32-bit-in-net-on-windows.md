---
layout: post
title: Determining If A Running Process Is Emulated 32 Bit In .NET On Windows
date: 2025-07-09 13:43:48 +0300
categories:
    - C#
    - .NET
    - Windows
---

The previous post, [Determining If A Running Process Is 64 Bit In .NET]({% post_url 2025-07-8-determining-if-a-running-process-is-64-bit-in-net %}), discussed how to determine whether to shell to a 32 or a 64 bit process.

If you use the [Is64BitProcess](https://learn.microsoft.com/en-us/dotnet/api/system.environment.is64bitprocess?view=net-9.0) property of the [Environment](https://learn.microsoft.com/en-us/dotnet/api/system.environment?view=net-9.0) class, there is a possible edge case to consider.

64 bit Windows can absolutely run a 32 bit process. It does so using [WOW](https://www.softwarekey.com/blog/support-articles/wow64-means-applications/), where it **emulates** a 32 bit environment.

This means that there are  (theoretically) 3 possibilities to check for:

1. A `64` bit process
2. A `32` bit process
3. A `32` bit process running in `64` bit mode.

If you need to conclusively check for the third, you will need to use the [Windows API](https://learn.microsoft.com/en-us/windows/win32/apiindex/windows-api-list).

```c#
// Reference the Windows API call
[DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
static extern bool IsWow64Process(IntPtr hProcess, out bool wow64Process);

// Variable to store the result of the call
bool isWow64;
if (!IsWow64Process(Process.GetCurrentProcess().Handle, out isWow64))
  throw new Exception("Error invovking API");
if (isWow64)
{
  Console.WriteLine("Emulated 32 bit");
}
else
{
  Console.WriteLine("Not Emulated 32");
}
```

Here we can see once we invoke the Windows API call, the result is stored in the `bool` `isWow64` variable, that we can subsequently interrogate.

You may need [additional permissions if you need to query other processes](https://learn.microsoft.com/en-us/windows/win32/procthread/process-security-and-access-rights).

### TLDR

**If is possibe to check if a process is an emulated 32 bit process using the Windows API.**

Happy hacking!
