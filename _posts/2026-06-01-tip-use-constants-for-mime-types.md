---
layout: post
title: Tip - Use Constants For MIME Types
date: 2026-06-01 22:46:52 +0300
categories:
    - C#
    - .NET
    - Tips
---

Quick, what's wrong with this code?

```c#
var client = new HttpClient();
client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("appliction/json"));
```

Took me **longer than I am prepared to admit** to notice that the reason my code was not working is that there is a typo there - it should read `application/json` and not `appliction/json`.

Wiring code like this exposes you to a number of problems.

1. **Typos**!
2. Since you are typing this string everywhere, should you need to **change it**, it will be a **messy** process.
3. **Subtle bugs** can be introduced where, in some scenarios, the string is correct, but one or more letters have a different **case**.

The solution to this, naturally, is [constants](https://en.wikipedia.org/wiki/Constant_(computer_programming)).

You might be tempted to do something like this:

```c#
const string ApplicationJSON = "application/json"
```

And then go on to use it like this:

`````c#
var client = new HttpClient();
client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(ApplicationJSON));
`````

But there is no need. The solution already **exists** in the [System.Net.Mime](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime?view=net-10.0) namespace.

The `string` `application/json` is accessed as the constant [MediaTypeNames.Application.Json](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.application.json?view=net-10.0).

The same pattern will apply should we need the string `text/csv`.

This is accessible via the **constant** [MediaTypeNames.Text.Csv](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.text.csv?view=net-10.0) .

The same applies to the other namespaces - [Font](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.font?view=net-10.0), [Image,](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.image?view=net-10.0) and [Multipart](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.multipart?view=net-10.0), as well as the ones we have seen - [Application](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.application?view=net-10.0) and [Text](https://learn.microsoft.com/en-us/dotnet/api/system.net.mime.mediatypenames.text?view=net-10.0).

Our original code will now be as follows:

```c#
var client = new HttpClient();
client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue(MediaTypeNames.Application.Json));
```

### TLDR

**`System.Net.Mime` namespace contains a large number of constants that you can use for your `HTTP` coding.**

Happy hacking!
