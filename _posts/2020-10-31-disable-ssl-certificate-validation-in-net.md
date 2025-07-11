---
layout: post
title: Disable SSL Certificate Validation In .NET
date: 2020-10-31 12:52:07 +0300
categories:
    - C#
---
If you are invoking a web request from your application, you may get the following error:

```plaintext
[16:44:34 ERR] Connection ID "18230571301796315259", Request ID "8000007c-0002-fd00-b63f-84710c7967bb": An unhandled exception was thrown by the application.
System.AggregateException: One or more errors occurred. (The SSL connection could not be established, see inner exception.) ---> System.Net.Http.HttpRequestException: The SSL connection could not be established, see inner exception. ---> System.Security.Authentication.AuthenticationException: The remote certificate is invalid according to the validation procedure.
```

If the request you were making was a HTTPS request, this essentially means that the runtime is attempting to validate the target's SSL certificate, and this validation is failing.

This could be for any number of reasons, ranging from the certificate being self-signed to the certificate having expired or even it has been revoked.

Whatever the case may be, there are times when you do not want this validation to take place - perhaps you are doing some internal development.

It is possible to turn this off.

If you are running on **.NET Framework**, add this line of code somewhere it will be executed, maybe in a constructor, or on a load event.

```csharp
ServicePointManager.ServerCertificateValidationCallback +=
    (sender, cert, chain, sslPolicyErrors) => { return true; };
```

This code essentially forces the runtime to believe that the certificate validation process has succeeded.

If you're running in **.NET Core** you need to do it a bit differently, as the code above does not actually do anything.

For .**NET Core** you need to do a bit more work and create a handler to perform this work. This handler is then passed to the `HttpClient` that you are using to invoke the requests.

```csharp
var EndPoint = "https://192.168.0.1/api";
var httpClientHandler = new HttpClientHandler();
httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, sslPolicyErrors) =>
{
    return true;
};
httpClient = new HttpClient(httpClientHandler) { BaseAddress = new Uri(EndPoint) };
```

The `HttpClient` will no longer throw SSL validation errors.

This approach is more flexible because you can control the validation; you can have some requests that you want validated and others that you do not. 

In this case, you create a second `HttpClient` the usual way without the handler - that one's requests will always be validated.

The solution on the .NET Framework above has the disadvantage that **all** HTTPS requests in that application are not validated.

You can also use the `HttpClient` technique on the full .NET Framework.

Happy hacking!