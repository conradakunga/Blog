---
layout: post
title: Code Housekeeping - Part 7 - Eschew Methods With Many Parameters
date: 2026-03-08 11:54:58 +0300
categories:
    - C#
    - Languages
    - CodeHouseKeeping
    - Code
    - Quality
---

**Code Housekeeping** refers to general rules of thumb that make code easier to **read**, **digest**, and **modify** for other developers, **yourself** included.

When writing your code, you will **inevitably** have to write [methods](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/methods).

And they start off simply enough:

```c#
public void CreateCar(string make, string model)
{
}
```

We then make some improvements:

```c#
public void CreateCar(string make, string model, int year)
{
}
```

And some more:

```c#
public void CreateCar(string make, string model, int year, string market)
{
}
```

And still more:

```c#
public void CreateCar(string make, string model, int year, string market, bool leftHandDrive)
{
}
```

And one more:

```c#
public void CreateCar(string make, string model, int year, string market, bool leftHandDrive, int engineCapacity)
{
}
```

While technically correct, this method is getting increasingly **unwieldy**.

Take a typical invocation:

```c#
var factory = new CarFactory();
factory.CreateCar("Subaru", "Outback", 2025, "Africa", false, 2000);
```

As we add more and more parameters, some **problems** come up:

1. Increasingly difficult to **read**
2. Very difficult to **refactor** if in use in several places
3. Very easy to inadvertently **introduce bugs** by swapping parameter

A way to mitigate this is to create objects that will collect the parameters and pass this around.

Something like this:

```c#
public sealed record CarCreateRequest(
    string make,
    string model,
    int year,
    string market,
    bool leftHandDrive,
    int engineCapacity);
```

We can then refactor our `CreateCar` method like this:

```c#
public void CreateCar(CarCreateRequest request)
{
}
```

And then we invoke it like this:

```c#
var request = new CarCreateRequest("Subaru", "Outback", 2025, "Africa", false, 2000);
factory.CreateCar(request);
```

Now, you might argue haven't we just moved the problem from the method to the object?

Yes and no.

The main benefit here is that the method is relatively **static** - if we need additional properties for the `CarCreateRequet`, the method itself is unaffected.

This makes **refactoring** and **evolution** of the code much easier.

We will look at how to mitigate the problems with constructors in the next post.

What constitutes "too many parameters"? This, naturally, is a context-sensitive issue. But a good **rule of thumb**, especially for an **method you expect to evolve** that is used a lot, is past `4` or 5

### TDLR

**Rather than pass around many `parameters`, pass around an aggregated `object`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-03-08%20-%20MethodParameters).

Happy hacking!
