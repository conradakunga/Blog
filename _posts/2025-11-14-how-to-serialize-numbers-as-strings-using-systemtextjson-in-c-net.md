---
layout: post
title: How To Serialize Numbers As Strings Using System.Text.Json In C# & .NET
date: 2025-11-14 01:15:48 +0300
categories:
    - C#
    - .NET
    - Json
---

Yesterday's post, "[How To Deserialize Numbers Serialized As Strings Using System.Text.Json In C# & .NET]({% post_url 2025-11-13-how-to-deserialize-numbers-serialized-as-strings-using-systemtextjson-in-c-net %})", looked at a possible scenario of how to **deserialize** numbers encoded as `strings`, in situations where y**ou are not in control** of your `Json` input.

In this post, we will look at the **opposite** problem - how to produce `Json` **compatible with a consumer beyond your control**, that expects numbers to be encoded as `strings`.

The example type will be the Person:

```c#
public sealed class Person
{
  public string Name { get; set; }
  public byte Age { get; set; }
}
```

To serialize this with the numbers encoded as strings, we will use the [JsonSerializerOptions](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions?view=net-9.0) class and set the `NumberHandling` as appropriate.

```c#
using System.Text.Json;

var person = new Person { Name = "James Bond", Age = 40 };
// Configure options for serialization
var options = new JsonSerializerOptions
{
  WriteIndented = true,
  NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.WriteAsString
};
// Serialize
var json = JsonSerializer.Serialize(person, options);
// Print to console
Console.WriteLine(json);
```

Here we are setting the `WriteAsString` option to instruct the serializer to output the number as a `string`.

If we run this code, it will print the following:

```json
{
  "Name": "James Bond",
  "Age": "40"
}
```

Here, the number is encoded as a `string`, as we expect.

### TLDR

**We can serialize numbers as strings in `Json` by setting the `NumberHandling` property of an instance of the `JsonSerializerOptions` to `System.Text.Json.Serialization.JsonNumberHandling.WriteAsString`**

The code is in my GitHub.

Happy hacking!
