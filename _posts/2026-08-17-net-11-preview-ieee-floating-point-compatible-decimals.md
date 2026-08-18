---
layout: post
title: .NET 11 Preview - IEEE Floating Point Compatible Decimals
date: 2026-08-17 20:00:42 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

If you have been programming for sometime you will know the complications that arise when using **approximate** floating point types like `float` and `double`.

You will therefore be using [decimal](https://learn.microsoft.com/en-us/dotnet/api/system.decimal?view=net-10.0) instead.

The trouble with decimal is that it is not [IEEE compatible](https://en.wikipedia.org/wiki/IEEE_754), and  the age of AI and LLMs, use of these types is increasingly **common**.

.NET 11 introduces **3** new types for this:

- `Decimal32`
- `Decimal64`
- `Decimal128`

The precision is as follows:

| Name         | Precisison | Size |
| ------------ | ---------- | ---- |
| `Decimal32`  | 7          | 32   |
| `Decimal64`  | 16         | 64   |
| `Decimal128` | 34         | 128  |

Thanks to the `IDecimalFloatingPointIeee754<TSelf>` interface, they support generic mathematical operations.

### TLDR

**.NET 11 introduces IEEE compatible decimal types - 32, 64 and 128 bit.**

Happy hacking!
