---
layout: post
title: Pretty Printing Unformatted Json In C#
date: 2024-11-24 18:25:43 +0300
categories:
    - C#
    - .NET
---

Occasionally you will find yourself in a position where you have unformatted, or poorly formatted json and you would like to view it formatted, also knowns *pretty printed*.

There are a bunch of online resources for this, such as [this one](https://jsonformatter.org) , [this one](https://jsonformatter.curiousconcept.com) and [this one](https://jsoneditoronline.org)

But it is very trivial to write a few lines of code to solve this problem, using the types found in the  [System.Text.Json](https://learn.microsoft.com/en-us/dotnet/api/system.text.json?view=net-9.0) namsepace.

The code will be as follows:

```csharp
using System.Text.Json;

string json = """
{
  "name": "James Bond","age": 45, "agency": "MI-6", "status":{ "retired":true, "code":"007"}
}
""";

// Create and set the serialization options
var options = new JsonSerializerOptions
{
    // Specify that the attributes should be indented
    WriteIndented = true
};

// Parse the json
var jsonDocument = JsonDocument.Parse(json);
// Serialize the json into a formatted string, passing the configured options
var formattedJson = JsonSerializer.Serialize(jsonDocument, options);

Console.WriteLine(formattedJson);
```

If you run the program you should see this as the result:

```json
{
  "name": "James Bond",
  "age": 45,
  "agency": "MI-6",
  "status": {
    "retired": true,
    "code": "007"
  }
}
```

It is trivial to refactor this to accept the unformatted json as input and then wrap the code  in a [LinqPad](https://www.linqpad.net/) script, or a [console](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio?pivots=dotnet-9-0) application, or a [WebAP](https://learn.microsoft.com/en-us/aspnet/core/tutorials/first-web-api?view=aspnetcore-9.0&tabs=visual-studio) for routine access.

If you are using [Newtonsoft.Json](https://www.newtonsoft.com/json), the code is even simpler:

```csharp
var formattedJson = JToken.Parse(json);
Console.Write(formattedJson);
```

Happy hacking!