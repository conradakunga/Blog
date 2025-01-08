---
layout: post
title: Dependency Injection In C# & .NET Part 9 - Life Cycles
date: 2025-01-08 19:20:39 +0300
categories:
categories:
    - C#
    - .NET
    - Architecture
    - Domain Design
---
This is Part 9 of a series on dependency injection.

- [Dependency Injection In C# & .NET Part 1 - Introduction & Basic Implementation]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation %})
- [Dependency Injection In C# & .NET Part 2 - Making Implementations Swappable]({% post_url 2025-01-01-dependency-injection-in-c-net-part-2-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 3 - Making Implementations Pluggable]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 4 - Making Implementations Hot-Pluggable]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %})
- [Dependency Injection In C# & .NET Part 5 - Making All Implementations Available]({% post_url 2025-01-04-dependency-injection-in-c-net-part-5-making-all-services-available %})
- [Dependency Injection In C# & .NET Part 6 - Implementation Testing]({% post_url 2025-01-05-dependency-injection-in-c-net-part-6-implementation-testing %})
- [Dependency Injection In C# & .NET Part 7 - Integration Testing]({% post_url 2025-01-06-dependency-injection-in-c-net-part-7-integration-testing %})
- [Dependency Injection In C# & .NET Part 8 - Types Of Dependency Injection]({% post_url 2025-01-07-dependency-injection-in-c-net-part-8-types-of-depedency-injection %})
- **Dependency Injection In C# & .NET Part 9 - Life Cycles (this post)**

In our [last post]({% post_url 2025-01-07-dependency-injection-in-c-net-part-8-types-of-depedency-injection %}), we looked at types of dependency injection, considerations, pros and cons.

In this post, we shall look at **dependency injection life cycles**.

What, you may ask, is a life cycle? This essentially dictates the conditions under which a new instance of a requested service will be created.

There are three lifetimes:

1. Singleton
2. Transient
3. Scoped

### Singleton

A service with a singleton life cycle is created **once** upon the **first request**. Every **subsequent** request for this service will be satisfied with **that created instance**.

This means **the same instance of the service will be returned for the lifetime of the application**.

Let us use a simple example of a class that generates a random number and stores it as a property.

```c#
public class SingletonNumberGenerator
{
    public int Number { get; }

    public SingletonNumberGenerator()
    {
        // Generate a number between 0 and 1000
        Number = Random.Shared.Next(0, 1_000);
    }
}
```

We configure our DI to register this as a singleton using the [AddSingleton](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.servicecollectionserviceextensions.addsingleton?view=net-9.0-pp) method.

```c#
// Register a singleton service
builder.Services.AddSingleton<SingletonNumberGenerator>();
```

We then write a simple API that injects two instances of our `SingletonNumberGenerator`

```c#
app.MapPost("/v15/Singleton",([FromServices] SingletonNumberGenerator first, SingletonNumberGenerator second) =>
{
    return Results.Ok(new[] { first.Number, second.Number });
});
```

If we run this, we get the following result:

```plaintext
[
  468,
  468
]
```

*Of course, you will get a different result because the numbers generated are random.*

Notice here that **both returned numbers are identical**, and will remain thus **as long as the application is running**.

### Transient

A service with a transient life cycle is **created every time it is requested**.

Take this sample class:

```c#
public class TransientNumberGenerator
{
    public int Number { get; }

    public TransientNumberGenerator()
    {
        // Generate a number between 0 and 1000
        Number = Random.Shared.Next(0, 1_000);
    }
}
```

This class is then registered as transient using the [AddTransient](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.servicecollectionserviceextensions.addtransient?view=net-9.0-pp) method.

```c#
// Register a transient service
builder.Services.AddTransient<TransientNumberGenerator>();
```

Then, we build a simple API that injects **two** instances of the class.

```c#
app.MapPost("/v15/Transient", ([FromServices] TransientNumberGenerator first, [FromServices] TransientNumberGenerator second) =>
{
    return Results.Ok(new[] { first.Number, second.Number });
});
```

If we run this, you should get a similar result:

```plantext
[
  825,
  379
]
```

Note that we have injected two instances, and each is giving us a **different result**.

### Scoped

A service with a scoped life cycle is a bit more complicated, but the essence is that it is created once **per request.**

This is typically needed when several services within your application need to use a **common service**, such as a database.

Let us create a simple generator that we will inject as transient.

```c#
public class TransientNumberGenerator
{
    public int Number { get; }

    public TransientNumberGenerator()
    {
        // Generate a number between 0 and 1000
        Number = Random.Shared.Next(0, 1_000);
    }
}
```

Let us then create a second class that happens to require a `ScopedNumberGenerator`, which we inject. This new class simply returns a generated number from the `ScopedNumberGenerator`

```c#
public class ScopedComplexService
{
    private readonly ScopedNumberGenerator _numberGenerator;
    public int Number => _numberGenerator.Number;

    public ScopedComplexService(ScopedNumberGenerator numberGenerator)
    {
        _numberGenerator = numberGenerator;
    }
}
```

We then register both services for DI using the [AddScoped](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.servicecollectionserviceextensions.addscoped?view=net-9.0-pp) method

```c#
// Register our scoped services
builder.Services.AddScoped<ScopedNumberGenerator>();
builder.Services.AddScoped<ScopedComplexService>();
```

Finally, we write an API that injects both a `ScopedNumberGenerator` and a `ScopedComplexService`

```c#
app.MapPost("/v15/Scoped", ([FromServices] ScopedNumberGenerator generator, ScopedComplexService complexService) =>
{
	return Results.Ok(new[] { generator.Number, complexService.Number });
});
```

If we run this, we get something similar to this:

```plaintext
[
  331,
  331
]
```

Notice here that the generated numbers are identical because the same instance of the `ScopedNumberGenerator` was used by the API as well as the `ScopedComplexService`.

There are also methods that allow keyed **scoped**,  **singleton** and **transient** services - [AddKeyedScoped](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.servicecollectionserviceextensions.addkeyedscoped?view=net-9.0-pp), [AddKeyedSingleton](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.servicecollectionserviceextensions.addkeyedsingleton?view=net-9.0-pp) and [AddKeyedTransient](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.servicecollectionserviceextensions.addkeyedtransient?view=net-9.0-pp).

In our final post, we will **recap what we have learnt over this series**.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/Mailer). *The source code builds from first principles as outlined in this series of posts with different versions of the API demonstrating the improvements.*

Happy hacking!
