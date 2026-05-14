---
layout: post
title: Determining Columns To Write Using CSVHelper In C# & .NET
date: 2026-05-12 02:54:44 +0300
categories:
    - StarLibrary
    - CSVHelper
    - C#
    - .NET
---

In a previous post, "[Correctly Processing CSV Files In C# & .NET]({% post_url 2024-12-25-correctly-processing-csv-files-in-c-net %})", we looked at how to use the excellent library [CSVHelper](https://github.com/joshclose/csvhelper) to **read** and **write** collections of objects to [CSV](https://en.wikipedia.org/wiki/Comma-separated_values).

By default, **all the properties** of the object will be written.

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

Finally, we write the code that writes them to disk.

```c#
// Write to CSV
using var writer = new StreamWriter("RawSpies.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.WriteRecords(spies);
```

Our generated file will look like this:

| FirstName | LastName     | DateOfBirth | CreationDate |
| --------- | ------------ | ----------- | ------------ |
| Ernestine | Runte        | 11/9/17     | 5/14/26 3:20 |
| Angelina  | Erdman       | 1/4/07      | 5/14/26 3:20 |
| Debbie    | Lakin        | 1/3/78      | 5/14/26 3:20 |
| Pat       | Hane         | 4/14/14     | 5/14/26 3:20 |
| Betsy     | King         | 9/18/25     | 5/14/26 3:20 |
| Theodore  | Spencer      | 7/19/24     | 5/14/26 3:20 |
| Steven    | Larson       | 8/12/23     | 5/14/26 3:20 |
| Michele   | Zulauf       | 7/13/90     | 5/14/26 3:20 |
| Sophie    | Pfannerstill | 9/22/82     | 5/14/26 3:20 |
| Lola      | West         | 1/1/21      | 5/14/26 3:20 |
| Lynette   | Cassin       | 3/19/81     | 5/14/26 3:20 |
| Tomas     | Mann         | 4/7/86      | 5/14/26 3:20 |
| Kurt      | Leannon      | 2/28/94     | 5/14/26 3:20 |
| Tim       | Turner       | 1/22/00     | 5/14/26 3:20 |
| Kenneth   | Feil         | 12/9/14     | 5/14/26 3:20 |

Normally, this is enough.

But there are scenarios where you want some **changes**:

1. You want to change the **order** of the columns
2. You want to **omit** some column altogether 
3. You want to change the **headers** of the columns

For such scenarios, we make use of the `ClassMap`.

This is a **generic** class that we implement use to control our output.

We typically do something like this:

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

We then write the export code as follows:

```c#
// Write to reordered column csv
using var writer = new StreamWriter("ColumnOrderedSpies.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.Context.RegisterClassMap<SpyClassmap>();
csv.WriteRecords(spies);
```

The important bit here is the registration of the `ClassMap`.

```c#
csv.Context.RegisterClassMap<SpyClassmap>();
```

The generated CSV looks like this:

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

Note here that:

1. The column **order** is **different**
2. The last property, `CreationDate`, is **omitted**

In this manner, we can control the **output** and **order** of the properties in our `type`.

### TLDR

**The *CSVHelper* `ClassMap` can be used to configure column presence and order for CSV output.**

The code is in my GitHub.

Happy hacking!
