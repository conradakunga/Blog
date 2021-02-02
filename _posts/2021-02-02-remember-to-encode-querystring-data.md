---
layout: post
title: Remember To Encode QueryString Data
date: 2021-02-02 15:06:19 +0300
categories:
    - Tips
---
Assume you have a controller with this `GET` end point

`/Clients/Code/{code}`

It takes a code as part of the passed querystring data.

This works well with

```plaintext
00234
James
34234*
```

But it will fail if you want to search

```plaintext
234\2342
234%$
```

Why? Because not all data is correctly encoded for querstrings.

To pass data to the end point, you need to do the following:

```csharp
var rawCode = "234%$";
// Encode the code
var encodedCode = HttpUtility.UrlEncode(rawCode);
// Prepare the url
$"/Clients/Code/{encodedCode}";
```
Here we are using [HttpUtility.UrlEncode](https://docs.microsoft.com/en-us/dotnet/api/system.web.httputility.urlencode?view=net-5.0) to encode the data for the querystring.

With this example, the code `234%$` encodes to `234%25%24`.

Correspondingly, on the controller (or the underlying logic processing the request), you must remember to decode the string.
  
This is done using a corresponding method, [HttpUtility.UrlDecode](https://docs.microsoft.com/en-us/dotnet/api/system.web.httputility.htmldecode?view=net-5.0).


```csharp
var rawCode = "234%25%24";
// Decode the raw code
var decodedCode = HttpUtility.UrlDecode(rawCode).Dump();
// Now we have our correct code
```

Very subtle bugs can creep into your system if you forget to do this, where logic works for most cases and fails for some edge cases.

Happy hacking!

