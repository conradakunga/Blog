---
layout: post
title: Using Tuples in Deconstructors
date: 2025-05-24 23:15:30 +0300
categories:
    - C#
    - .NET
---

In C#, you would typically write a [constructor](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constructors) like this:

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

I've written about this technique before [here]({% post_url 2020-03-21-fun-with-tuples-in-c-7-above %}).

For **trivial** functionality such as **field assignments**, `tuples` can simplify your code.

You can also make use of this technique for [deconstructors](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/functional/deconstruct).

This is a technique you can use to allow properties of your class be **returned individually**, allowing you to write code like this:

```c#
var spy = new Spy("James", "Bond");

// Deconstruct our type
var (firstname, surname) = spy;

Console.WriteLine($"The first name is {firstname}");
Console.WriteLine($"The last name is {surname}");
```

You would write one like this:

```c#
public void Deconstruct(out string firstname, out string surname)
{
    firstname = FirstName;
    surname = Surname;
}
```

This can also be rewritten using `tuples` as follows:

```c#
public void Deconstruct(out string firstname, out string surname) => (firstname, surname) = (FirstName, Surname);
```

### TLDR

**You can use tuples in constructors to *assign* fields, as well as to *deconstruct* types.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-05-24%20-%20Deconstructors%20%26%20Tuples).

Happy hacking!
