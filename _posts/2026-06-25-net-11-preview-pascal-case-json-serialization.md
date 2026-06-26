---
layout: post
title: .NET 11 Preview - Pascal Case Json Serialization
date: 2026-06-25 13:26:48 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
    - System.Text.Json
---

When serializing [JSON](https://www.json.org/), you have some **leeway** to specify exactly how you want the property names to be serialized. This is useful in cases where you **do not control the consumer** of your output, that might be **fussy about the property naming**.

Alternatively, you might want to  adapt to the convention of the ecosystem you are integrating with. For example [Python](https://www.python.org/) generally uses [snake case](https://en.wikipedia.org/wiki/Snake_case).

We can control this using the [JsonSerializationOptions](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions?view=net-11.0-pp) class, as outlined below.

First we have our `type`:

```c#
public sealed class Person
{
	public required string FirstName { get; set; }
	public required string Surname { get; set; }
}
```

And then the code that **serializes** our type:

```c#
// Camel case
Console.WriteLine("Camel Case");
Console.WriteLine(JsonSerializer.Serialize(person, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase, WriteIndented = true }));
// Kebab case, lower	
Console.WriteLine("Kebab Case, Lower");
Console.WriteLine(JsonSerializer.Serialize(person, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.KebabCaseLower, WriteIndented = true }));
// Kebab case, upper	
Console.WriteLine("Kebab Case, Uppter");
Console.WriteLine(JsonSerializer.Serialize(person, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.KebabCaseUpper, WriteIndented = true }));
// Snake case, lower	
Console.WriteLine("Snake Case, Lower");
Console.WriteLine(JsonSerializer.Serialize(person, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower, WriteIndented = true }));
// Snake case, upper	
Console.WriteLine("Snake Case, Upper");
Console.WriteLine(JsonSerializer.Serialize(person, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseUpper, WriteIndented = true }));
// Pascal Case	
Console.WriteLine("Pascal Case");
Console.WriteLine(JsonSerializer.Serialize(person, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.PascalCase, WriteIndented = true }));

```

This will output the following:

```json
{
  "firstName": "James",
  "surname": "Bond"
}

{
  "first-name": "James",
  "surname": "Bond"
}

{
  "FIRST-NAME": "James",
  "SURNAME": "Bond"
}

{
  "first_name": "James",
  "surname": "Bond"
}

{
  "FIRST_NAME": "James",
  "SURNAME": "Bond"
}
```

Here we can see the following policies are supported:

1. [Camel Case](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy.camelcase?view=net-11.0-pp#system-text-json-jsonnamingpolicy-camelcase)
2. [Kebab Case (Upper)](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy.kebabcaseupper?view=net-11.0-pp#system-text-json-jsonnamingpolicy-kebabcaseupper)
3. [Kebab Case (Lower)](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy.kebabcaselower?view=net-11.0-pp#system-text-json-jsonnamingpolicy-kebabcaselower)
4. [Snake Case (Upper)](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy.snakecaseupper?view=net-11.0-pp#system-text-json-jsonnamingpolicy-snakecaseupper)
5. [Snake Case (Lower)](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy.pascalcase?view=net-11.0-pp#system-text-json-jsonnamingpolicy-pascalcase)

In .NET 11, there is an additional one - [PascalCase](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonnamingpolicy.pascalcase?view=net-11.0-pp#system-text-json-jsonnamingpolicy-pascalcase).

```c#
Console.WriteLine("Pascal Case");
Console.WriteLine(JsonSerializer.Serialize(person, new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.PascalCase, WriteIndented = true }));
```

This will output the following:

```c#
{
  "FirstName": "James",
  "Surname": "Bond"
}
```

### TLDR

**You can now output `JSON` properties in `PascalCase`**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-06-25%20-%20PascalSerialization).

Happy hacking!
