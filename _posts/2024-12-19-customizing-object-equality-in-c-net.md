---
layout: post
title: Customizing Object Equality In C# & .NET
date: 2024-12-19 12:45:08 +0300
categories:
    - C#
    - .NET
    - Domain Design
---

Equality, at face value, seems like a very simple concept. The following, it can be agreed, are equal:

```csharp
var first = 1;
var second = 1;
Console.WriteLine(first == second);
```

And so too these:

```csharp
var first = "apple";
var second = "apple";
Console.WriteLine(first == second);
```

Let us introduce a new type:

```csharp
public class Contact
{
  public required string FirstName { get; init; }
  public required string MiddleName { get; init; }
  public required string Surname { get; init; }
}
```

What about now? What should this code return:

```csharp
var conrad = new Contact
{
  FirstName = "Conrad",
  Surname = "Akunga",
  MiddleName = "Marc"
};

var marc = new Contact
{
  FirstName = "Conrad",
  Surname = "Akunga",
  MiddleName = "Marc"
};
```

Unsurprisingly, it returns `false`. Remember, for a `class` equality means reference equality - both references point at the same object.

We could solve this problem by making the type a `Record`.

```csharp
public record Contact
{
  public required string FirstName { get; init; }
  public required string MiddleName { get; init; }
  public required string Surname { get; init; }
}
```

Here the compiler will compare the properties of the type and if they are all equal, then two classes with the same properties are equal.

The check

```csharp
Console.WriteLine(first == second);
```

Returns `true`

But this, technically, is cheating.

What if we made the type more complex?

```csharp
public class Contact
{
  public required string FirstName { get; init; }
  public required string MiddleName { get; init; }
  public required string Surname { get; init; }
  public required string Notes { get; init; }
}
```

We then define that two contacts are equal if they share the `FirstName`, `MiddleName` and `Surname`, but we don't care what the `Notes` are.

Our shortcut of making it a `record` won't work here.

There is a solution to this problem, but it requires a bit of effort.

1. Override the [equality operators](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/equality-operators) (== and !=) 
2. Implement [Equals](https://learn.microsoft.com/en-us/dotnet/api/system.object.equals?view=net-9.0)
3. Implement [GetHashCode](https://learn.microsoft.com/en-us/dotnet/api/system.object.gethashcode?view=net-9.0) methods.

```csharp
public class Contact
{
  public required string FirstName { get; init; }
  public required string MiddleName { get; init; }
  public required string Surname { get; init; }
  public required string Notes { get; init; }

  public static bool operator ==(Contact? left, Contact? right)
  {
  	if (ReferenceEquals(left, right))
  		return true;

    if (left is null || right is null)
    	return false;

    return left.FirstName == right.FirstName &&
      left.MiddleName == right.MiddleName &&
      left.Surname == right.Surname;
  }


  public static bool operator !=(Contact? left, Contact? right)
  {
  	return !(left == right);
  }

  public override bool Equals(object? obj)
  {
    if (obj is not Contact other)
    	return false;

    return this == other;
  }

  public override int GetHashCode()
  {
  	return HashCode.Combine(FirstName, MiddleName, Surname);
  }
}
```

With this update the code now prints what we expect - `true`.

```csharp
Console.WriteLine(first == second);
```