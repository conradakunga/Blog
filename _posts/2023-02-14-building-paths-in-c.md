---
layout: post
title: Building Paths In C#
date: 2023-02-14 04:06:01 +0300
categories:
    -C#
---
Suppose you wanted to generate a folder on your desktop, say to store your incomplete proposals.

A quick way to do it would be like so:

```csharp
// Get the folder location
var folderLocation = $@"{Environment.GetFolderPath(Environment.SpecialFolder.Desktop)}\Incomplete";
Console.WriteLine(folderLocation);
// Create the folder
Directory.CreateDirectory(folderLocation);
```
This prints the following on my Windows environment:

```plaintext
C:\Users\conrada\Desktop\Incomplete
```

This uses the [Environment.GetFolderPath](https://learn.microsoft.com/en-us/dotnet/api/system.environment.getfolderpath?view=net-7.0) to get the location of the desktop, and then you concatenate the proposed folder.

By the way, you use `Environment.GetFolderPath` to request the runtime to get for you the location of various system folders - don't assume the System folder is always `C:\WINDOWS\system32\` - what if the user installed Windows on Drive E? You can get a list of the folders you can retrieve [here](https://learn.microsoft.com/en-us/dotnet/api/system.environment.specialfolder?view=net-7.0).

There are a bunch of problems with this approach.

1. On windows the directory separator is `\` . On MacOS and Linux is is `/`.
1. String concatenation is error prone.

Is there a way the framework can help with this problem?

Indeed.

You can use the [Path.Combine](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.combine?view=net-7.0) method for this. This method takes two paths and, unsurprisingly, combines them.

So you change your code like so:

```csharp
folderLocation = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Incomplete");
Console.WriteLine(folderLocation);
```

You should get the same result.

Notice that there is no file separator specified - the runtime will know to use the current operating system separator.

What if you wanted to create a sub-folder of `Incomplete`?

We could do it like this:

```csharp
folderLocation = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Incomplete\Active");
Console.WriteLine(folderLocation);
```

This will print the following:

```plaintext
C:\Users\conrada\Desktop\Incomplete\Active
```

But we are trying to get away from specifying path separators.

For many years I would do it like this:

```csharp
folderLocation = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Incomplete");
Console.WriteLine(folderLocation);

folderLocation = Path.Combine(folderLocation, "Active");
Console.WriteLine(folderLocation);
```

Here we are progressively building the path by calling [Path.Combine](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.combine?view=net-7.0) multiple times.

And then the other day a college informed me that Path.Combine has several overloads - one that takes [3 arguments](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.combine?view=net-7.0#system-io-path-combine(system-string-system-string-system-string)), one that takes [4 arguments](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.combine?view=net-7.0#system-io-path-combine(system-string-system-string-system-string-system-string)) and one that takes a [parameter array](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.combine?view=net-7.0#system-io-path-combine(system-string())), meaning you can specify as many paths as you want.

These new overloads were introduced in .NET Framework 4.

This means that we can do this:

```csharp
var folderLocation = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Incomplete", "Active", "2023", "January");
Console.WriteLine(folderLocation);
```

This prints out the following:

```plaintext
C:\Users\conrada\Desktop\Incomplete\Active\2023\January
```

You can combine as many paths as you want ([within reason](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry)!)

A caveat is what happens when you provide complete paths as one of the arguments.

The runtime will ignore any prior complete paths and use the latest to start constructing the path.

For example:

```csharp
var folderLocation = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Incomplete", "Active", @"C:\2023", "January");
Console.WriteLine(folderLocation);
```

This code will print the following:

```plaintext
C:\2023\January
```

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2023-02-14%20-%20Building%20Paths%20In%20C%23).

Happy hacking!