---
layout: post
title: Making JSON Deserialization Case Insensitive in C# & .NET
date: 2025-12-12 00:22:51 +0300
categories:
    - C#
    - .NET
    - JSON.NET
---

The native .NET JSON serialization & deserialization library, System.Text.Json, by default operates in a case-insensitive fashion.

Assume we have the following type:

```c#
public sealed class Person
{
  public string Firstname { get; set; }
  public string Surname { get; set; }
}
```

Assume we also have the following `JSON`.

```json
{
  "FirstName": "James",
  "Surname": "Bond"
}
```

We can deserialize the `JSON` into a class as follows:

```c#
var json =
	"""
	{
	  "FirstName": "James",
	  "Surname": "Bond"
	}
	""";
var person = JsonSerializer.Deserialize<Person>(json);
Console.WriteLine($"FirstName: {person.Firstname}; Surname {person.Surname}");
```

If we run this code, it will print the following:

```plaintext
FirstName: James; Surname Bond
```

If, however, we change the JSON to be like this:

```json
{
  "firstName": "James",
  "Surname": "Bond"
}
```

Here I have changed the key from `FirstName` to `firstName`.

The code prints the following:

```plaintext
FirstName: ; Surname Bond
```

We can see here that it has **failed to deserialize** the first name.

This is a **GOOD THING**. I would rather be **explicit** about what I want than rely on the **deserializer to figure out** what to do.

There are two solutions to this problem.

## Annotate the property

If you have access to or otherwise control the type, simply add the [JsonPropertyName](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.serialization.jsonpropertynameattribute?view=net-10.0) attribute to the **property** that is **problematic**.

```c#
public sealed class Person
{
	[JsonPropertyName("firstName")]
	public string Firstname { get; set; }
	public string Surname { get; set; }
}
```

This will now deserialize correctly.

## Make the property case-insensitive

A more flexible way, if you are a **consumer** from **multiple producers**, and each of them cases the property **differently**, a better option is to ignore the case altogether.

We achieve this using the `JsonSerializerOptions` class.

We set it up as follows:

```c#
var options = new JsonSerializerOptions()
	{
		PropertyNameCaseInsensitive = true
	};
var person = JsonSerializer.Deserialize<Person>(json);
Console.WriteLine($"FirstName: {person.Firstname}; Surname {person.Surname}");
```

This will now work for `firstname`, `firstName`, `FirstName`, `FIRSTNAME`, etc.

### TLDR

**You can control JSON deserialization to ignore case using the `JsonSerializerOptions` class.**

Happy hacking!
