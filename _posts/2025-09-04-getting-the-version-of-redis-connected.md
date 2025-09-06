---
layout: post
title: Getting the Version of Redis Connected in C# & .MET
date: 2025-09-04 11:14:50 +0300
categories:
    - C#
    - .NET
    - Redis
    - StackExchange.Redis
---

Now that we know the process of "[Getting the Version of RabbitMQ Connected]({% post_url 2025-09-02-getting-the-version-of-rabbitmq-connected-c-net %})", I wondered if it was possible to do the same for [Redis](https://redis.io/).

For **debugging** and **troubleshooting** purposes, it may be necessary to retrieve this information at **runtime** from within your application.

And the answer is indeed, this is very possible.

You send the server the [INFO](https://redis.io/docs/latest/commands/info/) command, and read the returned response.

The response is a structure that is a nested grouping of [KeyValue](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.keyvaluepair-2?view=net-9.0) pairs.

You can extract the version as follows:

```c#
// Adjust your connection string as needed

using StackExchange.Redis;

// Get a connection to the Redis server
await using (var connection =
             await ConnectionMultiplexer.ConnectAsync("localhost:6379,password=YourStrongPassword123,allowAdmin=true"))
{
    // Retrieve the server
    var server = connection.GetServer("localhost", 6379);

    // Execute the INFO command
    var version = server.Info("Server")
        .SelectMany(g => g)
        .FirstOrDefault(p => p.Key == "redis_version").Value;

    Console.WriteLine($"Version: {version}");
}
```

This will print something like this:

```plaintext
Redis Version: 8.2.1
```

The caveat of this technique is that you must connect to Redis with [admin mode](https://redis.io/docs/latest/operate/oss_and_stack/management/admin/) enabled by passing the value `allowAdmin=true` to the connection string.

This, naturally, is probably not going to be possible in production for obvious reasons - **security**!

We will see how to achieve that in the next post.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-04%20-%20RedisVersion).

Happy hacking!
