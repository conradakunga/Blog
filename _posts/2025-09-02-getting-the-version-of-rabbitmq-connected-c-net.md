---
layout: post
title: Getting the Version of RabbitMQ Connected in C# & .NET
date: 2025-09-02 16:39:54 +0300
categories:
    - C#
    - .NET
    - RabbitMQ
    - EasyNetQ
---
Recently, I was troubleshooting some code using [RabbitMQ](https://www.rabbitmq.com/) & [EasyNetQ](https://easynetq.com/) and found myself wondering how to verify the version of **RabbitMQ** I was connected to.

The simplest way is as follows:

1. Create a connection to the **RabbitMQ** instance
2. Fetch the server properties
3. Read the version property

This is stored as a `byte` array, that you will need to decode.

The code is as follows:

```c#
using System.Text;
using RabbitMQ.Client;

// Set the username, password & port
const string username = "test";
const string password = "test";
const short port = 5672;

// Create factory to use for connection
var factory = new ConnectionFactory
{
    Uri = new Uri($"amqp://{username}:{password}@localhost:{port}/")
};

// Get a connection
using var connection = factory.CreateConnection();

// Fetch the server properties
var serverProperties = connection.ServerProperties;

// Fetch the version
if (serverProperties.TryGetValue("version", out var versionBytes))
{
    // Decode the version
    var version = Encoding.UTF8.GetString((byte[])versionBytes);

    // Print version info
    Console.WriteLine($"RabbitMQ Version: {version}");
}
else
{
    Console.WriteLine("Error fetching version");
}
```

This should print something like this:

```plaintext
RabbitMQ Version: 4.1.4
```

If you are not using EasyNetQ, you can directly reference the [RabbitMQ.Client](https://www.rabbitmq.com/client-libraries/dotnet) package.

### TLDR

You can access the version of **RabbitMQ** from the `ServerProperties` object of the `IConnection`.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-02%20-%20RabbitMQVersion).

Happy hacking!
