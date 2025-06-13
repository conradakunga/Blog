---
layout: post
title: Setting Timeouts for HttpClient Requests
date: 2025-06-10 09:06:13 +0300
categories:
    - C#
    - .NET
---

When using a [HttpClient](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-9.0) to make requests to fetch [URLs](https://en.wikipedia.org/wiki/URL), you would typically do it as follows:

```c#
var client = new HttpClient();

var response = await client.GetStringAsync("https://conradakunga.com");

Console.WriteLine(response);
```

This is generally sufficient for **most** cases.

However, there are scenarios when the host you are requesting is **slow**, or the payload you are requesting is **large**, or the network you are connecting to has a lot of **latency** issues.

In this case, there is a risk that your request will **timeout and fail to complete**, throwing an exception.

By default, the `HttpClient` will wait 100 seconds.

It is possible to change this default [timeout](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.timeout?view=net-9.0) value.

For example, if we wanted to change it to 250 seconds, we would do it as follows:

```c#
var client = new HttpClient();
client.Timeout = TimeSpan.FromSeconds(250);
```

This would **set the timeout for all requests made with the instance**.

We can also change the timeout for a **particular request**, rather than do it globally.

This is achieved using a [CancellationTokenSource](https://learn.microsoft.com/en-us/dotnet/api/system.threading.cancellationtokensource?view=net-9.0), which we use to set the timeout.

```c#
var client = new HttpClient();

// Set the timeout
var timeout = TimeSpan.FromSeconds(10);
// Create a cancellation token source
using (var cts = new CancellationTokenSource(timeout))
{
  try
  {
    var response = await client.GetStringAsync("https://conradakunga.com", cts.Token);
    Console.WriteLine(response);
  }
  // Check if our request timed out	
  catch (OperationCanceledException) when (!cts.Token.IsCancellationRequested)
  {
    Console.WriteLine("Request timed out.");
  }
}
```

Note that this timeout is used **in conjunction** with the global `HttpClient` timeout, and the **smaller** one will win.

In other words, **this timeout cannot exceed the global one**. 

Which begs the question: what if **you have a particularly long-running request and you don't want to override your global timeout specifically for this**?

The simplest solution is to have a **second** `HttpClient` for this request and set its timeout to that long period.

### TLDR

**You can adjust the default timeout for a `HttpClient` to accommodate long-running requests.**

Happy hacking!
