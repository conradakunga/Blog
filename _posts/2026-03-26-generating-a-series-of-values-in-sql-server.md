---
layout: post
title: Generating A Series Of Values In SQL Server
date: 2026-03-26 09:40:52 +0300
categories:
    - SQL Server
    - Database
---

One of the more powerful features of [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) is the ability to generate **sequences** of values.

To get a list of number from 1 to 10, we do it like so:

```c#
var numbers = Enumerable.Range(1, 10).ToList();
numbers.ForEach(Console.WriteLine);
```

To get a list of all even number from `1` to `10`, we do it like this:

```c#
var evenNumbers = Enumerable.Range(1, 10).Where(x => x % 2 == 0).ToList();
evenNumbers.ForEach(Console.WriteLine);
```

To get a list of all odd number from `1` to `10`, we do it like this:

```c#
var oddNumbers = Enumerable.Range(1, 10).Where(x => x % 2 != 0).ToList();
oddNumbers.ForEach(Console.WriteLine);
```

You might wonder if it was possible to generate smaller increments, like `0.0` to `1.0` in steps of `.05`.

It is.

```c#
var smallNumbers = Enumerable.Range(0, 20).Select(x => x / 20.0).ToList();
smallNumbers.ForEach(Console.WriteLine);
```

Do you wish there was something similar in [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server)?

There is!

You can use the [generate_series](https://learn.microsoft.com/en-us/sql/t-sql/functions/generate-series-transact-sql?view=sql-server-ver17) function for such purposes. This has been available from SQL server 2022.

It takes three parameters:

1. **Start**
2. **Stop**
3. An optional **step**, which defaults to `1`

The scenarios above would this be as follows:

```sql
-- 1 to 10
select value
from generate_series(1, 10)
-- odd numbers
select value
from generate_series(0, 10, 2)
-- even numbers
select value
from generate_series(1, 10, 2)
-- 0.0 to 1.0 in steps of .05
select value
from generate_series(0.0, 1.0, 0.05)
```

The results are as we'd expect.

![oneToTen](../images/2026/03/oneToTen.png)

![oddNumbers](../images/2026/03/oddNumbers.png)

![evenNumbers](../images/2026/03/evenNumbers.png)

![smallIncrements](../images/2026/03/smallIncrements.png)

You can also use **negative** values for **start**, **end** and **step**, and this function is available for all the **precise** numeric types - **tinyint**, **smallint**, **int**, **bigint**, and **decimal**

### TLDR

**You can generate any series of numbers in SQL Server using the `generate_series` function.**

The code is my GitHub.

Happy hacking!
