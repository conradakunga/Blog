---
layout: post
title: Formatting Columns Using CSVHelper In C# & .NET
date: 2026-05-13 03:32:36 +0300
categories:
    - StarLibrary
    - CSVHelper
    - C#
    - .NET
---

In our previous post, "[Determining Columns and Order To Write Using CSVHelper In C# & .NET]({% post_url 2026-05-12-determining-columns-and-order-to-write-using-csvhelper-in-c-net %})", we looked at how to control the **columns** and their **order** when outputting **CSV** files using the [CSVHelper](https://github.com/joshclose/csvhelper) library.

In this post, we will look at another common problem - **formatting** of data.

Let us take our usual example `type`, the `Spy`.

```c#
public sealed record Spy
{
  public required string FirstName { get; init; }
  public required string LastName { get; init; }
  public DateOnly DateOfBirth { get; init; }
  public DateTime CreationDate { get; init; }
}
```

In our project we need to install the following packages:

1. [Bogus](https://github.com/bchavez/Bogus)
2. [CSVHelper](https://github.com/joshclose/csvhelper)

```bash
dotnet add package Bogus
dotnet add package CSVHelper
```

We then write code to generate `15` `Spy` objects.

```c#
// Create and configure faker
var faker = new Faker<Spy>()
  .RuleFor(spy => spy.FirstName, faker => faker.Person.FirstName)
  .RuleFor(spy => spy.LastName, faker => faker.Person.LastName)
  .RuleFor(spy => spy.DateOfBirth, faker => DateOnly.FromDateTime(faker.Date.Past(50)))
  .RuleFor(spy => spy.CreationDate, DateTime.Now)
  // This is to make the generated spies static
  .UseSeed(0);

// Generate spies
var spies = faker.Generate(15);
```

We then use the code from the last example to generate a CSV.

First, our `ClassMap`:

```c#
using CsvHelper.Configuration;

public sealed class SpyClassmap : ClassMap<Spy>
{
  public SpyClassmap()
  {
    Map(m => m.LastName).Name("Last Name");
    Map(m => m.FirstName).Name("First Name");
    Map(m => m.DateOfBirth).Name("Date Of Birth");
  }
}
```

Then the export code:

```c#
// Write to reordered column csv
using var writer = new StreamWriter("ColumnOrderedSpies.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.Context.RegisterClassMap<SpyClassmap>();
csv.WriteRecords(spies);
```

This generates the following:

| Last Name    | First Name | Date Of Birth |
| ------------ | ---------- | ------------- |
| Runte        | Ernestine  | 11/9/17       |
| Erdman       | Angelina   | 1/4/07        |
| Lakin        | Debbie     | 1/3/78        |
| Hane         | Pat        | 4/14/14       |
| King         | Betsy      | 9/18/25       |
| Spencer      | Theodore   | 7/19/24       |
| Larson       | Steven     | 8/12/23       |
| Zulauf       | Michele    | 7/13/90       |
| Pfannerstill | Sophie     | 9/22/82       |
| West         | Lola       | 1/1/21        |
| Cassin       | Lynette    | 3/19/81       |
| Mann         | Tomas      | 4/7/86        |
| Leannon      | Kurt       | 2/28/94       |
| Turner       | Tim        | 1/22/00       |
| Feil         | Kenneth    | 12/9/14       |

So far so good.

However, the problem of [cultures and internationalization](https://mattjameschampion.com/2024/09/27/a-primer-on-cultureinfo-and-internationalisation-in-c-net/) raises its ugly head.

Take this row:

| Last Name | First Name | Date Of Birth |
| --------- | ---------- | ------------- |
| Erdman    | Angelina   | 1/4/07        |

Is Anglina's birthday on 1<sup>st</sup> April or 4<sup>th</sup> January

There are a number of solutions to this problem.

The first is to solve it at the `class` level to **compute** a **formatted** column, and then use that in the `ClassMap`.

```c#
public sealed record Spy
{
  public required string FirstName { get; init; }
  public required string LastName { get; init; }
  public DateOnly DateOfBirth { get; init; }
  public string FormattedDateOfBirth => DateOfBirth.ToString("d MMM yyyy");
  public DateTime CreationDate { get; init; }
}
```

The magic here is our new **computed** column:

```c#
 public string FormattedDateOfBirth => DateOfBirth.ToString("d MMM M yyyy");
```

We then update our `ClassMap` to use **this** column, rather than the actual `DateOfBirth`.

```c#
public sealed class SpyClassmap : ClassMap<Spy>
{
  public SpyClassmap()
  {
    Map(m => m.LastName).Name("Last Name");
    Map(m => m.FirstName).Name("First Name");
    Map(m => m.FormattedDateOfBirth).Name("Date Of Birth");
  }
}
```

Our generated CSV looks like this:

| Last Name    | First Name | Date Of Birth  |
| ------------ | ---------- | -------------- |
| Runte | Ernestine | 10 Nov 2017 |
| Erdman | Angelina | 4 Jan 2007 |
| Lakin | Debbie | 3 Jan 1978 |
| Hane | Pat | 14 Apr 2014 |
| King | Betsy | 18 Sep 2025 |
| Spencer | Theodore | 19 Jul 2024 |
| Larson | Steven | 12 Aug 2023 |
| Zulauf | Michele | 13 Jul 1990 |
| Pfannerstill | Sophie | 22 Sep 1982 |
| West | Lola | 1 Jan 2021 |
| Cassin | Lynette | 19 Mar 1981 |
| Mann | Tomas | 7 Apr 1986 |
| Leannon | Kurt | 28 Feb 1994 |
| Turner | Tim | 22 Jan 2000 |
| Feil | Kenneth | 9 Dec 2014 |


We can see here that our `DateOfBirth` is now formatted **unambiguously**.

There are a number of **problems** with this approach:

1. More code
2. **Changing our `type`** to address **presentation** concerns is neither **clean** nor **flexible**.

A better approach is to solve this problem in the `ClassMap` itself.

You can do it as follows:

```c#
public sealed class SpyClassmap : ClassMap<Spy>
{
  public SpyClassmap()
  {
    Map(m => m.LastName).Name("Last Name");
    Map(m => m.FirstName).Name("First Name");
    Map(m => m.DateOfBirth).Name("Date Of Birth").TypeConverterOption.Format("d MMM yyyy");
  }
}
```

The magic is taking place here, where the `TypeConverterOption` is used to set the format.

The generated file looks like this:

| Last Name    | First Name | Date Of Birth |
| ------------ | ---------- | ------------- |
| Runte | Ernestine | 10 Nov 2017 |
| Erdman | Angelina | 4 Jan 2007 |
| Lakin | Debbie | 3 Jan 1978 |
| Hane | Pat | 14 Apr 2014 |
| King | Betsy | 18 Sep 2025 |
| Spencer | Theodore | 19 Jul 2024 |
| Larson | Steven | 12 Aug 2023 |
| Zulauf | Michele | 13 Jul 1990 |
| Pfannerstill | Sophie | 22 Sep 1982 |
| West | Lola | 1 Jan 2021 |
| Cassin | Lynette | 19 Mar 1981 |
| Mann | Tomas | 7 Apr 1986 |
| Leannon | Kurt | 28 Feb 1994 |
| Turner | Tim | 22 Jan 2000 |
| Feil | Kenneth | 9 Dec 2014 |

This is much **cleaner**, avoids **polluting** the `type` itself, and affords you a lot of **flexibility** in the output formatting, for example, if you want different formats for different **scenarios**.

### TLDR

**You can control the format of CSVExport columns using a `TypeConverterOption`**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-05-13%20-%20CSVExportFormat).

Happy hacking!
