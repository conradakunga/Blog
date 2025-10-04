---
layout: post
title: Generating Random Unsigned Integers In C# & .NET
date: 2025-09-25 17:51:37 +0300
categories:
    - C#
    - .NET

---

In the previous post, ["Generating Random Values For Other Integral Types In C# & .NET"]({% post_url 2025-09-24-generating-random-values-for-other-integral-types-in-c-net %}), we looked at how to generate random `integers` for other **unsigned integral types**.

The technique of using the [Next()](https://learn.microsoft.com/en-us/dotnet/api/system.random.next?view=net-9.0) method of the [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-9.0) class, however, would not work for this case, given that it returns a signed `int`, which is **constrained** between `2,147,483,647` and `2,147,483,647`.

This eliminates **half of the range**, given that an unsigned integer unit is constrained between `0` and `4,294,967,295`.

To work around this, we can use the [NextInt64()](https://learn.microsoft.com/en-us/dotnet/api/system.random.nextint64?view=net-9.0) method instead, and constrain that.

```c#
var randomuInt = (uint)Random.Shared.NextInt64(uint.MinValue, ((long)uint.MaxValue) + 1);
Console.WriteLine(randomuInt);
```

Here we are casting the value of [uint.MaxValue](https://learn.microsoft.com/en-us/dotnet/api/system.uint32.maxvalue?view=net-9.0) to a `long`, then adding `1` to that so that the **upper bound is included**.

This will print something like this:

```plaintext
3195959763
```

### TLDR

**We can use the `Random.NextInt64` method to generate values constrained by `uint.MaxValue` to generate random unsigned integral values.**

The code is in my GitHub.

Happy hacking!
