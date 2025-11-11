---
layout: post
title: Splitting A String Into An Array In C# & .NET
date: 2025-11-10 20:07:10 +0300
categories:
    - C#
    - .NET
---

A common task you will carry out is, given a `string`, to convert it into an `array` **delimited** by a chosen **token**.

For example:

```plaintext
This is a string that we want to split
```

If we want to delimit it using a space, we would use the [Split](https://learn.microsoft.com/en-us/dotnet/api/system.string.split?view=net-9.0) method of the `string`, like this, 

```c#
var input = "This is a string that we want to split";
var splitArray = input.Split(" ");
foreach (var entry in splitArray)
{
	Console.WriteLine($"'{entry}'");
}
```

If we run this code, it will print the following:

```plaintext
'This'
'is'
'a'
'string'
'that'
'we'
'want'
'to'
'split'
```

This seems simple enough.

Complications arise when there is **more than one token** in succession.

For example:

```plaintext
This is a    string that   we want to   split
```

The same code will print the following:

```plaintext
'This'
'is'
'a'
''
''
''
'string'
'that'
''
''
'we'
'want'
'to'
''
''
'split'
```

You can see here that the `array` contains **multiple** elements with **empty** `strings`.

Usually, you don't want this to happen.

Luckily, the `Split` method supports this natively - you pass it the [StringSplitOptions.RemoveEmptyEntries](https://learn.microsoft.com/en-us/dotnet/api/system.stringsplitoptions?view=net-9.0) `enum`, like this:

```c#
splitArray = input.Split(" ", StringSplitOptions.RemoveEmptyEntries);
foreach (var entry in splitArray)
{
	Console.WriteLine($"'{entry}'");
}
```

This will now print the following:

```plaintext
'This'
'is'
'a'
'string'
'that'
'we'
'want'
'to'
'split'
```

The enum instructs the `Split` operation to **remove all elements consisting only of empty strings**.

### TLDR

**The `StringSplitOptions.RemoveEmptyEntries` *enum* when passed to `String.Split` removes all empty strings from the returned array.**

The code is in my GitHub.

Happy hacking!
