---
layout: post
title: .NET 11 Preview - Native DNS Resolving
date: 2026-09-01 19:26:21 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

If you are doing some very low level networking work, perhaps at [DNS](https://www.cloudflare.com/learning/dns/what-is-dns/) level, one challenge you will run into is when you need to do your own [DNS resolution](https://www.datadoghq.com/knowledge-center/dns-resolution/).

This is not natively available in .NET, and you therefore have to resort to one of the following:

1. **Shell** to a command like [nslookup](https://en.wikipedia.org/wiki/Nslookup) or [dig](https://en.wikipedia.org/wiki/Dig_(command)) and parse the results
2. Use **interop** (if on Windows) from the `dnsapi.dll` library
3. Write the low level code to send data and parse results over **sockets**
4. Use a **third party library**, like [DNSClient](https://github.com/MichaCo/DnsClient.NET)

This has been addressed in .NET 11 using the new [ResolveSrvAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.dns.resolvesrvasync?view=net-11.0) method.

The code is like this:

```c#
var result = await Dns.ResolveSrvAsync("_imaps._tcp.gmail.com");

if (result.ResponseCode == DnsResponseCode.NoError)
{
  if (result.Records.Count == 0)
  {
  	Console.WriteLine("No SRV records found.");
  }
  else
  {
    foreach (var record in result.Records)
    {
    	Console.WriteLine($"{record.Target}:{record.Port} Priority={record.Priority} Weight={record.Weight}");
    }
  }
}
```

The return type, `result` is of type `DnsResult<SrvRecord>`.

This should return the following:

![dnsSrvResult](../images/2026/09/dnsSrvResult.png)

There are equivalent methods revolving other [types of record](https://www.cloudflare.com/learning/dns/dns-records/):

- [ResolveCNameAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.dns.resolvecnameasync?view=net-11.0)
- [ResolveMxAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.dns.resolvemxasync?view=net-11.0)
- [ResolveNsAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.dns.resolvensasync?view=net-11.0)
- [ResolvePtrAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.dns.resolveptrasync?view=net-11.0)
- [ResolveTxtAsync](https://learn.microsoft.com/en-us/dotnet/api/system.net.dns.resolvetxtasync?view=net-11.0)

These also have equivalent **synchronous** versions.

**NOTE: This only works in Windows, at present.**

### TLDR

**.NET 11 can now do native DNS resolution and parse the returned records for subsequent processing.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-09-01%20-%20DNSResolution).

Happy hacking!
