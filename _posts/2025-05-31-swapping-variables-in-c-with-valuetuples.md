---
layout: post
title: Swapping Variables In C# With ValueTuples
date: 2025-05-31 15:16:08 +0300
categories:
    - C#
    - .NET
---

In the preliminary stages of learning programming, you may have encountered this assignment.

> You have two variables, `a` and b, such that `a` is `10` and `b` is `20`. 
>
> Write a program that swaps the values.

Your first naive attempt almost certainly looked like this:

```c#
var a = 10;
var b = 30;

Console.WriteLine($"a is {a} and b is {b}");

a = b;
b = a;

Console.WriteLine($"a is {a} and b is {b}");
```

Which, of course, prints the wrong thing.

```plaintext
a is 10 and b is 30
a is 30 and b is 30
```

The correct solution would introduce an **intermediate variable** and look something like this:

```c#
var a = 10;
var b = 30;

Console.WriteLine($"a is {a} and b is {b}");

var temp = a;

a = b;
b = temp;

Console.WriteLine($"a is {a} and b is {b}");
```

This prints the following:

```plaintext
a is 10 and b is 30
a is 30 and b is 10
```

A creative solution to this problem is to utilize the [ValueTuple](https://learn.microsoft.com/en-us/dotnet/api/system.valuetuple?view=net-9.0).

```c#
var a = 10;
var b = 30;

Console.WriteLine($"a is {a} and b is {b}");

(a, b) = (b, a);

Console.WriteLine($"a is {a} and b is {b}");
```

The magic is taking place here:

```c#
(a, b) = (b, a);
```

Here we are creating a `ValueTuple` on the left and then **deconstructing** the values on the right.

This will also run as expected.

```plaintext
a is 10 and b is 30
a is 30 and b is 10
```

### TLDR

**You can use `ValueTuple` to swap variables.**

Happy hacking!
