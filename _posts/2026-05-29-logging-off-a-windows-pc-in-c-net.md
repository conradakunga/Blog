---
layout: post
title: Logging Off A Windows PC In C# & .NET
date: 2026-05-29 04:50:09 +0300
categories:
    - C#
    - .NET
    - Windows
---

In an earlier post, "[Locking A Windows PC In C# & .NET]({% post_url 2026-05-22-locking-a-windows-pc-in-c-net %})", we looked at how to invoke the [Windows API](https://learn.microsoft.com/en-us/windows/win32/apiindex/windows-api-list) to lock the screen.

In this post, we look at something similar - how to **log off** a currently logged-in Windows user.

This is also achieved by invoking the Windows API function [ExitWindowsEx](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-exitwindowsex).

This is achieved as follows using the [DllImport](https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.dllimportattribute?view=net-10.0) attribute.

```c#
[DllImport("user32")]
public static extern bool ExitWindowsEx(uint uFlags, uint dwReason)
```

The function itself is invoked as follows:

```c#
ExitWindowsEx(0, 0);
```

The two parameters passed are `uFlags` and `dwReason`.

The value for `uFlag`, `0` is defined as follows:

| Value | Meaning |
| --- | --- |
| **EWX_LOGOFF** 0| Shuts down all processes running in the logon session of the process that called the **ExitWindowsEx** function. Then it logs the user off. This flag can be used only by processes running in an interactive user's logon session. |

The value for `dwReason`, `0`, is defined as follows:

| Value | Meaning |
| --- | --- |
| **SHTDN_REASON_MAJOR_OTHER**0x00000000 | Other issue |

Upon invocation, this will **log you off**.

Be careful with this, as you need to consider what happens to any applications with **open files** when you **log off the logged-in user.**

### TLDR

**You can log off the current logged-in user by calling the Windows API function `ExitWindowsEx`**

Happy hacking!
