---
layout: post
title: ZipArchive FileName vs Name
date: 2026-01-16 13:31:14 +0300
categories:
    - C#
    - .NET
    - Compression
---

In our previous post, [Listing The Files In A Zip File In C# & .NET]({% post_url 2026-01-18-listing-the-files-in-a-zip-file-in-c-net %}), we looked at how to list the files in a `Zip` file.

The relevant code was this:

```c#
// Open the zip file on disk for update
await using (var archive = await ZipFile.OpenAsync(zilFile, ZipArchiveMode.Read))
{
    // Loop through all the entries
    for (var i = 0; i < archive.Entries.Count; i++)
    {
        // Get the file name
        var file = archive.Entries[i];
        // Print the count and name
        Log.Information("File {Count} - {FileMame}", i + 1, file.FullName);
    }
}
```

You can see where I am accessing the [FullName](https://learn.microsoft.com/en-us/dotnet/api/system.io.compression.ziparchiveentry.fullname?view=net-10.0) property.

There is a very similar property, [Name](https://learn.microsoft.com/en-us/dotnet/api/system.io.compression.ziparchiveentry.name?view=net-10.0), that we could also potentially use.

What is the difference?

To illustrate this, I will use a different `Zip` file. will add files with the following structure.

![newFolderStructure](../images/2026/01/newFolderStructure.png)

We then update our code slightly to print both the `Name` and the `FullName`.

```c#
using System.IO.Compression;
using System.Reflection;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console().CreateLogger();

// Extract the current folder where the executable is running
var currentFolder = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;

// Construct the full path to the zip file
var zilFile = Path.Combine(currentFolder, "Updated.zip");

// Open the zip file on disk for update
await using (var archive = await ZipFile.OpenAsync(zilFile, ZipArchiveMode.Read))
{
    // Loop through all the entries
    for (var i = 0; i < archive.Entries.Count; i++)
    {
        // Get the file name
        var file = archive.Entries[i];
        // Print the count and name
        Log.Information("File {Count} - Name: {Name}, FullName: {FullName}", i + 1, file.Name, file.FullName);
    }
}
```

The key bit is here:

```c#
for (var i = 0; i < archive.Entries.Count; i++)
{
    // Get the file name
    var file = archive.Entries[i];
    // Print the count and name
    Log.Information("File {Count} - Name: {Name}, FullName: {FullName}", i + 1, file.Name, file.FullName);
}
```

If we run this code, we should see the following:

![nameVsFullNameOutput](../images/2026/01/nameVsFullNameOutput.png)

And here we can see the difference:

- The `Name` property contrains only the **name** of the file
- The `FullName` property contains, in addition to the name, the **relative path**.

### TLDR

**The `Name` property of the `ZipArchiveEntry` contains the file name, whereas the `FullName` additionally contains the relative path.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-01-19%20-%20FileNameVsFullName).

Happy hacking!
