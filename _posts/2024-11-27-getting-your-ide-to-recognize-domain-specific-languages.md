---
layout: post
title: Getting Your IDE To Recognize Domain Specific Languages
date: 2024-11-27 23:12:15 +0300
categories:
    - Rider
    - Visual Studio
    - Visual Studio Code
---

Suppose you had a program with the following code:

```csharp
var json =
"""
    "name":"james bond",
    "retired":true,
    "age":45
""";

Console.WriteLine(json);
```

It looks like this on [Visual Studio](https://visualstudio.microsoft.com)

![vsNormal](../images/2024/11/vsNormal.png)

And like this on [Visual Studio Code](https://code.visualstudio.com)

![vsCodeNormal](../images/2024/11/vsCodeNormal.png)

And like this on [Rider](https://www.jetbrains.com/rider/)

![riderNormal](../images/2024/11/riderNormal.png)

Very straightforward.

Did you know it is possible to tell your IDE that the string is `json`?

Do that by adding the following comment just before the string

```csharp
//lang=sql
var json =
"""
    "name":"james bond",
    "retired":true,
    "age":45
""";
```

It will look like this in **Visual Studio**, with a squiggly indicator. Notice also the syntax highlighting

![vsHint](../images/2024/11/vsHint.png)

If you hover your mouse over that you see the following:

![vsHintTooltip](../images/2024/11/vsHintTooltip.png)

It is basically saying that the `json` is invalid (no opening and closing curly braces!)

The same thing for **Visual Studio Code**

![vsCodeHint](../images/2024/11/vsCodeHint.png)

And if you hover your mouse ...

![vsCodeHintTooltip](../images/2024/11/vsCodeHintTooltip.png)

This also works with **Rider**

![riderHint](../images/2024/11/riderHint.png)

If you mouse over ...

![riderHintTooltip](../images/2024/11/riderHintTooltip.png)

This also works for a few other domain specific languages:

1. Regular Expressions
2. SQL
3. XML
4. Javascript
5. CSS
6. HTML

Happy hacking!