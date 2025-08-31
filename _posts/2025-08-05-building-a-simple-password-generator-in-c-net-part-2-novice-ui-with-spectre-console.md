---
layout: post
title: Building A Simple Password Generator In C# & .NET - Part 2 - Novice UI With Spectre.Console
date: 2025-08-05 16:32:10 +0300
categories:
    - C#
    - .NET
    - StarLibrary
    - Spectre.Console
    - OpenSource
---

**This is Part 2 in a series in which we will build a simple password generator.**

In our last post, [Building A Simple Password Generator In C# & .NET - Part 1]({% post_url 2025-08-04-building-a-simple-password-generator-in-c-net-part-1 %}), we wrote the logic for a simple **password generator**.

In this post, we will build a simple **command-line interface** for the logic.

For this, we will use the [Spectre.Console](https://spectreconsole.net/) package.

```c#
dotnet add package Spectre.Console
dotnet add package Spectre.Console.Cli
```

We will first start with a simple flow where we assume the user is a novice.

We will request all the necessary requirements from the user.

```c#
using Spectre.Console;

var passwordLength = AnsiConsole.Prompt(
    new TextPrompt<int>("How long should the password be?"));
var numbers = AnsiConsole.Prompt(
    new TextPrompt<int>("How many numbers should the password contain?"));
var symbols = AnsiConsole.Prompt(
    new TextPrompt<int>("How many symbols should the password contain?"));

AnsiConsole.WriteLine($"Generating password of length {passwordLength} with {numbers} numbers and {symbols}");
```

If we run this code, the user gets the following experience:

![GeneratePrompt1](../images/2025/08/GeneratePrompt1.png)

At this point, we can wire in the password generation:

```c#
AnsiConsole.WriteLine($"Generating password of length {passwordLength} with {numbers} numbers and {symbols}...");

var password = PasswordGenerator.GeneratePassword(numbers, symbols, passwordLength);

AnsiConsole.MarkupLineInterpolated($"The generated password is [bold red]{password}[/]");
```

Running the code should yield something like the following:

![GeneratePrompt2](../images/2025/08/GeneratePrompt2.png)

Finally, we write some code to handle edge cases:

```c#
try
{
    var password = PasswordGenerator.GeneratePassword(numbers, symbols, passwordLength);

    AnsiConsole.MarkupLineInterpolated($"The generated password is [bold red]{password}[/]");
}
catch (Exception ex)
{
    AnsiConsole.MarkupLineInterpolated($"[bold red]Error generating password: {ex.Message}[/]");
}
```

![PasswordError](../images/2025/08/PasswordError.png)

In our [next post]({% post_url 2025-08-06-building-a-simple-password-generator-in-c-net-part-3-advanced-ui-with-spectreconsole %}), we will look at how to support experienced users on the command line.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/PassGen).

Happy hacking!
