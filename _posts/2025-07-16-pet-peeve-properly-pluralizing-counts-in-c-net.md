---
layout: post
title: Pet Peeve - Properly Pluralizing Counts In C# & .NET
date: 2025-07-16 04:07:14 +0300
categories:
    - C#
    - .NET
    - StarLibrary
---

A very common use case you will invariably run into is invoking a method that returns results, and then notifying the user in some way of the **number** of results that were returned.

Let us take our favourite type:

```c#
public record Spy
{
  public required string Firstname { get; init; }
  public required string Surmame { get; init; }
  public required DateOnly DateOfBirth { get; init; }
}
```

We want to generate a number of Spy objects, and to do this, we will use our friend the [Bogus](https://github.com/bchavez/Bogus) library.

```bash
dotnet add package Bogus
```

We then configure `Bogus` as follows:

```c#
var faker = new Faker<Spy>()
  // Use a fixed seed
  .UseSeed(0)
  // Configure first name
  .RuleFor(s => s.Firstname, t => t.Person.FirstName)
  // Configure surname
  .RuleFor(s => s.Surmame, t => t.Person.LastName)
  // Set date of birth is 50 years in the past max
  .RuleFor(s => s.DateOfBirth, t => DateOnly.FromDateTime(t.Date.Past(50)));
```

Finally, we generate a number of `Spy` objects and **print** the **count**.

```c#
// Generate
var spies = faker.Generate(15);

// Notify
Console.WriteLine($"{spies.Count} spies were generated");
```

This will print the following:

```plaintext
15 spies were generated
```

Now, suppose the generated count was only 1.

```c#
// Generate
var spies = faker.Generate(1);

// Notify
Console.WriteLine($"{spies.Count} spies were generated");
```

This generates the following:

```c#
1 spies were generated
```

This is **grammatically incorrect**.

There are a number of solutions to this.

## Generic Caption

A popular solution is to have a generic caption, like this:

```plaintext
1 spy/spies was generated
```

It isn't very elegant for this use case, but it works slightly better with other nouns

```c#
1 book(s) was generated
1 teacher(s) was returned
```

These are **still grammatically incorrect**.

## Explicit Count

A better approach is to do some heavy lifting by explicitly writing code to generate a conditional message.

We start with a function that does the work for us:

```c#
public string GetCount(int count) => count switch
{
  // Zero returns
  0 => "No spies were",
  // One return
  1 => "One spy was",
  // Any other result
  _ => $"{count} spies were"
};
```

We then invoke it as follows:

```c#
Console.WriteLine($"{GetCount(spies.Count)} generated");
```

If we try with the use cases - `15`, 1 and `0`, we get the following results:

```plaintext
15 spies were generated
One spy was generated
No spies were generated
```

## Humanizer

Another approach is to use the Humanizer library, which has a solution for this problem.

First, add the library:

```bash
dotnet add package Humanizer.Core
```

We can then leverage the `ToQuantity` extension method of the string object, which will be responsible for **pluralizing** or **singularizing** the quantity.

We can then interpolate that into a `string`.

```c#
Console.WriteLine($"{"spy".ToQuantity(spies.Count)} generated");
```

This will print the following for our examples:

```plaintext
15 spies generated
1 spy generated
0 spies generated
```

### TLDR

**It is advisable to take some time to properly pluralize counts for messages to users, and there are three ways to do this**

The code is in my GitHub.

Happy hacking!
