---
layout: post
title: Using Tuples In Constructors
date: 2025-05-24 23:15:30 +0300
categories:
    - C#
    - .NET
---

In .NET, you would typically write a [constructor](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constructors) like this:

```c#
public sealed class Spy
{
    public Spy(string firstName, string surname)
    {
        FirstName = firstName;
        Surname = surname;
    }

    public string FirstName { get; }
    public string Surname { get; }
}
```

Pretty straightforward.

You might be interested to know that you can use [expression body constructors](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/statements-expressions-operators/expression-bodied-members#constructors) and [ValueTuples](https://learn.microsoft.com/en-us/dotnet/api/system.valuetuple?view=net-9.0) to simplify this further:

```c#
public sealed class Spy
{
    public Spy(string firstName, string surname) => (FirstName, Surname) = (firstName, surname);

    public string FirstName { get; }
    public string Surname { get; }
}
```

For **trivial** functionality such as **field assignments**, `tuples` can simplify your code.

### TLDR

You can use tuples in constructors to assign fields.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-05-24%20-%20Constructors%20%26%20Tuples).

Happy hacking!
