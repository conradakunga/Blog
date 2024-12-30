---
layout: post
title: Correctly Processing CSV Files In C# & .NET
date: 2024-12-25 08:33:35 +0300
categories:
    - C#
    - .NET
    - StarLibrary
---

One of the most popular formats for data interchange is the comma-separated-value, the [CSV](https://en.wikipedia.org/wiki/Comma-separated_values). In this format, data is delimited as follows:

- Columns with the comma, `,`
- Rows with the [new line](https://en.wikipedia.org/wiki/Newline)

Let us take an example.

Suppose we have this data in a file:

```plaintext
Name,Age,Service
James Bond (007),50,MI-6
Vesper Lynd,35,MI-6
Q,30,MI-6
Ethan Hunt,45,IMF
Luther Stickell,48,IMF
Benji Dunn,36,IMF
Jason Bourne,55,CIA
Harry Pearce,60,MI-5
Adam Carter,40,MI-5
Ros Myers,37,MI-5
```

And we have this type:

```csharp
public record Spy
{
  public required string Name { get; init; }
  public required int Age { get; init; }
  public required string Service { get; init; }
}
```

We could populate a collection as follows:

```csharp
var data = File.ReadAllText("Data.csv")
// Create  collection - a list of spies
List<Spy> spies = new();
// Split the data into an array of rows, using the newline
var rows = data.Split(Environment.NewLine);
// Skip the first row, as it is a header
foreach (var line in rows.Skip(1))
{
  // Split each row into an array of columbs by comma
  var columns = line.Split(",");
  // Using the columns, create a spy
  spies.Add(new Spy(columns[0], Convert.ToInt32(columns[1]), columns[2]));
}
```

This looks like a very simple problem to solve generally - parse and split by `newline` and `,`

Only that it will break down almost immediately as soon as the data gets complicated.

The following is a valid CSV row for the above data

```plaintext
"Salt,Evelyn",35,MI-6
```

Note that this data has three commas, unlike two in all the other rows. `Salt, Evelyn` is the entirety of the name.

The parsing code will, therefore, think `Evelyn` is the second column, whereas it is in fact, part of the first, and will throw an exception:

```plaintext
Unhandled exception. System.FormatException: The input string 'Evelyn"' was not in a correct format.
   at System.Number.ThrowFormatException[TChar](ReadOnlySpan`1 value)
   at System.Convert.ToInt32(String value)
   at Program.<Main>$(String[] args) in /Users/rad/Projects/Temp/TestConsole/Program.cs:line 26
```

This is because a comma is a column separator, **unless it is within double quotes**.

It is also possible to have a column value have a new line validly **within**, for example a physical or postal address.

As a matter of fact, the CSV specification is surprisingly complicated. You can read all the details in the standard [RFC 4180](https://www.ietf.org/rfc/rfc4180.txt)

So, how do we deal with this without writing increasingly complicated code? We use a library like the excellent [CSV Helper](https://www.nuget.org/packages/CsvHelper)

First, install the package

```bash
dotnet add package CsvHelper
```

We then change the code as follows:

```csharp
// Create a reader
using var reader = new StreamReader("Data.csv");
using var csv = new CsvReader(reader, CultureInfo.InvariantCulture);
// Create an IEnumerable of Spy
var allSpies = csv.GetRecords<Spy>();
// Actually read the spy from file and process
foreach (var spy in allSpies)
{
  Console.WriteLine($"Name {spy.Name}, Age {spy.Age}, Service {spy.Service}");
}
```

This will print the following:

```plaintext
Name James Bond (007), Age 50, Service MI-6
Name Salt,Evelyn, Age 35, Service MI-6
Name Vesper Lynd, Age 35, Service MI-6
Name Q, Age 30, Service MI-6
Name Ethan Hunt, Age 45, Service IMF
Name Luther Stickell, Age 48, Service IMF
Name Benji Dunn, Age 36, Service IMF
Name Jason Bourne, Age 55, Service CIA
Name Harry Pearce, Age 60, Service MI-5
Name Adam Carter, Age 40, Service MI-5
Name Ros Myers, Age 37, Service MI-5
```

Note that `Salt,Evelyn` has been correctly processed.

The following are important things to note:

- The parser correctly detected that our CSV has a header and went on to use those to determine the property names and values. So long as the header names and properties match, the parser will do the right thing, regardless of order. **They must match exactly, including the case**!
- When you call `GetRecords<Spy>,` you get back an [IEnumerable<<Spy>>](https://learn.microsoft.com/en-us/dotnet/api/system.collections.ienumerable?view=net-9.0) and not an actual collection of `Spy`. This means you will have to iterate through it to load the data. Thus, in our code, we only actually load a `Spy` as we iterate through the loop. Alternatively, you can force loading of all `Spy` data by doing `csv.GetRecords<Spy>().ToArray()` or `csv.GetRecords<Spy>().ToList()`. You probably want to retain the  `IEnumerable<Spy>` approach, though, because if you have a very large file to import, reading them all at once can strain your memory, disk and processor.

You have a couple of options if the header columns do not match the property names.

If the target type is in your control (i.e., you can access and modify its source code), you can provide attributes to assist with the mapping.

So, if we have this CSV:

```plaintext
FullNames,CurrentAge,Agency
James Bond (007),50,MI-6
"Salt,Evelyn",35,MI-6
Vesper Lynd,35,MI-6
Q,30,MI-6
Ethan Hunt,45,IMF
Luther Stickell,48,IMF
Benji Dunn,36,IMF
Jason Bourne,55,CIA
Harry Pearce,60,MI-5
Adam Carter,40,MI-5
Ros Myers,37,MI-5
```

We update our type as follows:

```csharp
record Spy
{
  [Name("FullNames")]
  public required string Name { get; init; }
  [Name("CurrentAge")]
  public required int Age { get; init; }
  [Name("Agency")]
  public required string Service { get; init; }
}
```

If you do not have access to the type, you can achieve this by implementing a [ClassMap](https://joshclose.github.io/CsvHelper/examples/configuration/class-maps/). With the `ClassMap`, we map the properties to the field names.

```csharp
public class SpyMap : ClassMap<Spy>
{
  public SpyMap()
  {
    Map(m => m.Name).Name("FullNames");
    Map(m => m.Age).Name("CurrentAge");
    Map(m => m.Service).Name("Agency");
  }
}
```

We then register the `ClassMap` with the parser and then execute the parsing.

```csharp
// Create a reader
using var reader = new StreamReader("Data2.csv");
// Create a csv reader
using var csv = new CsvReader(reader, CultureInfo.InvariantCulture);
// Register our classmap
csv.Context.RegisterClassMap<SpyMap>();
// Create an IEnumerable of Spy
var allSpies = csv.GetRecords<Spy>();
// Actually read the spy from file and process
foreach (var spy in allSpies)
{
  Console.WriteLine($"Name {spy.Name}, Age {spy.Age}, Service {spy.Service}");
}
```

I prefer the `ClassMap` to the attributes approach, as it is cleaner and more flexible.

It is also possible that your CSV will **not have a header row at all**.

In this case, you need to do two things:

1. Tell the parser that there is no header 
2. Provide a `ClassMap`

To tell the parser there is no header, configure it as follows:

```csharp
 // Create a configuration
var config = new CsvConfiguration(CultureInfo.InvariantCulture)
{
  HasHeaderRecord = false,
};
// Create a reader
using var reader = new StreamReader("Data3.csv");
// Create a csv reader, passing the configuration
using var csv = new CsvReader(reader, config);
// Register our classmap
csv.Context.RegisterClassMap<SpyMap>();
// Create an IEnumerable of Spy
var allSpies = csv.GetRecords<Spy>();
// Actually read the spy from file and process
foreach (var spy in allSpies)
{
  Console.WriteLine($"Name {spy.Name}, Age {spy.Age}, Service {spy.Service}");
}
```

There are a lot of other things that you can configure for parsing in the `CsvConfiguration`, and the main ones you'd probably find of interest are:

 - **Delimiter** - the delimter to use. The default is specific to the culture in use. (In English, this is usually the comma). But you can specify it to be a tab `\t` instead if the case arises.
- **DetectDelimiter** - whether to detect the delimiter.
- **IgnoreBlankLines** - What to do with blank lines in the data.
- **NewLine** - The new line for use in writing CSVs. For reading, the parser is smart enough to handle the three - `\n`, `\r`, `\r\n`

Writing CSVs is almost exactly the opposite of reading them. Only instead of a `CSVReader`, we use a `CSVWriter`.

If you have a collection of objects and want to write them to CSV, do so as follows:

```csharp
using var writer = new StreamWriter("Output.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.WriteRecords(spies);
```

If you want to write the data **without** a header, you can configure the writer to skip the header.

```csharp
List<Spy> spies =
  [
      new Spy { Name = "James Bond", Age = 50, Service = "MI-6" },
      new Spy { Name = "Vesper Lynd", Age = 35, Service = "MI-6" }
  ];
var config = new CsvConfiguration(CultureInfo.InvariantCulture)
{
	HasHeaderRecord = false
};
using var writer = new StreamWriter("OutputNoHeader.csv");
using var csv = new CsvWriter(writer, config);
csv.WriteRecords(spies);
```

You can also configure the **column names** when writing to a file. This is also done using the `ClassMap`.

```csharp
List<Spy> spies =
  [
    new Spy { Name = "James Bond", Age = 50, Service = "MI-6" },
    new Spy { Name = "Vesper Lynd", Age = 35, Service = "MI-6" }
  ];
using var writer = new StreamWriter("OutputNamedHeader.csv");
using var csv = new CsvWriter(writer, CultureInfo.InvariantCulture);
csv.Context.RegisterClassMap<SpyMap>();
csv.WriteRecords(spies);
```

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2024-12-25%20-%20Processing%20CSV%20Files)

Happy hacking!