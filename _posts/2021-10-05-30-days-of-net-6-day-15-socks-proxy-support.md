---
layout: post
title: 30 Days Of .NET 6 - Day 15 - SOCKS Proxy Support
date: 2021-10-05 11:24:56 +0300
categories:
    - C#
    - 30 Days Of .NET 6
---
Occasionally you will need to connect to the internet, or to another network for that matter, through a proxy.

You will often find this on corporate networks, where you are required to route your traffic through a proxy server for various reasons - controlling site access, hours, etc.

This is more frequently done through a HTTP proxy, which is designed to route HTTP and HTTPS traffic.

There is a special type of proxy called a [SOCKS](https://en.wikipedia.org/wiki/SOCKS) proxy. The benefit of this over a plain HTTP proxy is that in addition to HTTP and HTTPS traffic, SOCKS proxies can also handle other types of traffic like POP3, SMTP and FTP.

SOCKS also allows you to connect using SSH and Tor.

There are two versions of SOCKS, 4 and 5. The benefit of 5 over 4 is that is supports authentication.

For a long time .NET has not supported SOCKS proxies, and it was not possible to connect via a SOCKS proxy.

This has been changed in .NET 6, which now has full support for SOCKS proxies.

```csharp
using System.Net;

// Create a handler for socks connectivity.
// Note the URI starts with socks5
var socksHander = new HttpClientHandler
{
    Proxy = new WebProxy("socks5://127.0.0.1", 9050)
};

// Wire the handler to a new http client
var client = new HttpClient(socksHander);

// Make a request
var response = await client.GetAsync("https://google.com");
```

If you need to authenticate your connectivity, you can set the credentials as follows:

```csharp
var proxy = new WebProxy("socks5://127.0.0.1", 9050);
proxy.Credentials = new NetworkCredential("user", "p@ssw0rd");
```

If, for whatever reason, you need to use a SOCKS proxy from a Web application, or a Web API application, you can wire it up in your `Program.cs` as follows:

```csharp
builder.Services.AddHttpClient("customClient")
.ConfigurePrimaryHttpMessageHandler(() => 
{
    var proxy = new WebProxy();
    proxy.Address = new Uri("socks5://127.0.0.1:9050");
    return new HttpClientHandler
    {
        Proxy = proxy
    };
});
```

In your controllers you then inject a `IHttpClientFactory` via the constructor, and you can get a `HttpClient` configured correctly like this:

```csharp
// Get a client from injected IHttpClientFactory (_httpClientFactory)
var client = _httpClientFactory.CreateClient("customClient");

// Make a reqest
var response = await
client.GetAsync("https://google.com");
```

# Thoughts

This is a welcome change to allow connectivity to a variety of different networks securely.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-10-05%20-%2030%20Days%20Of%20.NET%206%20-%20Day%2015%20-%20SOCKS%20Proxy).

# TLDR

.NET 6 now supports establishment of connections through SOCKS proxies.

Happy hacking!