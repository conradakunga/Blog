---
layout: post
title: Connecting to Secured RabbitMQ Over SSL in C# With EasyNetQ
date: 2025-06-26 05:28:15 +0300
categories:
    - C#
    - .NET
    - RabbitMQ
---

One of the most capable message brokers available is [RabbitMQ](https://www.rabbitmq.com/), built on the very robust [Erlang](https://www.erlang.org/) programming language.

You can interface with it on .NET using the native client, [RabbitMQ.Client](https://www.nuget.org/packages/RabbitMQ.Client/).

However, it is much **easier** to use the higher-level [EasyNetQ](https://www.nuget.org/packages/EasyNetQ/).

You can install it as follows:

```bash
dotnet add package EasyNetQ
```

You will also need the [Newtonsoft.Json](https://www.nuget.org/packages/Newtonsoft.Json) library, which is used internally to serialize objects.

```bash
dotnet add package Newtonsoft.Json
```

You then interact with **RabbitMQ** using the `IBus` interface..

```c#
var bus = RabbitHutch.CreateBus("host=localhost;username=user;password=YourStrongPassword123");
```

This works perfectly with RabbitMQ over [HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP).

If your instance of RabbitMQ is secured using [SSL](https://www.digicert.com/what-is-ssl-tls-and-https), you will need to perform **additional steps**, as the connection string above will fail, and you will receive a generic [TaskCanceledException](https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.taskcanceledexception?view=net-9.0).

The code to connect to a **secure** RabbitMQ instance is as follows:

```c#
using System.Net.Security;
using EasyNetQ;
using EasyNetQ.DI;
using Newtonsoft.Json;

// Define connection options
const string host = "localhost";
const ushort port = 5671;
const string username = "test";
const string password = "test";

// Create a connection configuration
var connectionConfiguration = new ConnectionConfiguration
{
    Name = host,
    VirtualHost = "/",
    UserName = username,
    Password = password,
    RequestedHeartbeat = TimeSpan.FromMilliseconds(10),
    Port = port
};


// Create a host configuration
var hostConfiguration = new HostConfiguration
{
    Host = host,
    Port = port,
    Ssl =
    {
        //
        // Configure SSL
        //	
        // Set that no SSL errors are permitted
        AcceptablePolicyErrors = SslPolicyErrors.None,
        // Enable SSL
        Enabled = true,
        // Set host
        ServerName = host
    }
};

// Add hosts to the connection configuration
connectionConfiguration.Hosts = new List<HostConfiguration> { hostConfiguration };

// Create bus object
var bus = RabbitHutch.CreateBus(connectionConfiguration,
    serviceRegister =>
    {
        serviceRegister.Register<ISerializer>(_ =>
            new EasyNetQ.JsonSerializer(new JsonSerializerSettings()
                { TypeNameHandling = TypeNameHandling.None }));
    });

bus.SendReceive.Send("Queue", "test");
```

### TLDR

**Connecting to a *secured* RabbitMQ instance requires some additional configuration.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-06-27%20-%20EasyNetQ%20SSL).

Happy hacking!
