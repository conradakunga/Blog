---
layout: post
title: Sending a HTTP HEAD Request With A HttpClient In C#
date: 2024-12-08 01:58:23 +0300
categories:
    - C#
    - HttpClient
---

It is very simple to send [GET](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET), [POST](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST), [PUT](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PUT), [PATCH](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PATCH) and [DELETE](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/DELETE) requests using a [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-9.0).

Here is some code demonstration how to send the various requests.

```csharp
var client = new HttpClient();

// Sample request
var payload = new { Name = "James Bond", Age = 50 };
// Serlialize
string jsonPayload = JsonSerializer.Serialize(payload);
// Create a StringContent object with the serialized JSON.
// The content does not have to be JSON!
var content = new StringContent(jsonPayload, Encoding.UTF8, "application/json");

// Sample get
var getResponse = await client.GetAsync("URL");
// Sample Post
var postResponse = await client.PostAsync("URL", content);
// Sample Put
var putResponse = await client.PutAsync("URL", content);
// Sample Delete
var deleteResponse = await client.DeleteAsync("URL");
// Sample patch
var patchResponse = await client.PatchAsync("URL", content);
```

You might wonder how to send a `HEAD` request, as there is no `HeadAsync` method.

You will have to put in a little more work as you have to crate and send a raw [HttpRequestMessage](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=net-9.0) instead, which allows you to customize what you want to submit in various ways, including the type of request.

You do it like this:

```csharp
// Create a custom request message, specifying it is a HEAD
var req = new HttpRequestMessage(HttpMethod.Head, "URL");
// Send request and await a responce
var headResponse = await client.SendAsync(req);
```

Happy hacking!
