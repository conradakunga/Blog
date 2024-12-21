---
layout: post
title: How To Work With Different Numbering Systems In C#
date: 2024-12-20 03:25:15 +0300
categories:
    - C#
---

When it comes to numbers, we overwhelmingly work with the [decimal number system](https://www.geeksforgeeks.org/decimal-number-system/), which uses a base of 10.

When say the following:

```csharp
int number = 1000;
```

We (human beings) and the C# compiler and runtime understand this to mean `1,000` in base `10`.

The C# compiler and runtime, however, support multiple numbering systems.

If we wanted to use a base of [hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal), or hex, which is to say base `16`,  we prefix the number with `Ox`. This is called a [number literal](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/integral-numeric-types).

```
int number = 0x1000;
```

If we write this number to the console,

```csharp
Console.WriteLine(number);
```

the following will be printed

```plaintext
4096
```

We can also get a hex representation of a number by using the [format specifier](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings) `x`.

```csharp
int number = 1000;
var hexRepresentation = 1000.ToString("x");
Console.WriteLine(hexRepresentation);
```

This will print the following:

```plaintext
3e8
```

C# also supports the [binary numbering system](https://en.wikipedia.org/wiki/Binary_number), base 2.

To use a binary number literal, we prefix the number with `0b`

```csharp
int number = 0b1000;
Console.WriteLine(number);
```

This will print the following

```csharp
8
```

If we already have a number and want to **display** its decimal equivalent, we can use the format specifier `b`

```csharp
var number = 8;
Console.WriteLine(number.ToString("b"));
```

We can also indicate we are using an [octal numbering system](https://en.wikipedia.org/wiki/Octal), base 8.

This requries a bit more work, as there are no number literals for octal.

To indicate a number is octal, you first convert it to a string and then use an [overload of the Convert.ToInt32](https://learn.microsoft.com/en-us/dotnet/api/system.convert.toint32?view=net-9.0) that takes a base as a parameter.

```csharp
int number = 1000;
var octalRepresentation = Convert.ToInt32(number.ToString(), 8);
Console.WriteLine(octalRepresentation);
```

This will print the following:

```charp
512
```

At this point, you might ask what other numbering systems the runtime supports if `Convert.ToInt32` allows you to specify the base. The only supported bases are `2`, `8`, `10` and `16`.

Given the number system operations work with integers (and not other numeric types like float and decimal), this logic will also work with:

- [Convert.ToInt16](https://learn.microsoft.com/en-us/dotnet/api/system.convert.toint16?view=net-9.0)
- [Convert.ToInt64](https://learn.microsoft.com/en-us/dotnet/api/system.convert.toint64?view=net-9.0)

Happy hacking!