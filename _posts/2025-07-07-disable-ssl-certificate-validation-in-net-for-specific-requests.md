---
layout: post
title: Disable SSL Certificate Validation in .NET for Specific Requests
date: 2025-07-07 22:37:48 +0300
categories:
---

About five years ago, I wrote a post on how to [Disable SSL Certificate Validation]({% post_url 2020-10-31-disable-ssl-certificate-validation-in-net %}) in .NET. You can read the post to catch up with the salient points.

Within the post, I made it clear that if you were using .NET Framework, you would do it like this:

```c#
ServicePointManager.ServerCertificateValidationCallback +=
    (sender, cert, chain, sslPolicyErrors) => { return true; };
```

If you are on .NET Core, now just .NET, you would do it like this, performing your logic within a [HttpHandler](https://learn.microsoft.com/en-us/dotnet/api/system.net.http.httpclienthandler?view=net-9.0):

```c#
var EndPoint = "https://192.168.0.1/api";
var httpClientHandler = new HttpClientHandler();
httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, sslPolicyErrors) =>
{
    return true;
};
httpClient = new HttpClient(httpClientHandler) { BaseAddress = new Uri(EndPoint)
```

So far, so good.

The problem with these approaches is that **all the requests being handled will bypass SSL certificate validation**, which is **a bad thing**.

It is much better to only **skip the checks for requests that you know are problematic**, and have the rest be validated as usual.

Let us say we want to skip SSL checks for all `localhost` requests.

For .NET Framework, we would do it like this:

```c#
var host = "localhost";
ServicePointManager.ServerCertificateValidationCallback =
             (sender, certificate, chain, sslPolicyErrors) =>
             {
               if (sender is HttpWebRequest request)
               {
                 if (request.Host == host)
                 {
                  Log.Warning("Skipping SSL validation for {Url}", request.RequestUri);
                  return true;
                 }
               }

               // Use default validation for everything else
               return sslPolicyErrors == SslPolicyErrors.None;
             };
```

This code should run before any code that makes HTTP requests.

For .NET, we would do it like this:

```c#
httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, sslPolicyErrors) =>
{
  if (message.RequestUri.Host == host)
  {
    Log.Warning("Skipping SSL validation for {Url}", message.RequestUri);
    return true;
  }

  // Use default validation for everything else
  return sslPolicyErrors == SslPolicyErrors.None;
};

var client = new HttpClient(httpClientHandler);
// Make requests from here
```

In this fashion, we can control **which** requests should have SSL certificate validation.

You can extend this logic further for more complex conditions, perhaps by **path**. Or **date**. The world is your oyster!

### TLDR

**It is bad practice to allow SSL validation skipping globally. Far better to selectively enforce it.**

Happy hacking!
