---
layout: post
title: Locking A Windows PC in Visual Basic .NET
date: 2026-05-23 12:44:59 +0300
categories:
    - VB.NET
    - Visual Basic
    - C#
---

In our previous post, "[Locking A Windows PC In C# & .NET]({% post_url 2026-05-22-locking-a-windows-pc-in-c-net %})", we looked at how to **lock** a [Windows](https://www.microsoft.com/en-us/windows) PC in [C#](https://learn.microsoft.com/en-us/dotnet/csharp/).

In this post, we will look at how to do the same thing in [Visual Basic.NET](https://learn.microsoft.com/en-us/dotnet/visual-basic/).

The approach and the code are very **similar**.

```vb
Imports System.Runtime.InteropServices
<DllImport("user32.dll", SetLastError:=True)>

Private Shared Function LockWorkStation() As Boolean
```

The invocation is the **same**.

```vb
LockWorkStation();
```

### TLDR

**You can call the Windows API from Visual Basic .NET and invoke the `LockWorkStation()` method to lock your computer.**
