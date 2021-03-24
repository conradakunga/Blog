---
layout: post
title: HTTP Redirects Using HttpClient
date: 2020-11-23 09:54:58 +0300
categories:
    - C#
    - Under The Hood
    - HttpClient
---
In a [previous post]({% post_url 2020-11-09-getting-now-playing-information-from-wqxr-in-net %}) I had mentioned that the `HttpClient` does not automatically process HTTP redirects and you would have to write the logic yourself.

As with most things in life, this is partly true and also partly false.

We can demonstrate this with a real example.

My company site is [innova.co.ke](http://www.innova.co.ke). I have also bought [innova.africa](http://innova.africa).

I have setup `innova.africa` to redirect to `innova.co.ke`, so that anyone visiting the former will be seamlessly redirected to the latter.

So let us make a normal request to `innova.africa`

```csharp
// Create  a plain client
var plainClient = new HttpClient();
var response = await plainClient.GetStringAsync("http://innova.africa");
Console.WriteLine(response);
```

We should see the html of the website (redirected) printed to the console.

![](../images/2020/11/CaptureHTML.png)

Given nothing special has been done, this implies that the `HttpClient` has in fact followed the redirect.

We can prove this by modifying the code slightly.

When constructing the `HttpClient` we can pass it a [HttpClientHandler](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclienthandler?view=net-5.0) that controls various properties.

One of these properties is [AllowAutoRedirect](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclienthandler.allowautoredirect?view=net-5.0#System_Net_Http_HttpClientHandler_AllowAutoRedirect), which we can see defaults to true.

We can turn this off like so:

```csharp
// Create new client and turn off autoredirect
var clientAutoOff = new HttpClient(new HttpClientHandler() { AllowAutoRedirect = false });
response = await clientAutoOff.GetStringAsync("http://innova.africa");
Console.WriteLine(response);
```

If we run this we in fact get an error:

![](../images/2020/11/HttpClientRedirectError.png)

To understand what exactly is happening we need to dig a little deeper.

What we want to examine is the headers that the server responds with to the initial request.
  
For this we need to do two things:

1. Change how we are making the request - rather than make a request for content, we make a raw request using [GetAsync](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.getasync?view=net-5.0) rather than [GetStringAsync](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient.getstringasync?view=net-5.0)

   The difference is `GetAsync` returns a `HttpResponse` object, which we want to examine, rather than `GetStringAsync` which returns the response content as a `string`.

2. Instruct the `HttpClient` that we are interested in just the headers, and not the body. This is done using an overload of the `GetAsync` method.

The code is as follows:

```csharp
// Reuse the previous client, and read just the headers in this request
var headerResponse = await clientAutoOff.GetAsync("http://innova.africa", HttpCompletionOption.ResponseHeadersRead);
// Iterate through the headers of the response and print them
foreach (var item in headerResponse.Headers)
{
    Console.WriteLine($"Header: {item.Key} - {string.Join(",", item.Value)}");
}
```

If we run this we should see the following:

![](../images/2020/11/HeadersResponse.png)

The key header here is `Location`.

If the `AllowAutoRedirect` is `true`, the `HttpClient` will retrieve the value of this header and automatically make a request to the URL specified there.

Now I opened by saying it is partly true and partly false that the `HttpClient` automatically follows redirects, and I seem to have proved otherwise.

Here's the thing: even with `AllowAutoRedirect` being true, a request to a **http** resource that has been redirected to a **https** resource will **NOT** be auto redirected.

**In other words a `http` or `https` resource redirected to another `http` or `https` resource will redirect just fine.**

**Where it will break is if the origin is `http` and the corresponding redirect isn't; or if the origin in `https` and the corresponding redirect isn't.**

And to make things more complicated, this change was introduced in .NET Core, as it is arguably more secure. 

However in the full .NET Framework 4.8 and earlier, redirects between `http` and `https` are honored. That means there is inconsistency in behaviour between .NET Core and .NET Framework.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2020-11-23%20-%20HTTP%20Redirects%20Using%20HttpClient).

Happy hacking!