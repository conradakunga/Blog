---
layout: post
title: Using Trim, TrimStart & TrimEnd In C# & .NET
date: 2025-10-18 20:46:33 +0300
categories:
    - C#
    - .NET
---

When it comes to dealing with the removal of **leading** and **trailing** [whitespace](https://en.wikipedia.org/wiki/Whitespace_character), the goto method is the [Trim()](https://learn.microsoft.com/en-us/dotnet/api/system.string.trim?view=net-9.0) method of the [string](https://learn.microsoft.com/en-us/dotnet/api/system.string?view=net-9.0) object.

Take these two `strings`:

 ```plaintext
  a boy 
 	a boy	
 ```

The second one is clearly **preceded** by a `tab`.

But you can't tell by looking that it is also **succeeded** by a `tab`.

Nor can you tell by looking that the first is **preceded** by a `space` and **succeeded** by another.

You can remove the whitespace like this:

```c#
var first = " a boy ";
var second = "	a boy	";

Console.WriteLine(first.Trim());

Console.WriteLine(second.Trim());
```

Which will print the cleaned-up versions:

```plaintext
a boy
a boy
```

Well and good - the **leading** and **trailing** whitespace characters have been removed.

However, there are times when you don't want this. That is to say:

1. You only want to trim the **leading** whitespace characters, or
2. You only want to trim the **trailing** whitespace characters

There are legit reasons for this - perhaps you are **parsing command line arguments**, or the **spaces are part of the data**.

To trim only the **leading** whitespace, use the [TrimStart()](https://learn.microsoft.com/en-us/dotnet/api/system.string.trimstart?view=net-9.0) method.

```c#
Console.WriteLine(second.TrimStart());
```

To trim only the trailing whitespace, use the TrimEnd() method.

```c#
Console.WriteLine(second.TrimEnd());
```

### TLDR

**In addition to the `Trim()` method that removes all leading and trailing whitespace, you can use `TrimStart()` to remove just the leading whitespace and `TrimEnd()` to remove just the trailing whitespace.**

Happy hacking!
