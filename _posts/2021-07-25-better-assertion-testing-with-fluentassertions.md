---
layout: post
title: Better Assertion Testing With FluentAssertions
date: 2021-07-25 12:56:26 +0300
categories:
    - Testing
    - XUnit
    - NUnit
---
In the .NET world, there are two main unit testing frameworks: [XUnit](https://xunit.net/) and [NUnit](https://nunit.org/).

XUnit is installed like so:

```bash
dotnet add package xunit
```

A typical test will look like this:

```csharp
[Fact]
public void Test_For_Sum()
{
    var sum = 2 + 5;
    Assert.Equal(7, sum);
}
```

Note the `[Fact]` attribute that indicates that the method is a test.

The `Assert.Equal` code is what is responsible for checking that the `sum`, `7` is equal to the expected value, `sum`

NUnit is installed like so

```bash
dotnet add package xunit
```

A typical test will look like this:

```csharp
[Test]
public void Test_For_Sum()
{
    var sum = 2 + 5;
    Assert.AreEqual(7, sum);
}
```

Very similar to XUnit - tests are indicated using the `[Test]` attribute, and the method to verify equality is `AreEqual`, rather than `Equal`

But this isn't a post about which is better. They are pretty much equally matched in terms of functionality.

How can the experience of writing tests be made simpler and more intuitive?

Enter [FluentAssertions](https://fluentassertions.com/).

This is a library that enhances whatever unit testing framework you are using.

Install it like so:

```bash
dotnet add package fluentassertions
```

In addition to XUnit and NUNit, FluentAssertions supports the following frameworks:
* MSTest (Visual Studio 2010, 2012 Update 2, 2013 and 2015)
* MSTest V2 (Visual Studio 2017, Visual Studio 2019)
* MBUnit
* Gallio
* NSpec
* MSpec

Once you add the following using statement;

```csharp
using FluentAssertions;
```

A test on xUnit will look like this:

```csharp
[Fact]
public void Test_For_Sum2()
{
    var sum = 2 + 5;
    sum.Should().Be(7);
}
```

And one on NUnit will look like this:

```csharp
[Test]
public void Test_For_Sum2()
{
    var sum = 2 + 5;
    sum.Should().Be(7);
}
```

Notice if you will the fact that the assertion code is exactly the same for both testing frameworks.

```csharp
sum.Should().Be(7);
```

It is also easier to read and understand what is happening here.

The sum should be 7

This is much more intuitive.

This means that regardless of the test framework you use, anyone reading the tests will understand what is being tested, without having to know the framework specific assertion terminologies. This makes your code more readable.

It also frees you from remembering that the assertions must be specified in a particular order - `expected` and then `actual`

```csharp
Assert.AreEqual(7, sum);
```

This is important for people who use your code, regardless of the test framework they use, to be able to read and interpret your code.

FluentAssertions also allows you to elegantly combine assertions into a single line.

So you can do something like this:

```csharp
[Test]
public void Test_For_Sum3()
{
    var sum = 2 + 5;
    sum.Should().Be(7).And.BeGreaterThan(0);
}
```

Here we are checking that the `sum` is 7 and also greater than 0.

This means we can chain assertions together, providing they are relevant - otherwise the assertion will get too complicated to interpret.

FluentAssertions also make exception assertion testing cleaner.

As it so happens, testing for exceptions in xUnit and NUnit frameworks is exactly the same:

```csharp
public void Test_For_Exception()
{
    int denom = 0;
    var result = 0;
    Assert.Throws<DivideByZeroException>(() => result = 6 / denom);
}
```

we can rewrite this slightly differently using FlunetAssertions to avoid using the `Assert`

```csharp
[Test]
public void Test_For_Exception2()
{
    int denom = 0;
    var result = 0;
    // Create an action
    Action action = () => result = 6 / denom;
    // Attemt to execute the action
    action.Should().Throw<DivideByZeroException>()
        .WithMessage("Attempted to divide by zero.");
}
```

The code is slightly more complicated but:
1. It will work for all test frameworks
2. You can do complex assertions - here we are checking the type of exception AND the message property of the exception - the exception object is available for detailed assertions

FluentAssertions is therefore a valuable tool to not only written better, more understandable tests, but also tests that can be understood by users of other test frameworks.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-07-25%20-%20Better%20Assertion%20Testing%20With%20Fluent%20Assertions).

Happy hacking!