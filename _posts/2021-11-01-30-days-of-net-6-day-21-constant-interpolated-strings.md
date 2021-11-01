---
layout: post
title: 30 Days Of .NET 6 - Day 21 - Constant Interpolated Strings
date: 2021-11-01 21:02:50 +0300
categories:
    - .NET
    - C#
---
A fairly common task in day to day programming is combining strings.

For example, if we wanted to construct a URL from various pieces, we would do it like this:

```csharp
var scheme = "https";
var path = "myorg.com";
var query = "ID=1";

var url = scheme + "://" + path + "&" + query;

Console.WriteLine(url);
```

The output should be the following:

```plaintext
https://myorg.com&ID=1
```

The trouble with this is it is not exactly easy to visualize the final output by reading the code.

This is one of the problems that [string interpolation](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/tokens/interpolated) solves.

We can rewrite the code like this:

```csharp
url = $"{scheme}://{path}&{query}";

Console.WriteLine(url);
```

This is a bit easier to read, as you don't have to do all those string concatenations - values of the variables are evaluated and substituted directly into the string.

The challenge is this only works for variables, and not for constants.

This has been changed in .NET 6.

You can use string interpolation with constants, provided that **the strings you are interpolating are also constants**.

```csharp
const string scheme = "https";
const string path = "myorg.com";
const string query = "ID=1";

const string url = $"{scheme}://{path}&{query}";

Console.WriteLine(url);
```

This means that you cannot do this:

```csharp
const string scheme = "https";
const string path = "myorg.com";
const string query = "ID=";
const int ID = 1;

const string url = $"{scheme}://{path}&{query}{ID}";

Console.WriteLine(url);
```
  
The reason here being that much as `ID` is a **constant**, it is not a `string`, and is an `integer`, so when it is being evaluated, `ToString()` will be called, and the results of this could vary.

For instance, depending on your locale, the following code:

```csharp
1000.ToString()
```

could produce one of these:

```csharp
1,000
1.000
1 000
1000
```

# Thoughts
[String interpolation for constants](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-10.0/constant_interpolated_strings) is brilliant, and will make string constants much more readable.

# TLDR
.NET 6 now allows you to use string interpolation for string constants.

Happy hacking!

**This is Day 21 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**
