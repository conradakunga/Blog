---
layout: post
title: Tip - Initialzing Large Arrays With A Known Value
date: 2025-04-08 01:46:17 +0300
categories:
    - C#
    - .NET
---

Recently, I was working on some graphics manipulation, and I needed to create and initialize an array with all its elements set to 1.

There are several ways to do this:

### LINQ

Our old friend [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) can always be relied on to have something in the toolbox. In this case, we can use the [Repeat](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.repeat?view=net-9.0) method of the [Enumerable](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable?view=net-9.0).

```c#
var byteArray = Enumerable.Repeat(1, 50).ToArray();
```

### For Loop

Another way would be to declare an array and then fill it with a for **loop**:

```c#
byte[] byteArray = new byte[100];

for (var i = 0; i < 50; i++)
  byteArray[0] = 1;
```

### Array Fill

The [Array](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/arrays) type has a [Fill](https://learn.microsoft.com/en-us/dotnet/api/system.array.fill?view=net-9.0) method that you can use for this purpose.

```c#
byte[] byteArray = new byte[100];

Array.Fill(byteArray, (byte)1);
```

### Span Fill

You can also leverage the [Span](https://learn.microsoft.com/en-us/dotnet/api/system.span-1?view=net-9.0) for this purpose, as it has a [Fill](https://learn.microsoft.com/en-us/dotnet/api/system.span-1.fill?view=net-9.0) method.

```c#
byte[] byteArray = new byte[100];

var span = new Span<byte>(byteArray);
span.Fill(1);
```

### BONUS

You can also quickly reset the array to all zeros using the [Array.Clear](https://learn.microsoft.com/en-us/dotnet/api/system.array.clear?view=net-9.0) method as follows:

```c#
Array.Clear(byteArray);
```



Happy hacking!
