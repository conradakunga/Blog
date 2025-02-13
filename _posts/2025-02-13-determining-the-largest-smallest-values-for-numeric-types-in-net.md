---
layout: post
title: Determining The Largest (& Smallest) Values For Numeric Types In .NET
date: 2025-02-13 23:28:29 +0300
categories:
    - C#
    - NET
---

There are a number of integral types in .NET:

- `sbyte` (signed byte)
- `byte` (unsigned byte)
- `short` (signed 16 bit int)
- `ushort` (unsigned 16 bit int)
- `int` (signed 32 bit integer)
- `uint` (unsigned 32 bit integer)
- `long` (signed 64 bit integer)
- `ulong` (unsigned 64 bit integer)

There are also a number of floating point types:

- `float`
- `double`
- `decimal`

Deciding which to use depends on your **circumstances** and **problem domain**, and it is important to appreciate the range of sizes for each.

You can, of course, check the documentation for [integral](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types) and [floating-point](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/floating-point-numeric-types) types.

However, there is a much quicker way to check for yourself.

Each **type** has a **field** that will give you the **maximum** and **minimum** values.

We can write a small program to print these values.

```c#
Console.WriteLine($"The largest value for sbyte is {sbyte.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for sbyte is {sbyte.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for byte is {byte.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for byte is {byte.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for short  is {short.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for short  is {short.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for ushort is {ushort.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for ushort is {ushort.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for int is {int.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for int is {int.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for uint is {uint.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for uint is {uint.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for long is {long.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for long is {long.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for ulong  is {ulong.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for ulong  is {ulong.MinValue:#,0.00}");

	Console.WriteLine($"The largest value for float is {float.MaxValue:E}");
	Console.WriteLine($"The smallest value for float is {float.MinValue:E}");

	Console.WriteLine($"The largest value for double is {double.MaxValue:E}");
	Console.WriteLine($"The smallest value for double is {double.MinValue:E}");

	Console.WriteLine($"The largest value for decimal is {decimal.MaxValue:#,0.00}");
	Console.WriteLine($"The smallest value for decimal is {decimal.MinValue:#,0.00}");
```

For the `float` and `double` types, we are outputting the values in [E notation](https://en.wikipedia.org/wiki/Scientific_notation#E_notation).

The code above will print the following:

```plaintext
The largest value for sbyte is 127.00
The smallest value for sbyte is -128.00
The largest value for byte is 255.00
The smallest value for byte is 0.00
The largest value for short  is 32,767.00
The smallest value for short  is -32,768.00
The largest value for ushort is 65,535.00
The smallest value for ushort is 0.00
The largest value for int is 2,147,483,647.00
The smallest value for int is -2,147,483,648.00
The largest value for uint is 4,294,967,295.00
The smallest value for uint is 0.00
The largest value for long is 9,223,372,036,854,775,807.00
The smallest value for long is -9,223,372,036,854,775,808.00
The largest value for ulong  is 18,446,744,073,709,551,615.00
The smallest value for ulong  is 0.00
The largest value for float is 3.402823E+038
The smallest value for float is -3.402823E+038
The largest value for double is 1.797693E+308
The smallest value for double is -1.797693E+308
The largest value for decimal is 79,228,162,514,264,337,593,543,950,335.00
The smallest value for decimal is -79,228,162,514,264,337,593,543,950,335.00
```

### TLDR

**Numeric types have `MinValue` and `MaxValue` fields that allow fetching their lower and upper bounds.**

Happy hacking!
