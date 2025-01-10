---
layout: post
title: Dependency Injection In C# & .NET Part 6 - Implementation Testing
date: 2025-01-05 21:13:23 +0300
categories:
    - C#
    - .NET
    - Architecture
    - Domain Design
---
This is Part 6 of a series on dependency injection.

- [Dependency Injection In C# & .NET Part 1 - Introduction & Basic Implementation]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation %})
- [Dependency Injection In C# & .NET Part 2 - Making Implementations Swappable]({% post_url 2025-01-01-dependency-injection-in-c-net-part-2-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 3 - Making Implementations Pluggable]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 4 - Making Implementations Hot-Pluggable]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %})
- [Dependency Injection In C# & .NET Part 5 - Making All Implementations Available]({% post_url 2025-01-04-dependency-injection-in-c-net-part-5-making-all-services-available %})
- **Dependency Injection In C# & .NET Part 6 - Implementation Testing (this post)**
- [Dependency Injection In C# & .NET Part 7 - Integration Testing]({% post_url 2025-01-06-dependency-injection-in-c-net-part-7-integration-testing %})
- [Dependency Injection In C# & .NET Part 8 - Types Of Dependency Injection]({% post_url 2025-01-07-dependency-injection-in-c-net-part-8-types-of-depedency-injection %})
- [Dependency Injection In C# & .NET Part 9 - Life Cycles]({% post_url 2025-01-08-dependency-injection-in-c-net-part-9-life-cycles %})
- [Dependency Injection In C# & .NET Part 10 - Conclusion]({% post_url 2025-01-09-dependency-injection-in-c-net-part-10-conclusion %})

In our [last post]({% post_url 2025-01-04-dependency-injection-in-c-net-part-5-making-all-services-available %}), we saw how we can leverage dependency injection to allow **all our service implementations to be available** for use, in order to implement some business logic.

In this post, we will examine how dependency injection can help with testing.

To recap, we have 3 `AlertSenders`:

`GmailAlertSender` that looks like this:

```c#
public sealed class GmailAlertSender : IAlertSender
{
    private readonly int _port;
    private readonly string _username;
    private readonly string _password;
    public string Configuration { get; }

    public GmailAlertSender(int port, string username, string password)
    {
        _port = port;
        _username = username;
        _password = password;
        Configuration = $"Configuration - Port: {_port}; Username: {_username}; Password: {_password}";
    }

    public async Task<string> SendAlert(GmailAlert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }

    // New method that sends a generic GeneralAlert
    public async Task<string> SendAlert(GeneralAlert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }
}


```

`Office365AlertSender` that looks like this:

```c#
public sealed class Office365AlertSender : IAlertSender
{
    private readonly string _key;
    public string Configuration { get; }

    public Office365AlertSender(string key)
    {
        _key = key;
        Configuration = $"Configuration - Key: {_key}";
    }

    public async Task<string> SendAlert(Office365Alert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }

    // New method that sends a generic GeneralAlert
    public async Task<string> SendAlert(GeneralAlert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }
}
```

And the `ZohoAlertSender` that looks like this:

```c#
public sealed class ZohoAlertSender : IAlertSender
{
    private readonly string _organizationID;
    private readonly string _secretKey;
    public string Configuration { get; }

    public ZohoAlertSender(string organizationID, string secretKey)
    {
        _organizationID = organizationID;
        _secretKey = secretKey;
        Configuration = $"Configuration - Organization ID: {_organizationID}, secretKey: {_secretKey}";
    }
    public async Task<string> SendAlert(GeneralAlert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }
}
```

These are simple dummy implementations but assume they were operational. Sending an alert would require:

1. **Network** access
2. **Internet** access
3. Actual working **accounts** with Google, Office365 and Zoho
4. Some sort of **usage quota** with the providers
5. Some sort of **subscription that costs actual **money**

This is to say, invoking those endpoints has **implications** in terms of resources, time and money.

This complicates things if you need to run tests to ensure the system functions correctly.

There are several schools of thought on how to test this scenario. This is one of those debates that are very **polarizing** due to strong opinions. As always, I prefer a pragmatic approach.

Personally, I would approach this as follows.

Let us take the `GmailSender` as the implementation we want to test.

The rationale is as follows: there will be two implementations of the `GmailSender` - a real (functional one for use in production) and a fake one (quasi-functional for use in testing).

To leverage dependency injection, we will start by defining a contract for both by use of a [marker interface](https://www.codeguru.co.in/2023/05/marker-interfaces-in-c.html), `IGmailAlertSender`. A marker interface is one that has **no methods or properties**.

```c#
public interface IGmailAlertSender;
```

The real implementation and the fake implementation will implement this interface.

Given that we also want this interface to implement the contract for all `AlertSenders`, we will next inherit from the `IAlertSender` interface.

```c#
public interface IGmailAlertSender : IAlertSender;
```

We then change our `GmailAlertSender` to implement this new interface rather than the `IAlertSender`.

It now looks like this:

```c#
public sealed class GmailAlertSender : IGmailAlertSender
{
    private readonly int _port;
    private readonly string _username;
    private readonly string _password;
    public string Configuration { get; }

    public GmailAlertSender(int port, string username, string password)
    {
        _port = port;
        _username = username;
        _password = password;
        Configuration = $"Configuration - Port: {_port}; Username: {_username}; Password: {_password}";
    }

    public async Task<string> SendAlert(GmailAlert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }

    // New method that sends a generic GeneralAlert
    public async Task<string> SendAlert(GeneralAlert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }
}
```

Finally, we implement a fake implementation of the `GmailAlertSender`, the `FakeGmailAlertSender`.

```c#
using Serilog;
public sealed class FakeGmailAlertSender : IGmailAlertSender
{
    private readonly int _port;
    private readonly string _username;
    private readonly string _password;
    public string Configuration { get; }

    public FakeGmailAlertSender(int port, string username, string password)
    {
        _port = port;
        _username = username;
        _password = password;
        Configuration = $"FAKE - Configuration - Port: {_port}; Username: {_username}; Password: {_password}";
    }

    public Task<string> SendAlert(GeneralAlert message)
    {
        Log.Information("FAKE sending alert - {Title} : {Body}", message.Title, message.Message);
        return Task.FromResult(Guid.NewGuid().ToString());
    }
```

For testing purposes, we have directly added logging to the implementation through the [Serilog](https://www.nuget.org/profiles/serilog) library.

Now, we have two implementations of the Gmail alert sender - `GmailAlertSender` (the real one) and `FakeGmailAlertSender` (the fake one).

Now, we turn our attention to the API.

The first change to make is to register `Serilog` as the logger. We do this as follows:

1. Install the [Serilog.AspNetCore](https://www.nuget.org/packages/Serilog.AspNetCore) library
2. Register `Serilog` with the DI container. 

Yes, as you can tell by now ASP.NET core internally also heavily uses DI!

```c#
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

var builder = WebApplication.CreateBuilder(args);
// Register serilog
builder.Services.AddSerilog();
```

Next, we plug in the version of the `GmailAlertSender` we want into the DI.

```c#
// Register GmailAlert sender that can have swapped implementations
builder.Services.AddSingleton<IGmailAlertSender, FakeGmailAlertSender>(provider =>
{
    var settings = provider.GetRequiredService<IOptions<GmailSettings>>().Value;
    return new FakeGmailAlertSender(settings.GmailPort, settings.GmailUserName, settings.GmailPassword);
});
```

Finally, we update our endpoint for injection.

```c#
app.MapPost("/v12/SendEmergencyAlert", async ([FromBody] Alert alert,
    IServiceProvider provider, [FromServices] ILogger<Program> logger) =>
{
    var genericAlert = new GeneralAlert(alert.Title, alert.Message);
    var gmailAlertSender = provider.GetRequiredService<IGmailAlertSender>();
    var result = await gmailAlertSender.SendAlert(genericAlert);
    return Results.Ok(result);
});
```

If we hit the endpoint, the logs will look like this:

```plaintext
[23:11:08 INF] Request starting HTTP/1.1 POST http://localhost:5242/v12/SendEmergencyAlert - application/json 69
[23:11:08 INF] Executing endpoint 'HTTP: POST /v12/SendEmergencyAlert'
[23:11:08 INF] FAKE sending alert - Emergency : Levels have reached critical
[23:11:08 INF] Setting HTTP status code 200.
[23:11:08 INF] Writing value of type 'String' as Json.
[23:11:08 INF] Executed endpoint 'HTTP: POST /v12/SendEmergencyAlert'
[23:11:08 INF] Request finished HTTP/1.1 POST http://localhost:5242/v12/SendEmergencyAlert - 200 null application/json; charset=utf-8 57.2874ms
```

We can see on line 3 that our fake implementation is the one being called.

At this point, you might ask - we have registered an `IGmailAlertSender` service and specified a return of either `GmailAlertSender` or `FakeGmailAlertSender`. What happens if we request an `IAlertSender` service from an endpoint? Would that still work?

**Yes**. We can update our keyed service registration that looks like this:

```c#
// Register GmailAlert sender that can have swapped implementations
builder.Services.AddSingleton<IAlertSender, FakeGmailAlertSender>(provider =>
{
    var settings = provider.GetRequiredService<IOptions<GmailSettings>>().Value;
    return new FakeGmailAlertSender(settings.GmailPort, settings.GmailUserName, settings.GmailPassword);
});
```

to now look like this: registering an `IGmailAlertSender` rather than an `IAlertSender`

```c#
// Register GmailAlert sender that can have swapped implementations
builder.Services.AddSingleton<IGmailAlertSender, FakeGmailAlertSender>(provider =>
{
    var settings = provider.GetRequiredService<IOptions<GmailSettings>>().Value;
    return new FakeGmailAlertSender(settings.GmailPort, settings.GmailUserName, settings.GmailPassword);
});
```

Our endpoint, however, will remain the same, resolving an `IAlertSender`

```c#
app.MapPost("/v9/SendEmergencyAlert", async ([FromBody] Alert alert,
    IOptionsMonitor<GeneralSettings> settingsMonitor, IServiceProvider provider,
    [FromServices] ILogger<Program> logger) =>
{
    var settings = settingsMonitor.CurrentValue;
    logger.LogInformation("Current Sender: {Configuration}", settings.AlertSender);
    // Retrieve sender from DI 
    var mailer = provider.GetRequiredKeyedService<IAlertSender>(settings.AlertSender);
    var genericAlert = new GeneralAlert(alert.Title, alert.Message);
    var result = await mailer.SendAlert(genericAlert);
    return Results.Ok(result);
});
```

Will this still work?

Yes. Our code will still run correctly, given the `IGmailAlertSender` inherits from `IAlertSender`:

```plaintext
[23:17:18 INF] Request starting HTTP/1.1 POST http://localhost:5242/v9/SendEmergencyAlert - application/json 69
[23:17:18 INF] Executing endpoint 'HTTP: POST /v9/SendEmergencyAlert'
[23:17:18 INF] Current Sender: Gmail
[23:17:18 INF] FAKE sending alert - Emergency : Levels have reached critical
[23:17:18 INF] Setting HTTP status code 200.
[23:17:18 INF] Writing value of type 'String' as Json.
[23:17:18 INF] Executed endpoint 'HTTP: POST /v9/SendEmergencyAlert'
[23:17:18 INF] Request finished HTTP/1.1 POST http://localhost:5242/v9/SendEmergencyAlert - 200 null application/json; charset=utf-8 34.2251ms
```

The reason we have gone to all the trouble to create a new interface, `IGmailAlertSender` and had two implementations to that is that not only do we want to implement a fake implementation, but that fake implementation **needs to be compatible** with the real implementation of the service we are interested in.

In other words, we cannot swap a `FakeGmailAlertSender` with a `FakeOffice365AlertSender`—the compiler will raise a compile error because they are not compatible. `FakeOffice365AlertSender` does not implement the `IGmailAlertSender` interface. However, we can safely swap `FakeGmailAlertSender` with `GmailAlertSender`.

The class `FakeGmailAlertSender` is called a **fake** in the test parley.

In our [next post]({% post_url 2025-01-06-dependency-injection-in-c-net-part-7-integration-testing %}), we will look at how to leverage dependency injection for **integration testing** so that we don't need to change our application code for testing purposes.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/Mailer). *The source code builds from first principles as outlined in this series of posts with different versions of the API demonstrating the improvements.*

Happy hacking!