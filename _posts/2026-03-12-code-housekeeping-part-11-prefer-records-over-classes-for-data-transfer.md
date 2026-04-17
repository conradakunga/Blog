---
layout: post
title: Code Housekeeping - Part 11 - Prefer Records Over Classes For Data Transfer
date: 2026-03-12 10:50:00 +0300
categories:
    - C#
    - Languages
    - CodeHouseKeeping
    - Code
    - Quality
---

**Code Housekeeping** refers to general rules of thumb that make code easier to **read**, **digest**, and **modify** for other developers, **yourself** included.

A very common task that you will be required to do is to hydrate a `type` from the **database** and then use that downstream, either in an **API** or for binding to a **user interface**.

Take for example this `Car` type, that is modeled for the database.

```c#
public sealed class Car
{
    public required int Id { get; set; }
    public required string Make { get; set; }
    public required string Model { get; set; }
    public required int Capacity { get; set; }
    public required int YearOfManufacture { get; set; }
}
```

We then have some sort of [data transfer object](https://en.wikipedia.org/wiki/Data_transfer_object), DTO, that we use for UI binding.

```c#
public sealed class CarDTO
{
    public required int Id { get; set; }
    public required string Make { get; set; }
    public required string Model { get; set; }
    public required int Capacity { get; set; }
    public required int YearOfManufacture { get; set; }
}
```

Our code will then look like this:

```c#
var subaru = new Car
{
    Id = 1,
    Capacity = 2000,
    Make = "Subaru",
    Model = "Outback",
    YearOfManufacture = 2026
};

// Loaded initially
var firstDTO = new CarDTO
{
    Id = subaru.Id,
    Capacity = subaru.Capacity,
    Make = subaru.Make,
    Model = subaru.Model,
    YearOfManufacture = subaru.YearOfManufacture
};

// Loaded sepearately
var secondDTO = new CarDTO
{
    Id = subaru.Id,
    Capacity = subaru.Capacity,
    Make = subaru.Make,
    Model = subaru.Model,
    YearOfManufacture = subaru.YearOfManufacture
};
```

Here, for whatever reason, we are loading the `Car` in two different contexts.

A problem arises when we do this:

```c#
// Check if the cars are the same

if (firstDTO == secondDTO)
{
    Console.WriteLine("This is the same vehicle");
}
else
{
    Console.WriteLine("These are different vehicles");
}
```

This will print the following:

```plaintext
These are different vehicles
```

![recordvsClass](../images/2026/03/recordvsClass.png)

This is because as far as the runtime is concerned, **these are different things despite having identical properties**.

As discussed in this post, "[Customizing Object Equality In C# & .NET]({% post_url 2024-12-19-customizing-object-equality-in-c-net %})", you have to do extra work to get the runtime to understand what you mean by equality.

```c#
public sealed class CarDTO : IEquatable<CarDTO>
{
    public required int Id { get; set; }
    public required string Make { get; set; }
    public required string Model { get; set; }
    public required int Capacity { get; set; }
    public required int YearOfManufacture { get; set; }

    public bool Equals(CarDTO? other)
    {
        if (other is null)
            return false;

        if (ReferenceEquals(this, other))
            return true;

        return Id == other.Id &&
               Make == other.Make &&
               Model == other.Model &&
               Capacity == other.Capacity &&
               YearOfManufacture == other.YearOfManufacture;
    }

    public override bool Equals(object? obj)
        => Equals(obj as CarDTO);

    public override int GetHashCode()
        => HashCode.Combine(Id, Make, Model, Capacity, YearOfManufacture);

    public static bool operator ==(CarDTO? left, CarDTO? right)
    {
        if (left is null)
            return right is null;

        return left.Equals(right);
    }

    public static bool operator !=(CarDTO? left, CarDTO? right)
        => !(left == right);
}
```

In this case, we have implemented the [IEquatable](https://learn.microsoft.com/en-us/dotnet/api/system.iequatable-1?view=net-10.0) interface and provided implementations for:

1. `Equals`
2. `GetHashCode`
3. `==`
4. `!==`

The code now runs as expected.

![recordVsClass2](../images/2026/03/recordVsClass2.png)

This is a lot of **unnecessary** work.

You can enjoy the **same benefits** by simply making the `DTO` a [record](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record), rather than a [class](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/classes).

```c#
public sealed record CarDTO
{
    public required int Id { get; set; }
    public required string Make { get; set; }
    public required string Model { get; set; }
    public required int Capacity { get; set; }
    public required int YearOfManufacture { get; set; }
}
```

It is important to note that a `record` is still a `class`, just with some handy **enhancements** injected by the compiler.

### TLDR

**For data transfer scenarios, use `record` rather than `class`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-03-12%20-%20RecordOverClass).

Happy hacking!
