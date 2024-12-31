---
layout: post
title: Dependency Injection In C# & .NET Part 1 - Introduction & Basic Implementation
date: 2024-12-31 17:57:32 +0300
categories:
    - C#
    - .NET
    - Domain Design
---

Unless you have been living under a rock, you cannot have escaped coming across the term "**dependency injection**" or **DI**. But what really is it?

In this series of posts, we shall build out an explanation for this with an example to illustrate the various ideas and concepts and how to implement them. And then at the end, we can see what it is, what problems it solves and how to use it in your applications.

Suppose we have an alerting system that we expose via an API.

Our alerting system uses Google Email ([Gmail](https://www.gmail.com)) to send either a warning or an information message.

Our first step is to build the class responsible for sending the email and its supporting types. (This class has dummy functionality to simplify this post).

The first type is a `GmailAlert`.

```csharp
public record GmailAlert(string Title, string Body);
```

The class responsible for sending the alerts is the `GmailAlertSender`.

```c#
public sealed class GmailAlertSender
{
    private int _port;
    private string _username;
    private string _password;

    public GmailAlertSender(int port, string username, string password)
    {
        _port = port;
        _username = username;
        _password = password;
    }

    public async Task<string> SendAlert(GmailAlert message)
    {
        await Task.Delay(TimeSpan.FromSeconds(5));
        return Guid.NewGuid().ToString();
    }
}
```

In a real-world scenario, this class would be responsible for connecting to and authenticating to Gmail and then actually sending the message, but here, we simulate work by waiting 5 seconds and then returning an identifier.

Finally, we have a simple API with two endpoints - one to send normal alerts and the other to send emergency alerts. Both of these use the `GmailAlertSender` class we have defined above.

```c#
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapPost("/v1/SendGmailNormalAlert", async (Alert alert) =>
{
    var mailer =
        new GmailAlertSender(400, "username", "password");
    var gmailAlert = new GmailAlert(alert.Title, alert.Message);
    var alertID = await mailer.SendAlert(gmailAlert);
    return Results.Ok(alertID);
});

app.MapPost("/v1/SendGmailEmergencyAlert", async (Alert alert) =>
{
    var mailer =
        new GmailAlertSender(400, "username", "password");
    var gmailAlert = new GmailAlert(alert.Title, alert.Message);
    var alertID = await mailer.SendAlert(gmailAlert);
    return Results.Ok(alertID);
});

app.Run();
```

There are a couple of problems with this code.

1. The `port`, `username` and `password` are **hard coded** into the endpoints, which means if they change, **all the endpoints must be updated**.
2. The endpoints all need to know:
    1. **How** to create a `GmailAlertSender`
    2. What **parameters** it requires
3. The code to create a GmailSender is repeated on every endpoint.

Let us start with the first.

The obvious solution to this problem is if, in some way, we can pass the parameters to the endpoints so that they no longer need to know them.

Perhaps when the API starts, we can read the settings from some sort of configuration file and then have them available to any API that requires them.

This presents an additional challenge - there are very many ways that configuration data can be stored:

- JSON configuration
- XML Configuration
- Custom files
- Environment variables
- Databases

This is such a common problem that .NET applications have come up with a service that we can leverage to make loading of settings and their use largely **abstracted away** from the application. You can read about it [here](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/configuration/options?view=aspnetcore-9.0) or in a [previous post where I touched on this]({% post_url 2024-12-11-loading-using-application-settings %}), but we shall step by step implement this in our API.

The first step is to come up with a class that will store our settings.

This class must have **public**, **writable** properties, as the configuration engine **sets** them.

```c#
public class Settings
{
    public string GmailUserName { get; set; } = "";
    public string GmailPassword { get; set; } = "";
    public int GmailPort { get; set; }
}
```

The next step is to create the settings. In most .NET applications, settings are stored in a file named `appsettings.json,` which has all the application settings in `JSON` format

We can modify this to add our settings. The default settings file looks like this:

```c#

  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

We can add our own settings to the bottom, like this:

```c#

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
    "Port": 4000
  }
}
```

The next step is to plug into the configuration mechanism and tell our application **what** settings we are interested in and **where** to load them.

The startup looks like this

```c#
var builder = WebApplication.CreateBuilder(args);
builder.Services.Configure<Settings>(builder.Configuration.GetSection(nameof(Settings)));
var app = builder.Build();
```

The code `nameof(Settings)` merely returns the string "**Settings**". It is good practice to avoid hard-coding strings because if you supply the string directly and later decide to rename the settings to `GmailSettings`, you will almost certainly **forget to change the string** in the startup code.

We add this new line just after creating the builder.

```c#
builder.Services.Configure<Settings>(builder.Configuration.GetSection(nameof(Settings)));
```

This code essentially instructs the application as follows:

- Wherever the settings are stored, look for a section named **Settings**
- Load those values into a class of type `Settings`
- **When asked**, provide said values to whoever asked for them


The code now looks like this:

```c#
var builder = WebApplication.CreateBuilder(args);
builder.Services.Configure<Settings>(builder.Configuration.GetSection(nameof(Settings)));
var app = builder.Build();
```

Finally, we update our endpoints to indicate that we are passing to them something that they will use to retrieve the settings.

```c#
app.MapPost("/v2/SendGmailNormalAlert", async (Alert alert, IOptions<Settings> settings) =>
{
    var gmailSettings = settings.Value;
    var mailer =
        new GmailAlertSender(gmailSettings.GmailPort, gmailSettings.GmailUserName, gmailSettings.GmailPassword);
    var gmailAlert = new GmailAlert(alert.Title, alert.Message);
    var alertID = await mailer.SendAlert(gmailAlert);
    return Results.Ok(alertID);
});

