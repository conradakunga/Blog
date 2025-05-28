---
layout: post
title: Calling Async Methods In Constructors
date: 2025-05-28 00:30:12 +0300
categories:
    - C#
    - .NET
---

Assume we have the following type, the `Spy`.

```c#
public sealed class Spy
{
  public string FirstName { get; }
  public string Surname { get; }
  public Spy(string firstName, string surname)
  {
    FirstName = firstName;
    Surname = surname;
  }
}
```

You can see here that it has a constructor that sets the `FirstName` and `Surname`.

Suppose we want to **improve** our `Spy` and play a **theme song** during the construction of the object.

We first introduce the method:

```c#
// Play theme song here
public async Task PlaySong()
{
    await Task.Delay(TimeSpan.FromSeconds(5));
    Console.WriteLine("Playing that song!");
}
```

Then we call it from the `constructor`.

```c#
public Spy(string firstName, string surname)
{
    FirstName = firstName;
    Surname = surname;
    await PlaySong();
}
```

This code will fail to compile with the following errors:

```plaintext
AsyncConstructors failed with 2 error(s) (1.0s)
  /Users/rad/Projects/blog/BlogCode/AsyncConstructors/Spy.cs(10,9): error CS4033: The 'await' operator can only be used within an async method. Consider marking this method with the 'async' modifier and changing its return type to 'Task'.
  /Users/rad/Projects/blog/BlogCode/AsyncConstructors/Spy.cs(10,9): error CS4008: Cannot await 'void'

Build failed with 2 error(s) in 1.4s
```

You might try to make the `constructor` `async` but that is **impossible** - the `constuctor` must return the **object**, and currently you **cannot change the return type of the constructor**.

There is, however, an **elegant solution** to this problem.

You can make a [factory method](https://en.wikipedia.org/wiki/Factory_method_pattern) that will be responsible for calling the `constructor` and running any `async` methods we may have.

```c#
public sealed class Spy
{
    public string FirstName { get; }
    public string Surname { get; }

    private Spy(string firstName, string surname)
    {
        FirstName = firstName;
        Surname = surname;
    }

    // Play theme song here
    public async Task PlaySong()
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        Console.WriteLine("Playing that song!");
    }

    /// <summary>
    /// Factory method to return a spy
    /// </summary>
    /// <param name="firstName"></param>
    /// <param name="surname"></param>
    /// <returns></returns>
    public static async Task<Spy> CreateSpy(string firstName, string surname)
    {
        // Call private constructor
        var spy = new Spy(firstName, surname);
        // Call async method
        await spy.PlaySong();
        return spy;
    }
}
```

A couple of things to note:

1. The factory method is [static](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/static-classes-and-static-class-members) and [async](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/)
2. The [constructor](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/using-constructors) is [private](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/private-constructors) - and this cannot be called from outside.
3. After calling the `constructor`, the factory method, itself `async`, can call **another** `async` method.

This is relevant to our series on [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component]({% post_url 2025-04-17-designing-building-packaging-a-scalable-testable-net-open-source-component-part-1-introduction %}), and in particular a problem we had when implementing the `AmazonS3StorageEngine` where some of the [Amazon libraries only had async versions]({% post_url 2025-05-26-designing-building-packaging-a-scalable-testable-net-open-source-component-part-21-testing-amazon-s3-storage-locally %}).

We can this initialize a `Spy` **asynchronously** as follows:

```c#
// Create the spy asynchronously
var jamesBond = await v2.Spy.CreateSpy("James", "Bond");
// Use the spy
Console.WriteLine($"Spy was created: {jamesBond.FirstName} {jamesBond.Surname}");
```

This will print the following:

```plaintext
Playing that song!
Spy was created: James Bond
```

### TLDR

**We can get around the fact that `constructors` cannot be `async` or call `async` methods by implementing a *factory* method with a *private constructor* to initiailize our objects.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-05-29%20-%20Async%20Construction).

Happy hacking!
