---
layout: post
title: Changing the CSV Delimiter with CSVHelper
date: 2026-09-12 14:04:29 +0300
categories:
    - C#
    - .NET
---

I have, in the past, talked about the excellent [CSVHelper](https://joshclose.github.io/CsvHelper/) library by [Josh Close](https://github.com/JoshClose).

This is my go-to for reading and writing [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) files.

The default separator for a `CSV`, as the name implies, is the **comma**, '`,`'.

But you can change it to **anything** depending on your use cases.

Assume you have the following `type`, the `Spy`:

```c#
public sealed class Spy
{
  public required string Firstname { get; init; }
  public required string Lastname { get; init; }
  public required DateOnly DateOfBirth { get; init; }
}
```

We can generate a bunch of `Spy` objects using the [Bogus](https://github.com/bchavez/bogus) library.

```c#
var faker = new Faker<Spy>()
  .RuleFor(x => x.Firstname, f => f.Name.FirstName())
  .RuleFor(x => x.Lastname, f => f.Name.LastName())
  .RuleFor(x => x.DateOfBirth, f => f.Date.PastDateOnly(50));

var spies = faker.Generate(10);
```

To output them to a `CSV`, we would do it this way:

```c#
var config = new CsvConfiguration(CultureInfo.InvariantCulture)
{
};
using (var writer = new StreamWriter("spies.csv"))
{
    using (var csv = new CsvWriter(writer, config))
    {
        csv.WriteRecords(spies);
    }
}
```

This will generate the following:

```plaintext
Firstname,Lastname,DateOfBirth
Vergie,Nolan,12/29/2020
Claud,Bartell,03/01/1991
Louisa,Frami,11/21/2009
Minerva,Corkery,09/13/2016
Albina,Ullrich,01/09/1977
Damaris,Carroll,08/30/2011
Tatyana,Grant,06/02/2008
Brook,Halvorson,03/26/2015
Veda,Breitenberg,05/04/1983
Antonina,Kunze,05/26/1980
```

If you wanted to **change the delimiter**, you would do it as follows:

```c#
// Configure the generation
var config = new CsvConfiguration(CultureInfo.InvariantCulture)
{
    // Set our delimiter
    Delimiter = "|"
};
// Write to file
using (var writer = new StreamWriter("spies.csv"))
{
    using (var csv = new CsvWriter(writer, config))
    {
        csv.WriteRecords(spies);
    }
}
```

This would generate the following:

```plaintext
Firstname|Lastname|DateOfBirth
Avery|Will|05/01/1980
Alfredo|Windler|01/11/1980
Russel|Jerde|10/30/2016
Kyle|Nolan|10/15/1977
Sofia|Schiller|02/03/1981
Johnpaul|Boehm|11/20/1997
Skylar|Schuppe|11/08/2023
Amari|Reilly|08/15/2024
Serena|Langworth|01/02/1991
Norbert|Keebler|01/23/1979

```

### TLDR

**When using `CSVHelper`, You can change the separator for a `CSV` by setting the `Delimiter` property for the `CsvConfiguration`**

The code is in my GitHub.

Happy hacking!
