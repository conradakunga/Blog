---
layout: post
title: The Null Coalescing Operator in C#
date: 2026-11-25 09:55:07 +0300
categories:
    - C#
---

A bane of software development is **having to check (where valid) whether something is** `null` so as to perform subsequent operations.

Take, for example, this `class`:

```c#
public sealed record Spy
{
  public required string FirstName { get; init; }
  public string? MiddleName { get; set; }
  public required string Surname { get; init; }
}
```

The `string?` here informs the compiler explicitly that the `MiddleName` might be `null`.

We can create a `Spy` like this:

```c#
var spy = new Spy { FirstName = "James", Surname = "Bond" };
```

Here, `MiddleName` is `null`, as we have not **explicitly** set it.

Suppose we have code that sets `MiddleName`, but **only if it is currently** `null`.

Typically, you would do it this way:

```c#
if (spy.MiddleName is null)
{
  spy.MiddleName = "Matthew";
}
```

A terser way of doing it is using the [null-coalescing operator](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/null-coalescing-operator), `??=`

```c#
spy.MiddleName ??= "Matthew";
```

This is **syntactically equivalent** to the previous code that explicitly checks for `null` first.

### TLDR

**Use the *null-coalescing operator* to assign values only if the *target* is not `null`.**

The code is in my GitHub.

Happy hacking!
