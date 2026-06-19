---
layout: post
title: Passing Parameters To CSVHelper ClassMap
date: 2026-06-18 23:33:02 +0300
categories:
    - StarLibrary
    - CSVHelper
    - C#
    - .NET
---

Over the years, I have discussed how to use the excellent [CSVHelper](https://github.com/joshclose/csvhelper) library for reading and writing [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) files.

We have also looked at how to **control the columns and formatting** of the data, as discussed in the post "[Formatting Columns Using CSVHelper In C# & .NET]({% post_url 2026-05-13-formatting-columns-using-csvhelper-in-c-net %})".

Recently, I encountered a situation where I wondered whether it was possible to use **conditional logic** in the `ClassMap`.

Let us take this example, where we have the following `Person` type:

```c#
public sealed record Person
{
    public required string FirstName { get; init; }
    public required string LastName { get; init; }
    public required Gender Gender { get; init; }
}
```

`Gender` is defined thus:

```c#
public enum Gender
{
    Male,
    Female
}
```

Using the [Bogus](https://github.com/bchavez/Bogus) library, we generate 20 people.

```c#
var faker = new Faker<Person>()
    .RuleFor(person => person.Gender, faker => faker.PickRandom<Gender>())
    .RuleFor(person => person.FirstName,
        (faker, person) => faker.Name.FirstName(person.Gender == Gender.Male
            ? Bogus.DataSets.Name.Gender.Male
            : Bogus.DataSets.Name.Gender.Female))
    .RuleFor(person => person.LastName, faker => faker.Name.LastName())
    .UseSeed(0);
```

Of interest is this code:

```c#
 .RuleFor(person => person.FirstName,
        (faker, person) => faker.Name.FirstName(person.Gender == Gender.Male
            ? Bogus.DataSets.Name.Gender.Male
            : Bogus.DataSets.Name.Gender.Female))
```

This is conditional logic to ensure that `Bogus` generates **names appropriate to the gender**, avoiding the scenario where **Jane** is used for a **Male** `Person`.

We then write them to a [CSV](https://en.wikipedia.org/wiki/Comma-separated_values), using the `CSVHelper` package.

First, the `ClassMap`:

```c#
using CsvHelper.Configuration;

public sealed class PersonClassMap : ClassMap<Person>
{
    public PersonClassMap()
    {
        Map(m => m.LastName).Name("Last Name");
        Map(m => m.FirstName).Name("First Name");
        Map(m => m.Gender).Name("Gender");
    }
}
```

Then, the code to write the `CSV`.

`````c#
// Write csv
using var writer = new StreamWriter("People.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.Context.RegisterClassMap<SpyClassmap>();
csv.WriteRecords(people);
`````

The file will look like this:

| Last Name  | First Name | Gender |
| ---------- | ---------- | ------ |
| Runte      | Ernestine  | Female |
| Macejkovic | Rita       | Female |
| Wolff      | Delores    | Female |
| Koss       | Marcus     | Male   |
| Wunsch     | Jackie     | Female |
| Ziemann    | Jody       | Male   |
| Schumm     | Veronica   | Female |
| Bartoletti | Tabitha    | Female |
| Watsica    | Gwendolyn  | Female |
| Bode       | Naomi      | Female |
| Gulgowski  | Adrian     | Male   |
| Ruecker    | Sandy      | Female |
| Heathcote  | Ricardo    | Male   |
| Rau        | Terry      | Female |
| Upton      | Ricky      | Male   |
| Koch       | Erica      | Female |
| Jast       | Rodney     | Male   |
| Kuhlman    | Ada        | Female |
| Shanahan   | Caleb      | Male   |
| Parisian   | Betsy      | Female |

Suppose we wanted to generate **TWO** `CSV` files, with the following rules:

1. Each file contains **only** `Male` or `Female` persons
2. The `FirstName` for each file should have a header of `MaleFirstName` or `FemaleFirstName`, as appropriate.

An easy way to do it is to have two different `ClassMaps`.

For the **Male** CSV:

```c#
public sealed class MaleClassMap : ClassMap<Person>
{
    public SpyClassmap()
    {
        Map(m => m.LastName).Name("Last Name");
        Map(m => m.FirstName).Name("Male First Name");
        Map(m => m.Gender).Name("Gender");
    }
}
```

And the **Female** CSV:

```c#
public sealed class FemaleClassMap : ClassMap<Person>
{
    public SpyClassmap()
    {
        Map(m => m.LastName).Name("Last Name");
        Map(m => m.FirstName).Name("Female First Name");
        Map(m => m.Gender).Name("Gender");
    }
}
```

Can we avoid **duplicating** this code?

**We can.**

We can write a `SmartClassMap` that takes `Gender` as a [constructor](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/constructors) parameter.

```c#
public sealed class SmartPersonClassMap : ClassMap<Person>
{
    public SmartPersonClassMap(Gender gender)
    {
        Map(m => m.LastName).Name("Last Name");
        Map(m => m.FirstName).Name(gender == Gender.Male ? "Male First Name" : "Female First Name");
        Map(m => m.Gender).Name("Gender");
    }
}
```

Then we write our code to **split** the `Persons`.

First, the `Male`.

```c#
var males = people.Where(person => person.Gender == Gender.Male);
using var writer = new StreamWriter("Male.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.Context.RegisterClassMap(new SmartPersonClassMap(Gender.Male));
csv.WriteRecords(males);
```

Next, the `Female`.

```c#
var females = people.Where(person => person.Gender == Gender.Female);
using var writer = new StreamWriter("Female.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.Context.RegisterClassMap(new SmartPersonClassMap(Gender.Female));
csv.WriteRecords(females);
```

Our files look like this:

| **Last Name** | **Male First Name** | **Gender** |
| ------------- | ------------------- | ---------- |
| **Koss**      | Marcus              | Male       |
| **Ziemann**   | Jody                | Male       |
| **Gulgowski** | Adrian              | Male       |
| **Heathcote** | Ricardo             | Male       |
| **Upton**     | Ricky               | Male       |
| **Jast**      | Rodney              | Male       |
| **Shanahan**  | Caleb               | Male       |

And:

| **Last Name**  | **Female First Name** | **Gender** |
| -------------- | --------------------- | ---------- |
| **Runte**      | Ernestine             | Female     |
| **Macejkovic** | Rita                  | Female     |
| **Wolff**      | Delores               | Female     |
| **Wunsch**     | Jackie                | Female     |
| **Schumm**     | Veronica              | Female     |
| **Bartoletti** | Tabitha               | Female     |
| **Watsica**    | Gwendolyn             | Female     |
| **Bode**       | Naomi                 | Female     |
| **Ruecker**    | Sandy                 | Female     |
| **Rau**        | Terry                 | Female     |
| **Koch**       | Erica                 | Female     |
| **Kuhlman**    | Ada                   | Female     |
| **Parisian**   | Betsy                 | Female     |

### TLDR

**You can pass values to a `CSVHelper` `ClassMap` constructor to conditionally control logic.**

The code is in my GitHub.

Happy hacking!
