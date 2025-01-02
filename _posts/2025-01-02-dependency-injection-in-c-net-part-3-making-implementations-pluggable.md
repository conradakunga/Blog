---
layout: post
title: Dependency Injection In C# & .NET Part 3 - Making Implementations Pluggable
date: 2025-01-02 00:38:02 +0300
categories:
    - C#
    - .NET
    - Architecture
    - Domain Design
---

This is Part 3 of a series on Dependency Injection

- [Dependency Injection In C# & .NET Part 1 - Introduction & Basic Implementation]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation %})
- [Dependency Injection In C# & .NET Part 2 - Making Implementations Swappable]({% post_url 2025-01-01-dependency-injection-in-c-net-part-2-making-implementations-pluggable %})
- **Dependency Injection In C# & .NET Part 3 - Making Implementations Pluggable (this post)**
- [Dependency Injection In C# & .NET Part 4 - Making Implementations Hot-Pluggable]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %})

In [our last post]({% post_url 2025-01-01-dependency-injection-in-c-net-part-2-making-implementations-pluggable %}), we had largely solved the problem of choosing which sender to use. However, the challenge was that this meant **changing the DI code whenever we needed to change the provider,** commenting out the ones we didn't want and leaving the one we do.

**In this post, I am defining swappable as the ability to make a change to the application configuration without changing the source code but rather changing a configuration.**

Changing the source code whenever we need to switch providers is not a robust solution to this problem.

We can do one better here: we can **introduce a new setting** in `appsettings.json`, where we specify the provider we want to use as an application setting and have the application **read that at startup**.

First, we must define a class that stores our general settings.

```c#
public class GeneralSettings
{
    public AlertSender AlertSender { get; set; }
}
```

Next, we update our settings to add our new values.

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "GmailSettings": {
    "GmailUserName": "username",
    "GmailPassword": "password",
    "GmailPort": 4000
  },
  "Office365Settings": {
    "Key": "Office365Key"
  },
  "ZohoSettings": {
    "OrganizationID": "MyOrg",
    "SecretKey": "Secret"
  },
  "GeneralSettings": {
    "AlertSender": 2
  }
}
```

Next, we will register this new class for DI in the `Program.cs`

```c#
builder.Services.Configure<GeneralSettings>(builder.Configuration.GetSection(nameof(GeneralSettings)));
```

We will then use [manual binding / direct binding]({% post_url 2024-12-11-loading-using-application-settings %}) to read the provider from the settings **before the application starts** and then use that value to **conditionally configure the dependency injection**.

```c#
// Create an instance of the class to hold the settings
var generalSettings = new GeneralSettings();
// Bind the new class to the settings defined in the appsettings.json
builder.Configuration.GetSection(nameof(GeneralSettings)).Bind(generalSettings);
// Conditionally configure the DI depending on specified sender
switch (generalSettings.AlertSender)
{
    case AlertSender.Gmail:
        // Register our generic Gmail sender, passing our settings
        builder.Services.AddSingleton<IAlertSender>(provider =>
        {
            // Fetch the settings from the DI Container
            var settings = provider.GetService<IOptions<GmailSettings>>()!.Value;
            return new GmailAlertSender(settings.GmailPort, settings.GmailUserName,
                settings.GmailPassword);
        });
        break;
    case AlertSender.Office365:
        // Register our generic office365 sender, passing our settings
        builder.Services.AddSingleton<IAlertSender>(provider =>
        {
            // Fetch the settings from the DI Container
            var settings = provider.GetService<IOptions<Office365Settings>>()!.Value;
            return new Office365AlertSender(settings.Key);
        });
        break;
    case AlertSender.Zoho:
        // Register our generic Zoho sender, passing our settings
        builder.Services.AddSingleton<IAlertSender>(provider =>
        {
            // Fetch the settings from the DI Container
            var settings = provider.GetService<IOptions<ZohoSettings>>()!.Value;
            return new ZohoAlertSender(settings.OrganizationID, settings.SecretKey);
        });
        break;
}
```

When the application starts, only one provider is configured for injection. Thus, when the endpoint receives a request, the correct implementation is injected to process it.

This is an improvement over the previous post. When we need to change the provider, we simply **update the setting** in `appsettings.json` and **restart** the application.

In our [next post]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %}), we will look at how to have the application automatically change provider **without restarting the application**.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/Mailer). *The source code builds from first principles as outlined in this series of posts with different versions of the API demonstrating the improvements.*

Happy hacking!