app.MapPost("/v2/SendGmailEmergencyAlert", async (Alert alert, IOptions<Settings> settings) =>
{
    var gmailSettings = settings.Value;
    var mailer =
        new GmailAlertSender(gmailSettings.GmailPort, gmailSettings.GmailUserName, gmailSettings.GmailPassword);
    var gmailAlert = new GmailAlert(alert.Title, alert.Message);
    var alertID = await mailer.SendAlert(gmailAlert);
    return Results.Ok(alertID);
});
```

There are two important points:

1. The parameter `IOptions<Settings> settings` that we are passing isn't, in fact, the `Settings` class, as you might expect. It is actually a generic interface of [IOptions](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.options.ioptions-1?view=net-9.0-pp), for which `Settings` is the type we are passing.
2. To get the actual `Settings`, we access the `Value` property of this parameter.

Why, you might ask, do it this way? Wouldn't it be simpler to pass the `Settings` directly? The main reason is that while, in most cases, settings are loaded once and remain static until the application is reloaded, it is possible to have a situation where you want `Settings` to be loaded **each time** an API is accessed or a service is requested. Having the `Settings` passed as a class would not work here. But the .NET configuration mechanism supports this, and so in such a situation it will read the `Settings` from storage again.

**At this point, we have implemented *dependency injection* for our settings.**

The API does not know the parameters for the `GmailAlertSender`, where to get them, or how to load them. We have injected this infrastructure and responsibility into the endpoint, including **how** and, by extension, **where** to get the settings.

Can we extend this knowledge to inject a `GmailAlertSender`?

In the words of Barack Obama - **yes, we can**.

We will have to do some extra work in the startup

1. Load the Settings
2. Register our `GmailAlertSender`

I have talked about loading settings in the post [Loading & Using Application Settings In .NET]({% post_url 2024-12-11-loading-using-application-settings %})

We achieve this as follows:

```csharp
// Declare our class and bind it to the settings
var appSettings = new Settings();
builder.Configuration.GetSection(nameof(Settings)).Bind(appSettings);
// Register our GmailSender, passing our settings
builder.Services.AddSingleton(new GmailAlertSender(appSettings.GmailPort, appSettings.GmailUserName,
    appSettings.GmailPassword));
```

Finally, we update our API endpoints to inform them that we are injecting our `GmailAlertSender`

```c#
app.MapPost("/v3/SendGmailNormalAlert", async (Alert alert, GmailAlertSender mailer) =>
{
    var gmailAlert = new GmailAlert(alert.Title, alert.Message);
    var alertID = await mailer.SendAlert(gmailAlert);
    return Results.Ok(alertID);
});

app.MapPost("/v3/SendGmailEmergencyAlert", async (Alert alert, GmailAlertSender mailer) =>
{
    var gmailAlert = new GmailAlert(alert.Title, alert.Message);
    var alertID = await mailer.SendAlert(gmailAlert);
    return Results.Ok(alertID);
})
```

A couple of things to point out:

1. We are **no longer injecting the settings**. We don't need to, as the `GmailAlertSender` is already preconfigured and ready to go.
2. The **code** in the controllers is **less**
3. If we need to extend the `GmailAlertSender`, we can do so **without the APIs having to know anything about it**.

Given this method signature:

```c#
app.MapPost("/v3/SendGmailEmergencyAlert", async (Alert alert, GmailAlertSender mailer) =>
```

You might wonder - how does the runtime know where to find the `Alert` and where to find the `GmailAlertSender`?

You would be right to wonder. Technically, the correct way to do this is to tell the runtime where to retrieve these parameters explicitly. The code should actually look like this:

```c#
app.MapPost("/v3/SendGmailEmergencyAlert", async ([FromBody] Alert alert, [FromServices] GmailAlertSender mailer) 
```

`[FromBody]` here tells the runtime to retrieve the `Alert` from the [body of the request](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.frombodyattribute?view=aspnetcore-9.0). Typically, this would be in JSON or XML. `[FromServices]` means retrieve from the [services that have been registered](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.fromservicesattribute?view=aspnetcore-9.0) with the application. You can also bind from a [Form](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.fromformattribute?view=aspnetcore-9.0), [QueryString](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.fromqueryattribute?view=aspnetcore-9.0), [Route](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.fromrouteattribute?view=aspnetcore-9.0) or [Header](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.mvc.fromheaderattribute?view=aspnetcore-9.0).

To make life simpler, whenever an endpoint is invoked, the runtime scans all these sources and binds them to the specified types as soon as a match is found. **It is probably better to be explicit and decorate the parameters with the appropriate attribute.**

This is all held together by what is called a **dependency injection container**. From .NET Core 1, one has been built into the applications (specifically Web and API applications, but it was also available in the console and services if you did some extra work).

If you don't want to use the .NET built-in DI container, there are alternatives like [AutoFac](https://autofac.org/) and [Lamar](https://jasperfx.github.io/lamar/).

In the next post, we will explore how to extend this even further to quickly adapt applications to changing business, technology, and environmental needs.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/Mailer).

Happy hacking!