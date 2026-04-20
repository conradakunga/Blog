---
layout: post
title: Tip - How To Add Headers Per Request In C# & .NET
date: 2026-03-16 23:16:26 +0300
categories:
    - C#
    - .NET
    - HttpClient
---

Yesterday's post, "[Tip - How To Correctly Add Response HttpHeaders In C# & .NET]({% post_url 2026-03-15-tip-how-to-correctly-add-response-httpheaders-in-c-net %})", looked at how to **add headers** to HTTP **Responses** by **accessing** and **modifying** the `Headers` collection of the `Response` object of the `HttpContext`.

Today's post will look at how to do the same from the **client**, i.e. the [Request](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.http.httprequest?view=aspnetcore-10.0).

Here we have to decide the following:

1. Will the header be sent with **all requests**?
2. Is the header specific to **particular request**?

## All Requests

If the header will be sent for **all** requests, you would typically access the [DefaultRequestHeaders](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.defaultrequestheaders?view=net-10.0) property of the [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-10.0) and set the **header** (and **value**) that you want.

```c#
var client = new HttpClient();
// Set the default headers	
client.DefaultRequestHeaders.Add("YourHeaderNameHere", "YourValueHere");
```

## Per Request

If, for some reason, your header is only valid for a **particular request**, you have to do a bit more heavy lifting.

The code will be as follows:

```c#
// Create a request
var request = new HttpRequestMessage(HttpMethod.Get, "https://example.com");
// Add your header and value
request.Headers.Add("YourHeaderNameHere", "YourValueHere");
// Send the request and await the response
var response = await client.SendAsync(request);
```

The logic here is as follows:

1. Create a [HttpRequestMessage](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestmessage?view=net-10.0) (can be a [GET](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods/GET), [POST](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods/POST), etc)
2. Add your **header**
3. Send the `HttpRequestMessage`
4. Await the **response**

Reminder: the HttpClient will set the casing for the headers for you. This generally won't be an issue, but there are cases where the downstream server expects the header to be of a particular case.

In such a situation you can use the method outlined in the post "[Controlling The Casing Of Submitted Request Headers In C# & .NET]({% post_url 2025-07-04-controlling-the-casing-of-submitted-request-headers-in-c-net %})"

### TLDR

**You can configure a `HttpClient` to send specific headers for all requests, or you can configure the headers to be specific to requests.**

Happy hacking!
