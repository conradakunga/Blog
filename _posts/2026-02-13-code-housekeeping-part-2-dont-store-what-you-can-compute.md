---
layout: post
title: Code Housekeeping - Part 2 - Don't Store What You Can Compute
date: 2026-02-13 09:02:36 +0300
categories:
    - C#
    - Languages
    - CodeHouseKeeping
    - Code
    - Quality
---

This is Part 2 of the CodeHousekeeping Series.

**Code Housekeeping** refers to general rules of thumb that make code easier to **read**, **digest**, and **modify** for other developers, **yourself** included.

Today we will look at a simple concept - **don't store what you can compute**.

Take the following `type`.

```c#
namespace ComputeDontStore.v1
{
    public record OrderEntry
    {
        public required string Name { get; init; }
        public required int Quantity { get; init; }
        public required decimal Price { get; init; }
        public required decimal TaxRate { get; init; }
        public required decimal GrossAmount { get; init; }
        public required decimal Taxes { get; init; }
        public required decimal NetAmount { get; init; 
    }
}
```

This is a simple `OrderEntry`, perhaps for use for an **order management** application.

It is used like this:

```c#
using ComputeDontStore.v1;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

var entry = new OrderEntry
{
    Name = "Chocolate Biscuits",
    Quantity = 10,
    Price = 125.40M,
    TaxRate = 0.16M,
    GrossAmount = 1_254.00M,
    Taxes = 200.64M,
    NetAmount = 1_053.36M
};

Log.Information("Entry of {Item} has gross value of {Gross:#,0.00}, taxes of {Taxes} and a Net Price of {Net:#,0.00}",
    entry.Name, entry.GrossAmount, entry.Taxes, entry.NetAmount);
```

Running this code will print the following:

```plaintext
[09:31:42 INF] Entry of Chocolate Biscuits has gross value of 1,254.00, taxes of 200.64 and a Net Price of 1,053.36
```

This code has a couple of **avoidable problems**:

1. You must compute the `GrossDiscount` directly **yourself**
2. You must compute the `Taxes` **yourself**
3. You must compute the `NetAmount` **yourself**
4. Assuming you are **persisting this to storage**, you have to **store all of these** values

There are some simple improvements that you can make to make this code more **robust**, and make the storage more **efficient**.

We can do these computations in the `type` **directly** using computed properties.

```c#
namespace ComputeDontStore.v2
{
    public record OrderEntry
    {
        public required string Name { get; init; }
        public required int Quantity { get; init; }
        public required decimal Price { get; init; }
        public required decimal TaxRate { get; init; }
        public decimal GrossAmount => Quantity * Price;
        public decimal Taxes => GrossAmount * TaxRate;
        public decimal NetAmount => GrossAmount - Taxes;
    }
}
```

Notice here that `GrossAmount`, `Taxes` and `NetAmount` are expressed purely from the other `Properties` in the `type`.

You use it like this:

```c#
var entry2 = new ComputeDontStore.v2.OrderEntry
{
    Name = "Chocolate Biscuits",
    Quantity = 10,
    Price = 125.40M,
    TaxRate = 0.16M
};

Log.Information("Entry of {Item} has gross value of {Gross:#,0.00}, taxes of {Taxes} and a Net Price of {Net:#,0.00}",
    entry.Name, entry.GrossAmount, entry.Taxes, entry.NetAmount);
```

Notice here we are no longer providing `GrossAmount`, `Taxes` and `NetAmount` ourselves - they are computed automatically by our `type`.

This yields a number of benefits:

1. **Less code**
2. **Eliminate the opportunity** to provide invalid `GrossAmount`, `Taxes` and `NetAmount`
3. Code that is **easier to test**
4. Code that is **easer to maintain**
5. Code that is **easier to understand** - you can **read** exactly how each of those properties is arrived at.
6. If you are persisting this to storage, you are **persisting less** - now only `4` columns instead of `7`

### TLDR

**Don't store what you can compute. And don't compute what your code can compute for you.**

The code is in my GitHub.

Happy hacking!
