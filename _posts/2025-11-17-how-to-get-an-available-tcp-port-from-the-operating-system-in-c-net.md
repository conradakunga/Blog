---
layout: post
title: How To Get An Available TCP Port From The Operating System In C# & .NET
date: 2025-11-17 21:43:32 +0300
categories:
    - C#
    - .NET
    - Networking
---

If you ever find yourself needing to write a **network server application**, an issue you will quickly face is finding an **available** [port](https://en.wikipedia.org/wiki/Port_(computer_networking)).

There are two ways to go about this:

1. Using a `TCPListener`
2. Using a `Socket`

## Using A TCP Listener

The first technique is to create a [TCPListener](https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.tcplistener?view=net-9.0), binding it to the [Loopback](https://en.wikipedia.org/wiki/Loopback) address on Port `0`.

This will **request an available port** from the **operating system**.

```c#
int TcpListenerGetFreePort()
{
    using var listener = new TcpListener(IPAddress.Loopback, 0);
    listener.Start();
    return ((IPEndPoint)listener.LocalEndpoint).Port;
}
```

## Using A Socket

The other technique is to use a [Socket](https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.socket?view=net-9.0) directly, like so:

```c#
int SocketGetFreePort()
{
    using (var s = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp))
    {
        s.Bind(new IPEndPoint(IPAddress.Loopback, 0));
        return ((IPEndPoint)s.LocalEndPoint!).Port;
    }
}
```

Here we are **also** requesting the operating system for a port by binding the loopback address to port `0`.

The application itself will look like this:

```c#
using System.Net;
using System.Net.Sockets;

Console.WriteLine($"TCPListener free port: {TcpListenerGetFreePort()}");
Console.WriteLine($"Socket free port: {SocketGetFreePort()}");
return;
```

### TLDR

**You can request the operating system for an available port.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-11-17%20-%20GetAvailablePort).

Happy hacking!
