---
layout: post
title: Using Deconstructors In C#
date: 2025-02-05 22:13:49 +0300
categories:
    - C#
    - .NET
---

Doubtlessly, while developing programs, you will have designed and implemented classes, and more often than not, these classes have had [constructors](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constructors#:~:text=A%20constructor%20is%20a%20method,type%20are%20valid%20when%20created.).

A **constructor** is a special method that is used to **create an object** and initialize its state.

Take the following class:

```c#
public sealed class Spy
{
    public Spy(string firstName, string surname, DateOnly dateOfBirth)
    {
        FirstName = firstName;
        Surname = surname;
        DateOfBirth = dateOfBirth;
    }

    public string FirstName { get; }
    public string Surname { get; }
    public DateOnly DateOfBirth { get; }
}
```

Here is a simple program that creates a class:

```c#
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

var spy = new Spy("James", "Bond", new DateOnly(1950, 1, 1));

Log.Information("The first name is {FirstName}", spy.FirstName);
Log.Information("The surname name is {Surname}", spy.Surname);
Log.Information("The date of birth is {DateOfBirth}", spy.DateOfBirth);
```

This, unsurprisingly, will print the following:

![DeconstructOld](../images/2025/02/DeconstructOld.png)

Of interest is the fact that we need to extract **each of the components** of the `Spy` so that we can use them in some way.

Is there an easier way to get these values? There is - the object **deconstructor**.

We can update our class as follows:

```c#
public sealed class Spy
{
    public Spy(string firstName, string surname, DateOnly dateOfBirth)
    {
        FirstName = firstName;
        Surname = surname;
        DateOfBirth = dateOfBirth;
    }

    public string FirstName { get; }
    public string Surname { get; }
    public DateOnly DateOfBirth { get; }

    public void Deconstruct(out string firstName, out string surname, out DateOnly dateOfBirth)
    {
        firstName = FirstName;
        surname = Surname;
        dateOfBirth = DateOfBirth;
    }
}
```

Notice the new method we have added - `Deconstruct`. As you can see, it is a `void` method that returns data via `out` parameters.

We use the `Deconstruct` method as follows:

```c#
string firstName;
string surname;
DateOnly dateOfBirth;

(firstName, surname, dateOfBirth) = spy;

Log.Information("The first name is {FirstName}", firstName);
Log.Information("The surname name is {Surname}", surname);
Log.Information("The date of birth is {DateOfBirth}", dateOfBirth);
```

You can simplify this still further as follows:

```c#
var (firstName, surname, dateOfBirth) = spy;

Log.Information("The first name is {FirstName}", firstName);
Log.Information("The surname name is {Surname}", surname);
Log.Information("The date of birth is {DateOfBirth}", dateOfBirth);
```

You can also do it like this:

```c#
(string firstName, string surname, DateOnly dateOfBirth) = spy;

Log.Information("The first name is {FirstName}", firstName);
Log.Information("The surname name is {Surname}", surname);
Log.Information("The date of birth is {DateOfBirth}", dateOfBirth);
```



Suppose, for whatever reason, we **did not care about the date of birth** despite it being factored into the deconstructor.

We can **ignore** it or any members we are not interested in from the deconstruction by using the [discard](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/functional/discards).

```c#
var (firstName, surname, _) = spy;

Log.Information("The first name is {FirstName}", firstName);
Log.Information("The surname name is {Surname}", surname);
```

If your type is a [record](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record), and you use the [positional syntax](https://www.educative.io/answers/what-is-the-positional-syntax-for-property-definition-in-c-sharp-90), a deconstructor is **automatically generated for you** by the compiler.

Take the following example:

```c#
public record Agency(string Name, string Motto, DateOnly DateFounded);
```

We can create a simple program as follows:

```c#
var agency = new Agency("Central Intelligence Agency", "The work of a nation the center of intelligence",
    new DateOnly(1947, 9, 18));
```

We can extract the properties as follows:

```c#
var (name, motto, dateFounded) = agency;

Log.Information("The agency name is {Name}, founded in {DateFounded}", name, dateFounded);
Log.Information("The motto is {Motto}", motto);
```

This will print the following:

![DeconstructNew](../images/2025/02/DeconstructNew.png)

Notice that **we did not need to write our own deconstructor**.

### TLDR

**Object deconstructors allow you to extract the properties of an object into its constituent parameters.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-05%20-%20Deconstructors).

Happy hacking!
