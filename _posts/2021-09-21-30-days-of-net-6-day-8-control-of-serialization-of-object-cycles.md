---
layout: post
title: 30 Days Of .NET 6 - Day 8 - Control Of Serialization Of Object Cycles
date: 2021-09-21 09:13:14 +0300
categories:
    - C#
    - .NET
    - 30 Days Of .NET 6
---
When dealing with complex object graphs in memory, it is common to have objects referencing themselves.

Take this example.

We have this class:

```csharp
public class Animal
{
    public string Name { get; set; }
    public byte Legs { get; set; }
    public Animal Parent { get; set; }
}
```

We can write code like this:

```csharp
var cat = new Animal() { Name = "Cat", Legs = 4 };
cat.Parent = cat;

Console.WriteLine($"This is a {cat.Name} and it's parent is {cat.Parent.Name}");
```

Here the `cat` object has a property, `Parent` that is a reference to itself - a cyclic reference. That `Parent's` `Parent` is also the same `cat`. And so on

This however is not a problem. The code will compile and run perfectly.

This code should print the following:

```plaintext
This is a Cat and it's parent is Cat
```

The problem comes when you need to serialize this object with JSON.

The JSON serializer will actually refuse to serialize this object.

You will get the following error:

```plaintext
Unhandled exception. System.Text.Json.JsonException: A possible object cycle was detectef the object depth is larger than the maximum allowed depth of 64
```

The [System.Text.Json](https://docs.microsoft.com/en-us/dotnet/api/system.text.json?view=net-6.0) serializer  allows you to handle such scenarios by passing a [JsonSerializerOptions](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions?view=net-6.0) object and setting the appropriate properties.

If you wanted to keep a reference to the object (available even in .NET 5) you would do it like this:

```csharp
var options = new JsonSerializerOptions() { ReferenceHandler = ReferenceHandler.Preserve };
var serializedString = JsonSerializer.Serialize(cat, options);

Console.WriteLine(serializedString);
```

If you look at the resulting JSON it should look like this:

```json
{"$id":"1","Name":"Cat","Legs":4,"Parent":{"$ref":"1"}}
```

The magic is happening when you set the [ReferenceHanlder.Preserve](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.serialization.referencehandler.preserve?view=net-6.0) option.

The serializer injects additional metadata so that it can be able to deserialize it correctly and maintain the hierarchy of objects. Note that even with the additional metadata, it is still valid JSON.

The addition in .NET 6 is you can also instruct the serializer to **ignore** such object cycles. 

This is done by setting the [ReferenceHanlder.IgnoreCycles](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.serialization.referencehandler.ignorecycles?view=net-6.0) property.

```csharp
options = new JsonSerializerOptions() { ReferenceHandler = ReferenceHandler.IgnoreCycles };
serializedString = JsonSerializer.Serialize(cat, options);
Console.WriteLine(serializedString);
```

This should print the following:

```json
{"Name":"Cat","Legs":4,"Parent":null}
```

Note that the parent has explicitly been set to `null`, and the rest of the properties do not have any metadata unlike before.

You can handle this even in previous versions by explicitly decorating the `Parent` object with the [JsonIgnore](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.serialization.jsonignoreattribute?view=net-5.0) attribute, like so:

```csharp
public string Name { get; set; }
public byte Legs { get; set; }
[JsonIgnore]
public Animal Parent { get; set; }
```
This attribute will instruct the serializer to skip the property altogether.

There are two issues with this approach, however:
1. You have to change your class definition
2. The property will not appear in the JSON at all, which is different from it being null.
    In other words, your output will not be this:
    ```json
    {"Name":"Cat","Legs":4,"Parent":null}
    ```
    It will be this:
    ```json
    {"Name":"Cat","Legs":4}
    ```

# Thoughts

Having the flexibility to ignore nested object cycles without having to explicitly decorate the property with a `JsonIgnore` attribute is a welcome addition.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2021-09-21%20-%2030%20Days%20Of%20.NET%206%20-%20Day%208%20-%20System.Text.Json%20Object%20Cycles)

# TLDR

`System.Text.Json` Serializer has additional flexibility. 

Setting the reference handler using the `JsonSerializationOptions` to `ReferenceHandler.IgnoreCycles` allows you to explicitly set circular object references to null

**This is Day 8 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**

Happy hacking!