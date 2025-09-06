---
layout: post
title: Other RabbitMQ IConnection Server Properties
date: 2025-09-03 21:18:38 +0300
categories:
    - C#
    - .NET
    - RabbitMQ
    - EasyNetQ
---

In the previous post, "[Getting the Version of RabbitMQ Connected]({% post_url 2025-09-02-getting-the-version-of-rabbitmq-connected-c-net %})", we discussed how to obtain the version of the RabbitMQ instance connected to via the `ServerProperties` property.

This raises the question: **What other properties are available**?

We can make use of the fact that the `ServerProperties` is a `Dictionary` with a `string` key and an `object` value.

This **value** can itself be one of:

1. Another `Dictionary`
2. A `byte` **array**
3. Anything else

We can write a **method** that recursively prints each **entry** and its **property values**.

```c#
void PrintPropertyValues(IDictionary<string, object> properties, int indent)
{
    // Loop through each element in the key-value pair
    foreach (var property in properties)
    {
        // Generate padding for each value
        var prefix = new string(' ', indent * 2);

        // Check the value type
        switch (property.Value)
        {
            case byte[] bytes:
                Console.WriteLine($"{prefix}{property.Key} - {Encoding.UTF8.GetString(bytes)}");
                break;
            case IDictionary<string, object> nested:
                Console.WriteLine($"{prefix}{property.Key} -");
                PrintPropertyValues(nested, indent + 1);
                break;
            default:
                Console.WriteLine($"{prefix}{property.Key} - {property.Value.ToString()}");
                break;
        }
    }
}
```

We can then call the method like this:

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

// Loop through and print the name and type

PrintPropertyValues(serverProperties, 0);
return;
```

This should print the following:

```plaintext
capabilities :
  publisher_confirms - True
  exchange_exchange_bindings - True
  basic.nack - True
  consumer_cancel_notify - True
  connection.blocked - True
  consumer_priorities - True
  authentication_failure_close - True
  per_consumer_qos - True
  direct_reply_to - True
cluster_name - rabbit@69b35927095a
copyright - Copyright (c) 2007-2025 Broadcom Inc and/or its subsidiaries
information - Licensed under the MPL 2.0. Website: https://rabbitmq.com
platform - Erlang/OTP 27.3.4.2
product - RabbitMQ
version - 4.1.4

```

We can thus see a rich collection of information about the running **RabbitMQ** instance that can be used in your logic.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-03%20-%20RabbitMQProperties).

Happy hacking!
