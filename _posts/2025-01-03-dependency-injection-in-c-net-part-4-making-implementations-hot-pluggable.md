---
layout: post
title: Dependency Injection In C# & .NET Part 4 - Making Implementations Hot-Pluggable
date: 2025-01-03 00:00:32 +0300
categories:
    - C#
    - .NET
    - Architecture
    - Domain Design
---
This is Part 4 of a series on dependency injection.

- [Dependency Injection In C# & .NET Part 1 - Introduction & Basic Implementation]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation %})
- [Dependency Injection In C# & .NET Part 2 - Making Implementations Swappable]({% post_url 2025-01-01-dependency-injection-in-c-net-part-2-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 3 - Making Implementations Pluggable]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %})
- **Dependency Injection In C# & .NET Part 4 - Making Implementations Hot-Pluggable (this post)**
- [Dependency Injection In C# & .NET Part 5 - Making All Services Available]({% post_url 2025-01-04-dependency-injection-in-c-net-part-5-making-all-services-available %})

In our [last post,]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %}) we implemented the ability to change the provider to use by allowing the required provider to be set in the `appsettings.json` and then restarting the application.

**For purposes of this post, I am defining hot-swapping as the ability to change the configuration of the system as it is running without any downtime.**

For a vast majority of the cases, this solution is good enough. However, the slight drawback is that you have to **stop and start the application**, which potentially means **downtime**. You can mitigate this by scheduling the downtime to a less busy time (say 2 AM) and notifying users, but what if, for whatever reason, you don't want any downtime at all?

It is possible to have the ability to **change the configuration on the fly while it is running**. This is called **hot-plugging (or hot-swapping)**. 

The key to this functionality is going to be the ability to read the application configuration **every time we receive a request**. Remember, [by default]({% post_url 2024-12-11-loading-using-application-settings %}), the application settings are read **the first time they are requested and remain static until the application is shut down.

To implement this, we register with our dependency injection a singleton of [IOptionsMonitor](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.options.ioptionsmonitor-1?view=net-9.0-pp) with an implementation of [OptionsMonitor](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.options.optionsmonitor-1?view=net-9.0-pp).

```c#
builder.Services.AddSingleton<IOptionsMonitor<GeneralSettings>,OptionsMonitor<GeneralSettings>>();
```

The difference between `IOptionsMonitor` and `IOptions`, as explained, is that `IOptionsMonitor` reads the configuration **every time it is requested**. This, of course, will have some performance implications for a very busy system.

Once the DI is configured, we need to change the endpoints.

```c#
app.MapPost("/v6/SendEmergencyAlert", async ([FromBody] Alert alert,
    IOptionsMonitor<GeneralSettings> settingsMonitor, IOptions<GmailSettings> gmailOptions,
    IOptions<Office365Settings> office365Options, IOptions<ZohoSettings> zohoOptions,
    [FromServices] ILogger<Program> logger) =>
{
    var settings = settingsMonitor.CurrentValue;
    logger.LogInformation("Current Sender: {Configuration}", settings.AlertSender);
    IAlertSender mailer = null!;
    switch (settings.AlertSender)
    {
        case AlertSender.Gmail:
            var gmailSettings = gmailOptions.Value;
            mailer = new GmailAlertSender(gmailSettings.GmailPort, gmailSettings.GmailUserName,
                gmailSettings.GmailPassword);
            break;
        case AlertSender.Office365:
            var office365Settings = office365Options.Value;
            mailer = new Office365AlertSender(office365Settings.Key);
            break;
        case AlertSender.Zoho:
            var zohoSettings = zohoOptions.Value;
            mailer = new ZohoAlertSender(zohoSettings.OrganizationID, zohoSettings.SecretKey);
            break;
        default:
            throw new Exception("Configured alert sender not found");
    }

    var genericAlert = new GeneralAlert(alert.Title, alert.Message);
    await mailer.SendAlert(genericAlert);

    return Results.Ok();
});
```

If you make a request, you should see the current sender in the logs:

```plaintext
info: Program[0]
      Current Sender: Office365
```

And if you change the value in the `appsettings.config` and re-send the request, the logs should indicate the new value.

```plaintext
info: Program[0]
      Current Sender: Zoho
```

So far, so good.

However, the endpoint has gotten a bit more complicated.

1. We inject the `IOptionsMonitor<GeneralSettings>`
2. We also have to **inject all the options** for all the senders - `IOptions<GmailSettings>`,
        `IOptions<Office365Settings>`, `IOptions<ZohoSettings>` - as we will need them to instantiate and use the appropriate senders.
3. Within the endpoint, we will need to **manually create the appropriate senders** - `GmailAlertSender`, `Office365AlertSender` and `ZohoAlertSender`, depending on the sender configured in the `GeneralSettings`

Though functional, this endpoint will be difficult to test and maintain.

There is, naturally, a solution to this problem that still utilizes dependency injection. Rather than creating the `AlertSender` ourselves, we can create a class that will be responsible for creating the `AlertSender` for us. This is called a **factory**. All we need to tell the factory is what class we want, and it will retrieve it from us from the DI.

First, we create an interface for the factory.

```c#
public interface IAlertSenderFactory
{
    public IAlertSender CreateAlertSender(AlertSender alertSender);
}
```

You will see here it has a single method, `CreateAlertSender`, that returns an `IAlertSender`.

Next, we create an **implementation** of this interface.

```c#
public class AlertSenderFactory : IAlertSenderFactory
{
    private readonly IServiceProvider _serviceProvider;

    public AlertSenderFactory(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public IAlertSender CreateAlertSender(AlertSender alertSender)
    {
        return alertSender switch
        {
            // Retrieve GmailSender from ID
            AlertSender.Gmail => _serviceProvider.GetRequiredService<GmailAlertSender>(),
            // Retrieve Office365 from ID
            AlertSender.Office365 => _serviceProvider.GetRequiredService<Office365AlertSender>(),
            // Retrieve ZohoSender from ID
            AlertSender.Zoho => _serviceProvider.GetRequiredService<ZohoAlertSender>(),
            _ => throw new ArgumentOutOfRangeException(nameof(alertSender), alertSender, null)
        };
    }
}
```

A couple of things to note:

1. This class takes in its constructor a [ServiceProvider](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.serviceprovider?view=net-9.0-pp). The .NET DI engine uses this to create and manage the DI container.
2. Our method `CreateAlertSender` simply retrieves the appropriate `AlertSender` based on the passed enum.

Next, we register the factory with our DI

```c#
// Add support for an AlertSender factory
builder.Services.AddSingleton<IAlertSenderFactory, AlertSenderFactory>();
```

Finally, we update our endpoint to inject the factory and then use that factory to create the appropriate sender based on our configuration.

```c#
app.MapPost("/v7/SendEmergencyAlert", async ([FromBody] Alert alert,
    IOptionsMonitor<GeneralSettings> settingsMonitor, [FromServices] IAlertSenderFactory factory,
    [FromServices] ILogger<Program> logger) =>
{
    var settings = settingsMonitor.CurrentValue;
    logger.LogInformation("Current Sender: {Configuration}", settings.AlertSender);
    // Create a mailer using the injected factory
    var mailer = factory.CreateAlertSender(settings.AlertSender);
    var genericAlert = new GeneralAlert(alert.Title, alert.Message);
    await mailer.SendAlert(genericAlert);

    return Results.Ok();
});
```

At this point, many purists will object to the factory as an **anti-pattern**, but I try to avoid such debates. This code does what it says on the tin and is easy to read and modify. It, of course, has pros and cons, but you are placed to decide if it works for you.

You can **avoid the factory altogether and leverage DI directly** in the endpoint. Like this:

```c#
app.MapPost("/v8/SendEmergencyAlert", async ([FromBody] Alert alert,
    IOptionsMonitor<GeneralSettings> settingsMonitor, IServiceProvider provider,
    [FromServices] ILogger<Program> logger) =>
{
    var settings = settingsMonitor.CurrentValue;
    logger.LogInformation("Current Sender: {Configuration}", settings.AlertSender);
    // Retrieve sender from DI 
    IAlertSender mailer = settings.AlertSender switch
    {
        AlertSender.Gmail => provider.GetRequiredService<GmailAlertSender>(),
        AlertSender.Office365 => provider.GetRequiredService<Office365AlertSender>(),
        AlertSender.Zoho => provider.GetRequiredService<ZohoAlertSender>(),
        _ => throw new ArgumentException("Unsupported alert sender selected")
    };
    var genericAlert = new GeneralAlert(alert.Title, alert.Message);
    await mailer.SendAlert(genericAlert);

    return Results.Ok();
});
```

Another way you can achieve this is to use dependency injection [keyed services](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.fromkeyedservicesattribute?view=net-9.0-pp).

Keyed services allow you to register services and refer to them using a **key**. The key is usually a string, but you can make anything a key—provided it is **unique**.

For example, we can use the `AlertSender` enum as a key for DI and register the services like this:

```c#
// Register GmailAlertSender as a keyed singleton
builder.Services.AddKeyedSingleton<IAlertSender, GmailAlertSender>(AlertSender.Gmail, (provider, _) =>
{
    var settings = provider.GetRequiredService<IOptions<GmailSettings>>().Value;
    return new GmailAlertSender(settings.GmailPort, settings.GmailUserName, settings.GmailPassword);
});

// Register Office365AlertSender as a keyed singleton
builder.Services.AddKeyedSingleton<IAlertSender, Office365AlertSender>(AlertSender.Office365, (provider, _) =>
{
    var settings = provider.GetRequiredService<IOptions<Office365Settings>>().Value;
    return new Office365AlertSender(settings.Key);
});

// Register ZohoAlertSender as a keyed singleton
builder.Services.AddKeyedSingleton<IAlertSender, ZohoAlertSender>(AlertSender.Zoho, (provider, _) =>
{
    var settings = provider.GetRequiredService<IOptions<ZohoSettings>>().Value;
    return new ZohoAlertSender(settings.OrganizationID, settings.SecretKey);
});
```

We then update our endpoint to inject a ServiceProvider, from which we can retrieve our services by key from the DI container..

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
    await mailer.SendAlert(genericAlert);

    return Results.Ok();
})
```

We can simplify this even further by making use of the fact that the `KeyedServices` is a `dictionary` and make use of that in the injection.

The magic is taking place here:

```c#
 var mailer = provider.GetRequiredKeyedService<IAlertSender>(settings.AlertSender);
```

We are passing the eky (in this case the enum) to the generic [GetRequiredKeyedService](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.dependencyinjection.serviceproviderkeyedserviceextensions.getrequiredkeyedservice?view=net-9.0-pp) method so that the container will return the correct service for us.

Thus, you can see we have **several options** if we want to dynamically change the provider without restarting the application. **The best option for you will depend on your needs and constraints.**

Personally, I would lean on the **keyed services approach**.

In the [next post]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %}) we will look at additional improvements - if we needed to use ALL the providers, or if we had logic within the endpoint that determined which prioviders to use.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/Mailer). *The source code builds from first principles as outlined in this series of posts with different versions of the API demonstrating the improvements.*

Happy hacking!
