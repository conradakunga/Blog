---
layout: post
title: Using EasyNetQ Version 8 in C# & .NET
date: 2026-02-07 22:54:23 +0300
categories:
    - C#
    - .NET
    - RabbitMQ
    - EasyNetQ
    - StarLibrary
---

When it comes to writing scalable applications using [message queues](https://www.geeksforgeeks.org/system-design/message-queues-system-design/), my engine of choice is [RabbitMQ](https://www.rabbitmq.com/).

My library of choice for interfacing with `RabbitMQ` is [EasyNetQ](https://easynetq.com/).

After a considerable period, a new release of `EayNetQ`, version `8`, was [recently published](https://github.com/EasyNetQ/EasyNetQ/releases/tag/8.1.2), version 8.1.2 at the time of writing this.

This involved [significant changes](https://github.com/EasyNetQ/EasyNetQ/wiki/EasyNetQ-v8-Migration-Guide) to the **API** surface, **design**, and **library** integrations.

I will demonstrate the most fundamental change using two projects:

1. `Version7` that shows how the **old** library worked
2. `Version8` that shows how the **new** library works

`Version7` and `Version` 8 we create as follows:

```bash
dotnet new web -o Version7
dotnet new web -o Version8
```

In the `Version7` folder, we add the necessary packages:

```bash
dotnet add package EasyNetQ --Version 7.8.0
dotnet add package NewtonSoft.Json
```

We are adding [NewtonSoft.Json](https://www.newtonsoft.com/) as a result of an earlier change in which `EasyNetQ` unbundled the library and required it to be **explicitly added** to your code.

We set up our `appsetttings.json` as follows. to register our `RabbitMQ` connection string:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "RabbitMQ": "host=localhost;username=test;password=test"
  }
}
```

Next in the `Program.cs`, we set up the [dependency injection]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation %}).

```c#
using EasyNetQ;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddSingleton<IBus>(_ => RabbitHutch.CreateBus(builder.Configuration.GetConnectionString("RabbitMQ")));

var app = builder.Build();
```

We then register an **endpoint** to publish our message:

```c#
app.MapGet("/", async (IBus bus, ILogger<Program> logger) =>
{
    try
    {
        logger.LogInformation("Publishing message ...");

        // Publish a message
        await bus.PubSub.PublishAsync("hello");

        // Return OK
        return Results.Ok();
    }
    catch (Exception ex)
    {
        return Results.InternalServerError(ex.Message);
    }
});
```

Next, we set up the `Version8` project.

```bash
dotnet add package EasyNetQ --Version 8.2.0
```

Note, we no longer need `NewtonSoft.Json`.

Our **connection string setup** is the same as before:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "RabbitMQ": "host=localhost;username=test;password=test"
  }
}

```

Our endpoint is also the same:

```c#
app.MapGet("/", async (IBus bus, ILogger<Program> logger) =>
{
    try
    {
        logger.LogInformation("Publishing message ...");

        // Publish a message
        await bus.PubSub.PublishAsync("hello");

        // Return OK
        return Results.Ok();
    }
    catch (Exception ex)
    {
        return Results.InternalServerError(ex.Message);
    }
});
```

The big change is in the **dependency injection setup**, which looks like this:

```c#
using EasyNetQ;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEasyNetQ(builder.Configuration.GetConnectionString("RabbitMQ"));
var app = builder.Build();
```

**Dependency injection is now supported out of the box**, using a convenient extension method. You no longer need to deal with the `RabbitHutch` object.

Finally, we set up the [RabbitMQ instance](https://www.rabbitmq.com/docs/download), and, as usual, I prefer to do this via [Docker](https://www.docker.com/).

The docker-compose.yaml that I use is as follows:

```yaml
services:
  rabbitmq:
    image: rabbitmq:management-alpine
    container_name: rabbitmq
    restart: always
    volumes:
      - ./rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf
    environment:
      - TZ=Africa/Nairobi
    ports:
      - 5672:5672
      - 15672:15672
```

The rabbitmq.conf file that I use to configure the container is as follows:

```plaintext
default_user = test
default_pass = test
```

### TLDR

**The new release of `EasyNetQ` introduces breaking changes to support modern application development practices, such as dependency injection.**

The code is in my GitHub.

Happy hacking!
