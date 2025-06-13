---
layout: post
title: What does EnsureSuccessStatusCode do?
date: 2025-06-11 09:42:26 +0300
categories:
    - C#
    - .NET
    - HttpClient
---

When making web requests using a [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-9.0), you almost certainly would use one of these methods:

- [GetStreamAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.getstreamasync?view=net-9.0)
- [GetStringAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.getstringasync?view=net-9.0)

For niche usages, you might also use

- [GetByteArrayAsyc](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.getbytearrayasync?view=net-9.0)

For example:

```c#
// fetch a byte array
_ = await client.GetByteArrayAsync("https://conradakunga.com");
// fetch a stream
_ = await client.GetStreamAsync("https://conradakunga.com");
// fetch a string
_ = await client.GetStringAsync("https://conradakunga.com");
```

What they have in common is that they will throw an `Exception` - a [HttpRequestException](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httprequestexception?view=net-9.0) in particular, if a **non-success** response code is returned.

A non-success here is [anything not in the 200 range](https://sagrawal003.medium.com/http-response-status-codes-successful-200-299-grow-together-by-sharing-knowledge-57a35586c65f).

Now let us try the lower level method [GetAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.getasync?view=net-9.0), for a URL I know for a fact does not exist:

```c#
var client = new HttpClient();
client.Timeout = TimeSpan.FromSeconds(250);

try
{
  // fetch a response
  var response = await client.GetAsync("https://conradakunga.com/324234");
}
catch (Exception ex)
{
  Console.WriteLine($"There was an error: {ex.Message}");
}
```

This code **does not throw an exception**!

The response here is a [HttpResponseMessage](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpresponsemessage?view=net-9.0) object. You can **interrogate** this to see what happened.

```c#
try
{
  // fetch a response
  var response = await client.GetAsync("https://conradakunga.com/324234");

  if (response.IsSuccessStatusCode)
  {
    Console.WriteLine("Success");
  }
  else
  {
    Console.WriteLine($"Error fetching the page, server returned a {response.StatusCode}");
  }
}
catch (Exception ex)
{
  Console.WriteLine($"There was an error: {ex.Message}");
}
```

This will print the following:

```plaintext
Error fetching the page, server returned a NotFound
```

As I have pointed out in a [previous post about fetching JSON]({% post_url 2025-06-05-how-to-deserialize-json-using-httpclient-in-using-c-in-net %}), this technique is more flexible because, in cases where the failure reason is returned in the response, **you can read this yourself** from the [Content](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpresponsemessage.content?view=net-9.0) property of the `HttpResponseMessage` object.

**This is not possible using any of the other techniques.**

If, however, you want `GetAsync` to behave like the others, you can call the [EnsureSuccessStatusCode](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpresponsemessage.ensuresuccessstatuscode?view=net-9.0) [method](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpresponsemessage.ensuresuccessstatuscode?view=net-9.0).

This code, for example, will throw an exception:

```c#
try
{
  // fetch a response
  var response = await client.GetAsync("https://conradakunga.com/324234");
  response.EnsureSuccessStatusCode();

  if (response.IsSuccessStatusCode)
  {
    Console.WriteLine("Success");
  }
  else
  {
    Console.WriteLine($"Error fetching the page, server returned a {response.StatusCode}");
  }
}
catch (Exception ex)
{
  Console.WriteLine($"There was an error: {ex.Message}");
}
```

The code for checking the response status code **will never be executed if an exception occurs**.

### TLDR

**The `EnsureSuccessStatusCode` method can be used to signal to the `GetAsync` method to throw an exception if the response is not a success.**

Happy hacking!
