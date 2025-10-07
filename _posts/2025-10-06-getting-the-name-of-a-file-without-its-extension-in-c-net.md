---
layout: post
title: Getting The Name Of A File Without Its Extension In C# & .NET
date: 2025-10-06 22:28:11 +0300
categories:
    - C#
    - .NET
---

A **common** (and slightly annoying) problem you will run into is when you need to **get the name of a file, but without its extension**. Perhaps you want to **generate a new file name**. Or you are using the **original file name for a different context**, e.g., you are **compressing** it, and want to name the compressed file with a **different extension**.

The first place you would try would be the [FileInfo](https://learn.microsoft.com/en-us/dotnet/api/system.io.fileinfo?view=net-9.0) class.

```c#
var filename = "Potato.doc";

var info = new FileInfo(filename);

Console.WriteLine($"The name is '{info.Name}'");
Console.WriteLine($"The extension is '{info.Extension}'");
```

Surprisingly, this does not help - the **Name** of the file **includes** the **extension**.

```plaintext
The name is 'Potato.doc'
The extension is '.doc'
```

It does, however, allow us to extract the **extension**.

We can therefore use these two pieces of information in a number of ways to obtain just the **name** without the **extension**.

1. Use the [Replace](https://learn.microsoft.com/en-us/dotnet/api/system.string.replace?view=net-9.0) method of the `String`
2. Use a [regular expression](https://learn.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference).

```c#
// Use string.Replace
var name = info.Name;
var extension = info.Extension;

var fileNameWithoutExtension = name.Replace(extension, "");

Console.WriteLine($"The name without extension is '{fileNameWithoutExtension}'");

// Use regex. But really, don't do it this way!
fileNameWithoutExtension = Regex.Match(filename, @"(?<name>\w+)\.").Groups["name"].Value;
Console.WriteLine($"The name without extension is '{fileNameWithoutExtension}'");
```

The `regex` method in particular is extremely **brittle**. 

- A file can have **multiple** extensions
- Extensions are **optional**

**Do not do it this way**!

This is such a **common problem** that a solution is in the [Path](https://learn.microsoft.com/en-us/dotnet/api/system.io.path?view=net-9.0) class - the aptly named [GetFileNameWithoutExtension]() method.

```c#
fileNameWithoutExtension = Path.GetFileNameWithoutExtension(name);
Console.WriteLine($"The name without extension is '{fileNameWithoutExtension}'");
```

### TLDR

**The `Path` class has a method `GetFileNameWithoutExtension` that does what it says on the tin.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-10-06%20-%20FileNameWithoutExtension).

Happy hacking!
