---
layout: post
title: How To Extract Files From A 7-Zip Archive In C# & .NET
date: 2026-01-27 20:07:56 +0300
categories:
   - C#
    - .NET
    - Compression
---

In a previous post, [How To Create A 7-Zip Archive In C# & .NET]({% post_url 2026-01-25-how-to-create-a-7-zip-archive-in-c-net %}), we looked at how to create a [7z](https://en.wikipedia.org/wiki/7z) archive by **automating** the 7-Zip command-line tool.

In this post, we will look at the reverse - how to **extract files** from a `7z` archive.

The project structure is as follows:

![Extract7ZipProject](../images/2026/01/Extract7ZipProject.png)

To ensure that the `7z` is copied to the **output** folder, add the following element:

```xml
<ItemGroup>
  <None Include="Books.7z">
  	<CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
  </None>
</ItemGroup>
```

We then add the CliWrap library.

```bash
dotnet add package CliWrap
```

The code itself is as follows:

```c#
using System.IO;
using System.Reflection;
using CliWrap;
using CliWrap.Buffered;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console().CreateLogger();

// Extract the current folder where the executable is running
var currentFolder = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;

// Set the folder we want our files extracted to
var outputFolder = Path.Combine(currentFolder, "ExtractedBooks");

// Construct the full path to the zip file
var source7ZipFile = Path.Combine(currentFolder, "Books.7z");

// Path to 7zip executable
const string executablePath = "/opt/homebrew/bin/7zz";

var result = await Cli.Wrap(executablePath) // Set the path to the executable
    .WithArguments(args => args
            .Add("x") //Specify to extract an archive
            .Add(source7ZipFile) // Source zip file
            .Add($"-o{outputFolder}") // The output folder
            .Add("-y") // Say yes to all prompts
    )
    .ExecuteBufferedAsync();

// Check if the process succeeded
if (result.ExitCode != 0)
    Log.Error("7-Zip failed: {Message}", result.StandardError);
else
    Log.Information("Extracted files in {SourceFiles} to {TargetFolder} {Message}", source7ZipFile, outputFolder,
        result.StandardOutput.Trim());
```

If we run this code, we should see the following output:

![Extract7zConsole](../images/2026/01/Extract7zConsole.png)

If we look in our output folder, we should see our newly created folder

![Extract7ZipFolder](../images/2026/01/Extract7ZipFolder.png)

### TLDR

**You can extract `7z` archives by automating the command-line tool.**

The code is in my GitHub.

Happy hacking!
