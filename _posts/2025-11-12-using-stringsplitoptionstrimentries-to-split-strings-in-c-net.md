---
layout: post
title: Using StringSplitOptions.TrimEntries To Split Strings In C# & .NET
date: 2025-11-12 13:51:36 +0300
categories:
    - C#
    - .NET
---

In a previous post, "[Splitting A String Into An Array In C# & .NET]({% post_url 2025-11-10-splitting-a-string-into-an-array-in-c-net %})", we looked at how to **split** a`string` into an `array` with the [String.Split](https://learn.microsoft.com/en-us/dotnet/api/system.string.split?view=net-9.0) method.

We also looked at how to use the [StringSplitOptions.RemoveEmptyEntries](https://learn.microsoft.com/en-us/dotnet/api/system.stringsplitoptions?view=net-9.0) `enum`, to eliminate any **empty elements** in our returned array.

In this post, we will look at how to use the `StringSplitOptions.TrimEntries` enum value to further dictate how a `string` is split.

Suppose we had the following string:

```plaintext
a , 9,   ,    , llll,
```

We can split it using the **comma** delimiter like this:

```c#
var elements = "a , 9,   ,    , llll,".Split(",").Select(x => $"'{x}'").ToArray();

foreach (var element in elements)
{
	Console.WriteLine(element);
}
```

This will print the following:

```plaintext
'a '
' 9'
'   '
'    '
' llll'
''
```

Here,  I am delimiting each element with an **apostrophe** so that we can **visualize** the results.

In the result, we can see that there is an **empty element** at the end.

We can use `StringSplitOptions.RemoveEmptyEntries` to deal with this, as outlined earlier.

```c#
elements = "a , 9,   ,    , llll,".Split(",", StringSplitOptions.RemoveEmptyEntries).Select(x => $"'{x}'").ToArray();

foreach (var element in elements)
{
	Console.WriteLine(element);
}
```

This will print the following:

```plaintext
'a '
' 9'
'   '
'    '
' llll'
```

Here we can see that the e**mpty element has been removed**.

But what about the elements consisting **entirely of spaces**?

This is what the `StringSplitOptions.TrimEntries` enum empowers.

We use it like this:

```c#
elements = "a , 9,   ,    , llll,".Split(",", StringSplitOptions.TrimEntries).Select(x => $"'{x}'").ToArray();

foreach (var element in elements)
{
	Console.WriteLine(element);
}
```

This returns the following:

```plaintext
'a'
'9'
''
''
'llll'
''
```

Here we can see that all the **spaces** have been **eliminated**.

But now we have a number of **empty** elements.

This can be addressed by **combining** the two `enum` values.

```c#
elements = "a , 9,   ,    , llll,".Split(",", StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries).Select(x => $"'{x}'").ToArray();

foreach (var element in elements)
{
	Console.WriteLine(element);
}
```

This will print the following:

```plaintext
'a'
'9'
'llll'
```

Here, we can see that just our data is being returned.

### TLDR

You can use `StringSplitOptions.TrimEntries` in combination with StringSplitOptions.RemoveEmptyEntries to control how the returned string is processed by the `String.Split` method.

The code is in my GitHub.

Happy hacking!
