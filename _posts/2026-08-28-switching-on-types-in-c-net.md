---
layout: post
title: Switching On Types in C# & .NET
date: 2026-08-28 09:51:31 +0300
categories:
    - C#
    - .NET
---

In our previous post, "[Using Declaration Patterns in C# & .NET]({% post_url 2026-08-27-using-declaration-patterns-in-c-net %})", we looked at how to **simplify polymorphic code** using the [declaration pattern](https://www.c-sharpcorner.com/blogs/understanding-the-declaration-pattern-in-c-sharp).

In today's post, we will look at another solution: **switching against types**.

The `type` hierarchy is as follows:

```c#
public abstract record Animal(string Name, int Legs);
public record Primate(string Name, int Legs) : Animal(Name, Legs);
public record Bird(string Name, int Legs, byte Wings) : Animal(Name, Legs);
```

Then suppose we have a **collection** like this:

```c#
Animal[] animals =
[
  new Primate("Baboon", 4),
  new Primate("Chimpanzee", 4),
  new Bird("Chicken", 2, 2),
  new Bird("Turkey", 2, 2),
];
```

If we needed to **selectively process** each `Animal`, we could do it like this:

```c#
void Process(Animal animal)
{
  switch (animal)
  {
    case Primate primate:
      Console.WriteLine($"Hello {primate.Name} Primate: you have {primate.Legs} legs");
      break;
    case Bird bird:
      Console.WriteLine($"Hello {bird.Name} bird: you have {bird.Legs} legs, {bird.Wings}");
      break;
    default:
    	Console.WriteLine("Unknown");
    break;
  }
}
```

The magic is taking place here:

```c#
case Primate primate:
  Console.WriteLine($"Hello {primate.Name} Primate: you have {primate.Legs} legs");
  break;
```

In the matching, we immediately capture the match for `Primate` into a correctly typed variable, `primate`.

Very neat.

### TLDR

**You can switch directly on `types` and capture the resulting concrete `type`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-08-28%20-%20SwitchOnType).

Happy hacking!
