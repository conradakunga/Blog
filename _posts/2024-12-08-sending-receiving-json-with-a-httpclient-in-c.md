---
layout: post
title: Sending & Receiving JSON With A HttpClient In C#
date: 2024-12-08 10:40:02 +0300
categories:
    - C#
    - HttpClient
---

In my previous post [Sending a HTTP HEAD Request With A HttpClient In C#]({% post_url 2024-12-07-sending-a-http-head-request-with-a-httpclient-in-c %}) I talked about how to send various requests using a [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-9.0).

Of interest is this part where we prepare content for submission (for [POST](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST) and [PUT](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PUT) requests)

```csharp
// Sample request
var payload = new { Name = "James Bond", Age = 50 };
// Serlialize
string jsonPayload = JsonSerializer.Serialize(payload);
// Create a StringContent object with the serialized JSON.
// The content does not have to be JSON!
var content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");
```

This is such a common use case that convenience methods were added to the `HttpClient`.

If you want to **POST** JSON, you do it as follows:

```csharp
// Sample request
var payload = new { Name = "James Bond", Age = 50 };
// Sample post
var response = client.PostAsJsonAsync("URL", payload);
```

To **PUT** there is a corresponding method:

```csharp
// Sample request
var payload = new { Name = "James Bond", Age = 50 };
// Sample put
var response = client.PutAsJsonAsync("URL", payload);
```

If you wanted to **receive** JSON, the hard way it so deserialize the response yourself.

Assuming we had this record:

```csharp
public record Person(string Name, string Age);
```

We could fetch and deserialize a `Person` like this:

```csharp
// Get the HttpResponse
var response = await client.GetAsync("URL");
// Fetch the content from the response
var personString = await response.Content.ReadAsStringAsync();
// Deserialize into a person
var person = JsonSerializer.Deserialize<Person>(personStrin
```

This is such a common use case, a helper has been introduced for reading the response.

The same result can be achieved as follows:

```csharp
// Get the HttpResponse
var response = await client.GetAsync("URL");
// Deserialize the content
var person = await response.Content.ReadFromJsonAsync<Person>();
```

This has been simplified even further at the `HttpClient` level.

```csharp
var person = await client.GetFromJsonAsync<Person>("URL");
```

Happy hacking!
