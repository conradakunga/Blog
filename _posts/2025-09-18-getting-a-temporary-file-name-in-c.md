---
layout: post
title: Getting A Temporary File Name in C#
date: 2025-09-18 10:02:06 +0300
categories:
    - C#
    - .NET
---

In the course of your application development, it is very likely you will run into a situation where you will need a **temporary file**. Perhaps you are performing I/O work and need to temporarily store data on disk. Or you are using an API that requires files.

There are two similar APIs that you can call for this purpose, which have slight but important differences.

## Path.GetTempFileName

The first, and straightforward-sounding one is [Path.GetTempFileName](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.gettempfilename?view=net-9.0).

You use it like so:

```c#
var tempFile = Path.GetTempFileName();
Console.WriteLine($"Created file '{tempFile}'");
```

This will print something like this (depending, of course, on your operating system)

```plaintext
var tempFile = Path.GetTempFileName();
Console.WriteLine($"Created file '{tempFile}'");
```

The documentation says thus:

> Creates a uniquely named, zero-byte temporary file on disk and returns the full path of that file.

The important bit is "**Creates** a uniquely named ..."

This means that the file **actually gets created on disk**.

This means that **you are responsible for its cleanup**! If you don't do the cleanup, these files will accumulate on your disk.

You can achieve this via a [try-finally](https://learn.microsoft.com/en-us/dotnet/standard/exceptions/how-to-use-finally-blocks) block, like this:

```c#
string tempFile = "";
try
{
  tempFile = Path.GetTempFileName();
  Console.WriteLine($"Created file '{tempFile}'");
  //
  // Your work here
  //
}
finally
{
  File.Delete(tempFile);
}
```

## Path.GetRandomFileName

Another way to obtain a temporary file name is to use the [Path.GetRandomFileName](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.getrandomfilename?view=net-9.0) API.

You use it as follows:

```c#
tempFile = Path.GetRandomFileName();
Console.WriteLine($"Created file '{tempFile}'");
```

Unlike the previous method, this one **does not actually create the file on disk**.

It may be called `GetRandomFileName`, but you can also use the returned name to create **directories**.

```c#
var directoryName = Path.GetRandomFileName();
var info = Directory.CreateDirectory(directoryName);
Console.WriteLine($"Created directory '{info.FullName}'");
//
// Do work
//
```

## Custom

You also have the option of generating your own file names, perhaps using your own algorithm.

Something like this:

```c#
public sealed class RandomFileNameGenerator()
{
	private const string alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

	public static string Generate(int length = 12)
	{
		var name = new string(Enumerable.Range(0, length)
			.Select(_ => alphabet[Random.Shared.Next(alphabet.Length)]).ToArray());

		return name;
	}
}
```

If you need to actually create the file, you will need to ask the operating system for a temporary location.

You can use the [Path.GetTempPath](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.gettemppath?view=net-9.0&tabs=windows) method for this.

```c#
var tempPath = Path.Combine(Path.GetTempPath(), RandomFileNameGenerator.Generate());
	Console.WriteLine(tempPath);
```

This will print something like this:

```plaintext
/var/folders/q8/cdslzt2s6p1djnhp_y3ksc280000gn/T/usde4uCmVV1a
```

## TLDR

There are 3 ways you can use to generate temporary file names (and files) in C# & .NET

Happy hacking!
