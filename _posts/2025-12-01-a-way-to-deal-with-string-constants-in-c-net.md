---
layout: post
title: A Way To Deal With String Constants In C# & .NET
date: 2025-12-01 19:42:10 +0300
categories:
    - C#
    - .NET
---

When writing software, you will typically need to deal with **constants**. A [constant](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constants) is a value that you know at **compile time** and **will not change**.

Typically, we declare it like so:

```c#
const string ConfigurationSettingName = "ConfigurationSettingName";
```

And you would then use it like this:

```c#
var value = DatabaseAccessObject.GetSetting(ConfigurationSettingName);
```

Here, `DatabaseAccessObject` is a class that does the heavy lifting of **fetching a value** from the database.

The trouble arises when, by **accident** (or **intent**), the actual value of the constant is **changed**.

```c#
const string ConfigurationSettingName = "ConfigurationSettingNames";
```

Unbeknownst to you, this will break at runtime, where your setting is not correctly fetched from the database -the spelling is **different**.

A simple way around this is to use the [nameof](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/nameof) operator.

This allows you to do something like this:

```c#
const string ConfigurationSettingName = nameof(ConfigurationSettingName);
```

During compilation, the constant is populated with the actual value - '*ConfigurationSettingName*'.

Here, you cannot inadvertently **rename** the constant value - you will get a **compile-time error.**

If you want to change it, you must also change the name of the constant.

In this fashion, the **name** of the constant and its **value** are always coordinated.

### TLDR

**Use the `nameof` operator to tie the *name* of a constant to its *value*.**

Happy hacking!
