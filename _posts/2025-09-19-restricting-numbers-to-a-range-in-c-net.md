---
layout: post
title: Restricting Numbers To A Range In C# & .NET
date: 2025-09-19 10:38:47 +0300
categories:
    - C#
    - .NET
---

Suppose you were building a digital **sensor** of some sort.

This sensor would retrieve values from an **API**.

The sensor display ranges from `0` (**min**) to `10` (**max**).

However, there is a possibility that the API could occasionally return values less than `0`, or greater than `10`.

In these scenarios, you want to restrict the display such that any values less than `0` are displayed as `0`, and any values greater than 10 are displayed as `10`.

The initial version would look like this:

```c#
public class Sensor
{
  public int Display { get; }

  public Sensor(int input)
  {
    Display = input;
  }
}
```

Our first improvement to add restrictions would look like this:

```c#
namespace V2
{
  public class Sensor
  {
    public int Display { get; }

    public Sensor(int input)
    {
      if (input < 0)
      	Display = 0;
      else if (input > 10)
      	Display = 10;
      else
      	Display = input;
    }
  }
}
```

We can also write it like this, using [switch expressions](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/switch-expression):

```c#
namespace V2
{
  public class Sensor
  {
    public int Display { get; }

    public Sensor(int input)
    {
      Display = input switch
      {
        < 0 => 0,
        > 10 => 10,
        _ => input
      };
    }
  }
}
```

A better way to do this is to use the [Math.Clamp](https://learn.microsoft.com/en-us/dotnet/api/system.math.clamp?view=net-9.0) method.

The documentation says this:

> Returns `value` clamped to the inclusive range of `min` and `max`.

It has overloads for all the **numeric** types.

We can update our code to use this as follows:

```c#
namespace V4
{
  public class Sensor
  {
    public int Display { get; }

    public Sensor(int input)
    {
    	Display = Math.Clamp(input, 0, 10);
    }
  }
}
```

Much **cleaner**, much **terser**.

Over and above this, it is easier to address logic bugs around edge cases for this comparison:

```c#
if (input < 0)
  Display = 0;
else if (input > 10)
  Display = 10;
else
  Display = input;
```

We, of course, verify this with some **tests**:

```c#
public class SensorTests
{
  [Theory]
  [InlineData(0, 0)]
  [InlineData(-1, 0)]
  [InlineData(5, 5)]
  [InlineData(10, 10)]
  [InlineData(11, 10)]
  public void Test1(int input, int expected)
  {
    var sensor = new Sensor(input);
    sensor.Display.Should().Be(expected);
  }
}
```

### TLDR

**`Math.Clamp()` is a useful method for restricting numeric values to a known range.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-19%20-%20DigitalSensor).

Happy hacking!
