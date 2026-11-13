---
layout: post
title: How To Encode An Object For Passing In A URL In C# & .NET
date: 2026-11-09 11:00:49 +0300
categories:
    - Web
    - HTTP
    - C#
    - .NET
---

In our previous post, "[What Problem Does HTTP QUERY Solve?]({% post_url 2026-11-08-what-problem-does-http-query-solve %})", we looked at the **challenges of submitting large payloads to a web server** given the constraints of the [GET](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods/GET) method, as well as a solution to the same, the [QUERY](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods/QUERY) method.

In this post we, will look at the situation of where we need to solve the problem of **passing an object to the web server** while still using a `GET` request.

As a recap, our payload looks like this:

```json
{
  "SearchText": "conrad",
  "SortColumn": "Name",
  "PageNumber": 0,
  "PageSize": 20,
  "Database": "Animals",
  "ActiveOnly": true
}
```

We start by mapping this into a `class` to represent the `object`:

```c#
public sealed class SearchRequest
{
  public required string SearchText { get; init; }
  public required string SortColumn { get; init; }
  public required int PageNumber { get; init; }
  public required int PageSize { get; init; }
  public required string Database { get; init; }
  public required bool ActiveOnly { get; init; }
}

```

The code would look like this:

```c#
var req = new SearchRequest
{
  SearchText = "conrad",
  SortColumn = "Name",
  PageNumber = 0,
  PageSize = 50,
  Database = "Animals",
  ActiveOnly = true
};

// Get the data in bytes
var byteData = JsonSerializer.SerializeToUtf8Bytes(req);
// Convert to a URL representable string
var encodedByteData = Base64Url.EncodeToString(byteData);
```

This generates a `string` like this:

```plaintext
eyJTZWFyY2hUZXh0IjoiY29ucmFkIiwiU29ydENvbHVtbiI6Ik5hbWUiLCJQYWdlTnVtYmVyIjowLCJQYWdlU2l6ZSI6NTAsIkRhdGFiYXNlIjoiQW5pbWFscyIsIkFjdGl2ZU9ubHkiOnRydWV9
```

Finally, we construct our **request**:

```c#
// Create HttpClient
var client = new HttpClient();
// Submit request
var response = await client.GetAsync($"https://localhost:7117/Search/{encodedByteData}");
```

This is ultimately what gets submitted

```plaintext
https://localhost:7117/Search/eyJTZWFyY2hUZXh0IjoiY29ucmFkIiwiU29ydENvbHVtbiI6Ik5hbWUiLCJQYWdlTnVtYmVyIjowLCJQYWdlU2l6ZSI6NTAsIkRhdGFiYXNlIjoiQW5pbWFscyIsIkFjdGl2ZU9ubHkiOnRydWV9
```

Alternatively, we can use a [QueryString](https://en.wikipedia.org/wiki/Query_string) approach like so:

```c#
// Create HttpClient
var client = new HttpClient();
// Submit request
var response = await client.GetAsync($"https://localhost:7117/Search/query={encodedByteData}");
```

```plaintext
https://localhost:7117/Search/query=eyJTZWFyY2hUZXh0IjoiY29ucmFkIiwiU29ydENvbHVtbiI6Ik5hbWUiLCJQYWdlTnVtYmVyIjowLCJQYWdlU2l6ZSI6NTAsIkRhdGFiYXNlIjoiQW5pbWFscyIsIkFjdGl2ZU9ubHkiOnRydWV9
```

On the server side, we can do the reverse to retrieve our data:

```c#
// Decode data back to a byte array
var data = Base64Url.DecodeFromChars(encodedByteData);
// Deserialize byte array to an object
var request = JsonSerializer.Deserialize<SearchRequest>(data);
```

Here, `encodedByteData` we are fetching from the **URL**.

### TLDR

**You can write code to *encode* and post `JSON` over `GET`, as well as *decode* and process the same.**

The code is in my GitHub.

Happy hacking!
