---
layout: post
title: 30 Days Of .NET 6 - Day 5 - Mathematics API Additions
date: 2021-09-10 14:30:40 +0300
categories:
    - C#
    - 30 Days Of .NET 6
---
It may surprise you to learn that even the [Math](https://docs.microsoft.com/en-us/dotnet/api/system.math?view=net-5.0) API, which generally does not change all that much, has some additions for those who do high performance trigonometric functions.

Suppose you need the cosine of an angle.

```csharp
var oldCos = Math.Cos(35);
```

Then suppose you also need the sine of an angle

```csharp
var oldSin = Math.Sin(35);
```

If you happen to need both in a computation, this is already pretty straightforward.

However there is an optimization that can be realized here - you can compute them both simultaneously - the new [Math.SinCos](https://docs.microsoft.com/en-us/dotnet/api/system.math.sincos?view=net-6.0) method.

```csharp
var result = Math.SinCos(35);

Console.WriteLine($"The Sin is {result.Sin} and the Cosine is  {result.Cos}");
```

This should print for you the following:

```plaintext
The Sin is -0.428182669496151 and the Cosine is  -0.9036922050915059
```

**HOWEVER**

I tried to benchmark the new method vs just getting the sin and cos independently as before.

At least as of release 7, [Math.SinCos](https://docs.microsoft.com/en-us/dotnet/api/system.math.sincos?view=net-6.0) seems to be **orders of magnitude slower**.

Here is the code for the benchmark (I will upload the benchmark tests to Github)

```csharp
const double angle = 35;
[Benchmark]
public (double, double) GetIndividually()
{
    var sin = Math.Sin(angle);
    var cos = Math.Cos(angle);
    return (sin, cos);
}
[Benchmark]
public (double, double) GetSimultaneously()
{
    var result = Math.SinCos(angle);
    return (result.Sin, result.Cos);
}
```

And here are the results I got

```plaintext
BenchmarkDotNet=v0.13.1, OS=Windows 10.0.19043.1165 (21H1/May2021Update)
Intel Core i5-9300H CPU 2.40GHz, 1 CPU, 8 logical and 4 physical cores
.NET SDK=6.0.100-preview.7.21379.14
  [Host]     : .NET 6.0.0 (6.0.21.37719), X64 RyuJIT
  DefaultJob : .NET 6.0.0 (6.0.21.37719), X64 RyuJIT
```

|            Method |       Mean |     Error |    StdDev |
|------------------ |-----------:|----------:|----------:|
|   GetIndividually |  0.5548 ns | 0.0435 ns | 0.0806 ns |
| GetSimultaneously | 19.4477 ns | 0.3351 ns | 0.2616 ns |

This has [already been logged](https://github.com/dotnet/runtime/issues/48776) but it seems it won't be addressed until .NET version 7.

There is also a new method for computing the reciprocal estimate of a number, [Math.ReciprocalEstimate](https://docs.microsoft.com/en-us/dotnet/api/system.math.reciprocalestimate?view=net-6.0)

```csharp
var reciprocalEstimate = Math.ReciprocalEstimate(90);
Console.WriteLine(reciprocalEstimate);
```

And finally there is another new method for computing the reciprocal of the square root of a number, [Math.ReciprocalSqrtEstimate](https://docs.microsoft.com/en-us/dotnet/api/system.math.reciprocalsqrtestimate?view=net-6.0)

```csharp
var reciprocalRootEstimate = Math.ReciprocalSqrtEstimate(90);
Console.WriteLine(reciprocalRootEstimate);
```

# Thoughts

For those who do a lot of mathematical computations, these new methods may offer performance and coding improvements.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-10%20-%2030%20Days%20Of%20.NET%206%20-%20Day%205%20-%20Math%20API%20Additions).

# TLDR

[Math](https://docs.microsoft.com/en-us/dotnet/api/system.math?view=net-6.0) class now has additional methods for some target demographics.

**This is Day 5 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**

Happy hacking!