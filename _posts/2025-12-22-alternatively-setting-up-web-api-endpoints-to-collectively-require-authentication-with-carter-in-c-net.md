---
layout: post
title: Alternatively Setting Up Web API Endpoints To Collectively Require Authentication With Carter In C# & .NET
date: 2025-12-22 16:00:16 +0300
categories:
    - C#
    - ASP.NET
    - Security
    - Carter
---

Our last post, "[Setting Up Web API Endpoints To Collectively Require Authentication With Carter In C# & .NET]({% post_url 2025-12-21-setting-up-web-api-endpoints-to-collectively-require-authentication-with-carter-in-c-net %})", looked at how to set up all your [ASP.NET](https://dotnet.microsoft.com/en-us/apps/aspnet) Web API endpoints to require **authorization** when using the [Carter](https://github.com/CarterCommunity/Carter) package.

The workflow I prescribed there works when you set up **each of your endpoints as independent module**s.

In our example, we had an `Add` **module** that looked like this:

```c#
public class AddModule : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        app.MapGet("/Add", () => "Add");
    }
}
```

We also had a `Subtract` **module**, that looked like this:

```c#
public class SubtractModule : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        app.MapGet("/Subtract", () => "Subtract");
    }
}
```

Here you can see each **module** is maintained in its **own class** (and probably own file).

This is what I prefer for various reasons:

1. Easier to **maintain** as your application grows.
2. Adding functionality does not **interfere with existing code**.

You can, however, map all your **endpoints** from within a **single** module.

The program setup would look like this:

```c#
using Carter;
using Microsoft.AspNetCore.Authentication.JwtBearer;

var builder = WebApplication.CreateBuilder(args);
// Authentication - the exact scheme does not matter for this example!
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.Authority = "https://fake-provider.com";
        options.Audience = "api";
    });
builder.Services.AddAuthorization();
builder.Services.AddCarter();

var app = builder.Build();
// Create a default group and require authentication on it
app.MapCarter();

app.UseAuthentication();
app.UseAuthorization();

app.Run();
```

Here, we can see we are calling `MapCarter()` directly on the [WebApplication](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.builder.webapplication?view=aspnetcore-10.0) object.

Next, we implement  a single `ICarterModule` and configure it as follows:

```c#
using Carter;

namespace CarterGrouped;

public class Modules : ICarterModule
{
    public void AddRoutes(IEndpointRouteBuilder app)
    {
        // Configure authorization
        var secured = app.MapGroup("").RequireAuthorization();

        // Add module
        secured.MapGet("/Add", () => "Add");
        // Subtract module
        secured.MapGet("/Subtract", () => "Subtract");
    }
}
```

Here we can see a couple of things:

1. The first thing is we are calling `MapGroup()` on the `IEndpointRouteBuilder` object, `app`, and creating a new [RouteGroupBuilder](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.routing.routegroupbuilder?view=aspnetcore-10.0).
2. The new object, `secured`, is what we then proceed to use to **map our endpoints**.

If we invoke our endpoints now, we should get [401](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/401) errors for each.

![CarterAdd](../images/2025/12/CarterAdd.png)

![CarterSubtract](../images/2025/12/CarterSubtract.png)

Much as you can use a **single module** to map **multiple endpoints**, I strongly **discourage** this approach as it makes **maintenance**, **refactoring** and **collaboration** that much more **difficult**.

### TLDR

**You can use a single `Carter` module to map your endpoints, and from within that module, create and configure them collectively.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-12-22%20-%20CarterGrouped).

Happy hacking!
