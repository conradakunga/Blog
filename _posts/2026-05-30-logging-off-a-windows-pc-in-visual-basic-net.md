---
layout: post
title: Logging Off A Windows PC In Visual Basic .NET
date: 2026-05-30 22:03:11 +0300
categories:
    - VB.NET
    - Visual Basic
    - .NET
    - Windows
---

In our previous post, "[Logging Off A Windows PC In C# & .NET]({% post_url 2026-05-29-logging-off-a-windows-pc-in-c-net %})", we looked at how to **log off** a Windows PC using C#, invoking the [Windows API](https://learn.microsoft.com/en-us/windows/win32/apiindex/windows-api-list).

In this post, we will look at how to achieve the same using [Visual Basic .NET](https://learn.microsoft.com/en-us/dotnet/visual-basic/).

The code is pretty much **identical**.

First, using the [DllImport](https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.dllimportattribute?view=net-10.0) attribute, we **import** the relevant function call.

```vb
Imports System.Runtime.InteropServices

<DllImport("user32.dll", SetLastError:=True)>

Public Shared Function ExitWindowsEx(uFlags As UInteger, dwReason As UInteger) As Boolean
  
End Function
```

Invoking it is as simple as this:

```vb
Dim success As Boolean = ExitWindowsEx(0, 0)

If Not success Then
    Console.WriteLine($"Error: {Marshal.GetLastWin32Error()}")
End If
```

It is poor practice to have [magic numbers](https://en.wikipedia.org/wiki/Magic_number_(programming)) like this, so it is probably better to create some **constants**.

```vb
Const EWX_LOGOFF As UInteger = &H0
```

Our method call thus becomes:

```vb
Dim success As Boolean = ExitWindowsEx(EWX_REBOOT, 0)
```

Of interest here is that the `&H` prefix means that the following value is in [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) 

Happy hacking!
