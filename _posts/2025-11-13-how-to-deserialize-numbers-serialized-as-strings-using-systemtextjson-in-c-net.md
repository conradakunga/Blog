---
layout: post
title: How To Deserialize Numbers Serialized As Strings Using System.Text.Json In C# & .NET
date: 2025-11-13 00:29:26 +0300
categories:
    - C#
    - .NET
    - Json
---

Encoding and decoding of `Json` is largely a **transparent** task, regardless of the serialization library you use - typically (and recommended!) [System.Text.Json](https://learn.microsoft.com/en-us/dotnet/api/system.text.json?view=net-9.0).

For example, assume you have the following `Person` type:

```c#
public sealed class Person
{
  public string Name { get; set; }
  public byte Age { get; set; }
}
```

If we wanted to serialize this, we would do it like so:

```c#
var person = new Person { Name = "James Bond", Age = 40 };
// Configure options for serialization
var options = new JsonSerializerOptions
{
	WriteIndented = true
};
// Serialize
var json = JsonSerializer.Serialize(person, options);
// Print to console
Console.WriteLine(json);
```

This would print the following:

```json
{
  "Name": "James Bond",
  "Age": 40
}
```

Note here that the `Age`, an `integer`, is printed as a native number, `40`.

All straightforward enough.

Sometimes, however, you are the **consumer** of `Json` that you **did not encode**.

Generally, it will look like what we printed above.

However, there are times the `Json` is encoded like this:

```json
{
  "Name": "James Bond",
  "Age": "40"
}
```

Here, the **number** is encoded as a `string`.

We can try and deserialize this like so:

```c#
var apiJson =
"""
{
  "Name": "James Bond",
  "Age": "40"
}
""";
// Deserialize to an object
person = JsonSerializer.Deserialize<Person>(apiJson);
```

This code, unfortunately, will **throw an exception**:

```plaintext
The JSON value could not be converted to System.Byte. Path: $.Age | LineNumber: 2 | BytePositionInLine: 14.
```

This is because by default, `System.Text.Json` will **make no attempt to figure out** that the number is encoded as a `string`.

You will have to **explicitly** tell it to do that, using [JsonSerializerOptions](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions?view=net-9.0), like so:

```c#
var apiJson =
"""
{
  "Name": "James Bond",
  "Age": "40"
}
""";
// Configure options for deserialization
var serializationOptions = new JsonSerializerOptions
{
	NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.AllowReadingFromString
};
// Deserialize to an object
person = JsonSerializer.Deserialize<Person>(apiJson, serializationOptions);
```

We are setting the [NumberHandling](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions.numberhandling?view=net-9.0#system-text-json-jsonserializeroptions-numberhandling) property to `AllowReadingFromString`.

This will print the following:

```plaintext
James Bond is 40 years old
```

### TLDR

**We can read numbers encoded as strings in `Json` using `JsonSerializerOptions` with `NumberHandling` set to `JsonNumberHandling.AllowReadingFromString`** 

The code is in my GitHub.

Happy hacking!
