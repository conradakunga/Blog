---
layout: post
title: .NET 11 Preview - Passing Environment Variables
date: 2026-07-01 23:46:22 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

In a previous post, "[Overriding appsettings.json via Environment Variables]({% post_url 2025-05-14-overriding-appsettingsjson-via-environment-variables %})", we looked at how to **access** and **override** [environment variables](https://en.wikipedia.org/wiki/Environment_variable) in our applications.

Take the following simple program that has the following code:

```c#
Console.Write(Environment.GetEnvironmentVariable("HOME"));
```

If you run this, it will print your **home** directory:

![defaultHome](../images/2026/07/defaultHome.png)

If you wanted to change this for **testing** purposes, you would typically do it like this;

```bash
export Home=/Users/Conrad
```

And then we would **re-run our program** to pick up the new values.

This tends to be pretty **cumbersome** for a couple of reasons:

1. You affect **other applications** and tools running that might use this value
2. It can get **monotonous** if you do this a lot

.NET 11 has a solution for this - you can pass the value you want accessed in the command like using the `-e` argument  of the [dotnet run tool](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-run), with the **name** of the variable you want to set followed by its **value**.

```bash
dotnet run -e NAME=VALUE
```

So we can simplify our debug and runtime experience as follows:

```bash
dotnet run -e HOME=/Users/Conrad
```

This will print the following:

![overriddenHome](../images/2026/07/overriddenHome.png)

### TLDR

**You can pass environment variables you want your application to use using the `-e` argument.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-07-01%20-%20TestEnvironment).

Happy hacking!
