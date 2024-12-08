---
layout: post
title: Truncating Numbers In C#
date: 2024-11-28 03:32:16 +0300
categories:
    - C#
    - .NET
---

If you have the following number, `123.456`, and you want to write it to the console, or anywhere for that matter to 2 decimal places, you would do it like so:

```csharp
Console.WriteLine(123.456.ToString("#,0.00"));
```

This would print the following:

```plaintext
123.46
```

What has happened here is that C# has rounded the value for you to 2 decimal places.

Suppose you don't want this, and actually want to **truncate** the number to 2 decimal places?

There is a [Math.Truncate](https://learn.microsoft.com/en-us/dotnet/api/system.math.truncate?view=net-9.0) method, but it doesn't do what you might think it does - it actually **removes all the decimal** values and returns the integral part.

In other words `70.343` -> `70`

However, you can achieve the result of truncating decimal places by using the [Math.Round](https://learn.microsoft.com/en-us/dotnet/api/system.math.round?view=net-9.0) method and passing telling it to round [towards zero](https://learn.microsoft.com/en-us/dotnet/api/system.midpointrounding?view=net-9.0#system-midpointrounding-tozero) using the `MidpointRounding.ToZero` enum, like this:

```csharp
Console.WriteLine(Math.Round(123.456,2,MidpointRounding.ToZero).ToString());
```

This would print the following

```plaintext
123.45
```

As usual, tests must be written to verify any assertions.

```csharp
[Theory]
[InlineData(123.449, 123.44)]
[InlineData(123.450, 123.45)]
[InlineData(123.451, 123.45)]
[InlineData(123.454, 123.45)]
[InlineData(123.455, 123.45)]
[InlineData(123.456, 123.45)]
[InlineData(123.459, 123.45)]
[InlineData(123.460, 123.46)]
public void TruncationIsDoneCorrectly(decimal input, decimal expected)
{
    Math.Round(input, 2, MidpointRounding.ToZero).Should().Be(expected);
}
```

You can view and run the code for the  tests in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2024-11-28%20-%20Truncating%20Numbers%20In%20C%23)

Happy hacking!