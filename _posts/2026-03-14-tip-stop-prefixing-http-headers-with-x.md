---
layout: post
title: Tip - Stop Prefixing HTTP Headers With X
date: 2026-03-14 11:51:13 +0300
categories:
    - HTTP
    - Protocols
    - Tip
---

When writing web applications and APIs, [HTTP headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers) is something that you will generally have to deal with, either as a **producer** or as a **consumer**.

As a **producer**, your requests will generally have **one** or **more** of these:

- Host
- User-Agent
- Accept
- Accept-Language
- Accept-Encoding
- Referer
- Connection
- Upgrade-Insecure-Requests
- If-Modified-Since
- If-None-Match
- Cache-Control

As a **consumer**, you may need to process one or more of these:

- Access-Control-Allow-Origin
- Connection
- Content-Encoding
- Content-Type
- Date
- ETag
- Keep-Alive
- Last-Modified
- Server
- Set-Cookie
- Transfer-Encoding
- Vary
- X-Backend-Server
- X-Cache-Info
- x-frame-options

You may want to add your own headers to your requests or responses.

For a **request**, you would typically do it this way:

```c#
var client = new HttpClient();
client.DefaultRequestHeaders.Add("YourRequestHeaderNameHere", "YourValueHere");
```

For a **response**, you would typically do it this way:

```c#
app.MapGet("/", (HttpContext context) =>
{
    context.Response.Headers.Append("YourResponseHeaderNameHere", "YourValueHere");
    return "Hello World!";
});
```

For a long time now, when adding custom headers, most people **prefix the header** with `x` or `X`.

```c#
app.MapGet("/", (HttpContext context) =>
{
    context.Response.Headers.Append("x-Application-Version", "1.0.0.0");
    return "Hello World!";
});
```

This has been **deprecated** for quite some time, and is explicitly called out in [RFC6648](https://datatracker.ietf.org/doc/html/rfc6648)

The history for this was that the `x` header was meant to refer to **experiment** headers, hence the `x`.

### TLDR

**There is no need to prefix custom HTTP headers with x. Just name it as intended.**

Happy hacking!
