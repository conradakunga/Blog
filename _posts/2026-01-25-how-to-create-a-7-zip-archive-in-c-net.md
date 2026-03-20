---
layout: post
title: How To Create A 7-Zip Archive In C# & .NET
date: 2026-01-25 18:54:48 +0300
categories:
    - C#
    - .NET
    - Compression
---

The [Zip](https://en.wikipedia.org/wiki/ZIP_(file_format)) compression format has been fairly **ubiquitous** throughout the era of computing. Most operating systems **natively support them**.

After `Zip` came the [RAR](https://en.wikipedia.org/wiki/RAR_(file_format)) format by [Eugene Roshal,](https://en.wikipedia.org/wiki/Eugene_Roshal) which offered **faster compression** and **smaller** files.

Recently, the [7z](https://en.wikipedia.org/wiki/7z) format by Igor Pavlov has grown increasingly popular as it creates even smaller compressed files.

There have been attempts to create a **mature**, **high-performing** library that has **feature parity** with the command-line tool.

This has largely been **unsuccessful**.

So the best way to create a `7-Zip` file in .NET is to **automate the command-line tool**.

Our project structure looks like this:

![create7ZipFolder](../images/2026/01/create7ZipFolder.png)

To ensure the `Books` folder is copied to the output, we add this element to the `.csproj`.

```xml
<ItemGroup>
  <None Include="Books\**\*">
  	<CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
  </None>
</ItemGroup>
```

The first order of business is to install the [CliWrap](https://github.com/Tyrrrz/CliWrap) library. This is orders of magnitude **easier** and more **flexible** than the native .NET [Process](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process?view=net-10.0) class.

```bash
dotnet add package clirwap
```

The next order of business is that you need to know

1. The **name** of the `7-Zip` **executable**
2. **Where** it is

In [macOS](https://www.apple.com/os/macos/) (that I am using), the executable is actually named `7zz`.

You can find out where it is using the `where` command.

```bash
where 7zz
```

If it is installed, the location will be printed.

![7zLocation](../images/2026/01/7zLocation.png)

We now have enough to write the code.

```c#
using System.Reflection;
using CliWrap;
using CliWrap.Buffered;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console().CreateLogger();

// Extract the current folder where the executable is running
var currentFolder = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;

// Construct the full path to the source files
var folderWithBooks = Path.Combine(currentFolder, "Books");

// Construct the full path to the zip file
var target7ZipFile = Path.Combine(currentFolder, "Books.7z");

// Path to 7zip executable
const string executablePath = "/opt/homebrew/bin/7zz";

// Delete 7zip file if it exists
if (File.Exists(target7ZipFile))
    File.Delete(target7ZipFile);

// Orchestrate the command line to excute and run
var result = await Cli.Wrap(executablePath) // Set the path to the executable
    .WithArguments(args => args
            .Add("a") //Specify to create an archive
            .Add("-t7z") // Specify the target format - 7z
            .Add(target7ZipFile) // Taget file name
            .Add($"{folderWithBooks}//*") // The files in the source folder
            .Add("-mx=9") // max compression
    )
    .ExecuteBufferedAsync();

// Check if the process succeeded
if (result.ExitCode != 0)
    Log.Error("7-Zip failed: {Message}", result.StandardError);
else
    Log.Information("Written files in {SourceFiles} to {Target7ZipFile} : {Message}", folderWithBooks, target7ZipFile,);
```

Here, we use `CliWrap` to construct the `7zz` command and its **arguments**, then **execute** it.

If we run this code, we should see the following:

![7zipConsole](../images/2026/01/7zipConsole.png)

The `7-Zip` file is now in the output folder.

![7zipOutput](../images/2026/01/7zipOutput.png)

### TLDR

**To create a `7-Zip` archive, it is best to automate the command-line executable.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-01-25%20-%207zipCreator).

Happy hacking!
