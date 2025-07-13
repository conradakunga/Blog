---
layout: post
title: Programmatically Checking If There Are Messages In The EasyNetQ Error Queue In C# & .NET
date: 2025-07-12 19:45:32 +0300
categories:
    - C#
    - .NET
    - RabbitMQ
    - EasyNetQ
---

The last post, [Deleting A RabbitMQ Queue In C# & .NET]({% post_url 2025-07-11-deleting-a-rabbitmq-queue-in-c-net %}), discussed connecting to [RabbitMQ](https://www.rabbitmq.com/) using the [EasyNetQ Management Client](https://www.nuget.org/packages/EasyNetQ.Management.Client) and deleting a queue.

In this post, we will look at how to check if there are any messages in the `EasyNetQ` **error queue**.

This is a special queue created by `EasyNetQ` automatically, into which all problematic messages are placed. Problematic here typically refers to some sort of error when popping the message.

This queue is typically named `EasyNetQ_Default_Error_Queue`.

It is beneficial to **check the queue for messages periodically**.

You can do this **manually** by **logging into the admin interface** and checking.

However, it is better to **automate** this process using code, as follows:

First, install the [EasyNetQ Management Client](https://www.nuget.org/packages/EasyNetQ.Management.Client) package:

```bash
dotnet add package EasyNetQ.Management.Client
```

Next, we write the code to do the following:

1. Connect to RabbitMQ.
2. Get the error queue queue.
3. Check if there are any messages in the queue.

```c#
async Task Main()
{
	// Configure logging
	Log.Logger = new LoggerConfiguration()
		.WriteTo.Console()
		.CreateLogger();

	// Fetch / configure access parameters
	var username = "test";
	var password = "test";
	var hostAddress = "localhost";
	var adminPort = 15672;
	var queueName = "EasyNetQ_Default_Error_Queue";

	Log.Information("Connecting to {Host} on Port {Port}", hostAddress, adminPort);

	// Create a management client
	var mc = new ManagementClient(new Uri($"http://{hostAddress}:{adminPort}"), username, password);
	try
	{
		// Fetch the queue form the default vHost
		var queue = await mc.GetQueueAsync("/", queueName);

		// Check if the queue has any messages
		if (queue.Messages > 0)
		{
			Log.Warning("There are {Count} error messages in the queue", queue.Messages);

			// 
			// Logic to pop and handle messages here
			//
		}
		else
		{
			Log.Information("there are no error messages in the error queue");
		}
	}
	catch (UnexpectedHttpStatusCodeException ex)
	{
		Log.Error(ex, "Could not find queue {Queue}", queueName);
	}
}
```

### TLDR

**You can programmatically check if the `EasyNetQ` error queue has any messages and handle them as appropriate.**

The code is in my GitHub.

Happy hacking!
