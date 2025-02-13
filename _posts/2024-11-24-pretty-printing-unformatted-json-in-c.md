---
layout: post
title: Pretty Printing Unformatted Json In C#
date: 2024-11-24 18:25:43 +0300
categories:
    - C#
    - .NET
---

Occasionally, you will find yourself in a position where you have unformatted or poorly formatted JSON, and you would like to view it formatted, also known as *pretty printed*.

There are a bunch of online resources for this, such as [this one](https://jsonformatter.org), [this one](https://jsonformatter.curiousconcept.com) and [this one](https://jsoneditoronline.org)

But writing a few lines of code to solve this problem is very trivial, using the types found in the  [System.Text.Json](https://learn.microsoft.com/en-us/dotnet/api/system.text.json?view=net-9.0) namespace.

The code will be as follows:

```csharp
using System.Text.Json;

string json = """
{
  "name": "James Bond","age": 45, "agency": "MI-6", "status":{ "retired":true, "code":"007"}
}
""";

var formattedJson = JsonNode.Parse(json);
Console.Write(formattedJson);
```

This will output the following:

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

It is trivial to refactor this to accept the unformatted JSON as input and then wrap the code in a LinqPad script, a [console](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio?pivots=dotnet-9-0) application, or a [WebAPI](https://learn.microsoft.com/en-us/aspnet/core/tutorials/first-web-api?view=aspnetcore-9.0&tabs=visual-studio) for routine access.

If you are using [Newtonsoft.Json](https://www.newtonsoft.com/json), the code is even simpler:

```csharp
var formattedJson = JToken.Parse(json);
Console.Write(formattedJson);
```

Happy hacking!