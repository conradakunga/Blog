---
layout: post
title: Arithmetic In C# Using Hex Numbers
date: 2025-06-24 22:36:39 +0300
categories:
    - C#
    - .NET
---

I was recently helping a friend write some code to interface with some archaic system that was sending data (numbers) in [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) format, which is to say base `16`.

In case you have forgotten, here is a comparison of `decimal` and `hex`:

| Decimal | Hexadecimal |
| ------- | ----------- |
| 0       | 0           |
| 1       | 1           |
| 2       | 2           |
| 3       | 3           |
| 4       | 4           |
| 5       | 5           |
| 6       | 6           |
| 7       | 7           |
| 8       | 8           |
| 9       | 9           |
| 10      | A           |
| 11      | B           |
| 12      | C           |
| 13      | D           |
| 14      | E           |
| 15      | F           |
| 16      | 10          |

If you already have the `hex` representation, it is trivial to convert that to a number for computation.

You can do it using the [Convert.ToInt32](https://learn.microsoft.com/en-us/dotnet/api/system.convert.toint32?view=net-9.0) method, as follows:

```c#
var number = Convert.ToInt32("A", 16);
```

This will also work of the hex representation has the prefix 0x

```c#
var number = Convert.ToInt32("OxA", 16);
```

You can do the same for:

- 64 bit integers - [Convert.ToInt64](https://learn.microsoft.com/en-us/dotnet/api/system.convert.toint64?view=net-9.0)
- 16 bit integers - [Convert.ToInt16](https://learn.microsoft.com/en-us/dotnet/api/system.convert.toint16?view=net-9.0)
- Bytes - [Convert.ToByte](https://learn.microsoft.com/en-us/dotnet/api/system.convert.tobyte?view=net-9.0)

There are also equivalent methods for the [signed and unsigned](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types) equivalents.

It may also interest you to note that **you can also do arithmetic natively with hex numbers**, if you are sufficiently experienced (or motivated) to do so.

All you need to do is **prefix** your numbers with `0x`, as follows:

```c#
// Pefrorm the computation

var result = 0xA + 0xB + 0xC; // 10 + 11 + 12

Console.WriteLine(result);
```

This will print the result (in `decimal`) of `33`.

If you wanted the result in **hex**, for example to relay to an external system, you would output it like this:

```c#
var result = 255;

Console.WriteLine(result);

Console.WriteLine($"{result.ToString("X")}");
```

This will print the following:

```plantext
255
FF
```

If, for whatever reason, you wanted the hex in lowercase, you would use a lowercase X, as follows:

```c#
var result = 255;

Console.WriteLine(result);

Console.WriteLine($"{result.ToString("x")}");
```

This will print the following:

```plaintext
255
ff
```

### TLDR

**C# (& .NET) is able to convert hex to corresponding integral values for computations. It can also natively do arithmetic with hex numbers.** 

Happy hacking!
