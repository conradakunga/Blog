---
layout: post
title: Writing Minimal APIs For HEAD Requests
date: 2024-12-09 21:20:08 +0300
categories:
    - C#
    - ASP.NET
    - Minimal API
---

Using [Minimal APIs](https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis?view=aspnetcore-9.0) it is usually pretty straightforward to build API end points to tackle most scenarios.

For our example let us use this simple problem domain:

```csharp
public sealed record Spy(Guid ID, string Name, DateOnly DateOfBirth);

public sealed record CreateSpyRequest(string Name, DateOnly DateOfBirth);

public sealed record UpdateSpyRequest(Guid ID, string Name, DateOnly DateOfBirth);
```

Building endpoints for `GET`, `POST`, `PUT` and `DELETE` verbs is as follows:

```csharp
// List all spies
app.MapGet("/Spies", () =>
{
    // Fetch all spies from the database
    return Results.Ok(spies);
});

// Get a spy by ID
app.MapGet("/Spies/{id:guid}", (Guid id) =>
{
    //Fetch requested spy from database
    var spy = spies.SingleOrDefault(x => x.ID == id);
    if (spy is null)
        return Results.NotFound();
    return Results.Ok(spy);
});

// Create a spy
app.MapPost("/Spies", (CreateSpyRequest request) =>
{
    //Create a spy
    var spy = new Spy(Guid.NewGuid(), request.Name, request.DateOfBirth);
    // Add to database
    spies.Add(spy);
    return Results.Created($"/Spies/{spy.ID}", spy);
});

// Update a spy's details
app.MapPut("/Spies", (UpdateSpyRequest request) =>
{
    //Fetch spy from database
    var spy = spies.SingleOrDefault(x => x.ID == request.ID);
    if (spy is null)
        return Results.NotFound();
    spies.Remove(spy);
    var updatedSpy = spy with { Name = request.Name, DateOfBirth = request.DateOfBirth };
    spies.Add(updatedSpy);
    return Results.NoContent();
});

// Delete a spy
app.MapDelete("/Spies/{id:guid}", (Guid id) =>
{
		// Fetch the spy from the database
    var spy = spies.SingleOrDefault(x => x.ID == id);
    if (spy is null)
        return Results.NotFound();
    spies.Remove(spy);
    return Results.NoContent();
});
```

In this example there is no database - we are using a simple in memory list.

In such a scenario we might want to implement a `HEAD` request as a way to quickly and cheaply check if a `Spy` exists.

Our first problem is that there is no `app.MapHead()` method.

But this has been addressed using the [MapMethods](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.builder.endpointroutebuilderextensions.mapmethods?view=aspnetcore-9.0) method, where we can specify the verb to implement.

The endpoint will look like this:

```csharp
// HEAD request to check for existence
app.MapMethods("/Spies/{id:guid}", [HttpMethod.Head.Method], (Guid id) =>
{
    // Query the database for existence of the spy by ID
    if (spies.Any(x => x.ID == id))
        return Results.Ok();
    return Results.NotFound();
});
```

Of interest is this line:

```csharp
app.MapMethods("/Spies/{id:guid}", [HttpMethod.Head.Method], (Guid id) =>
```

Which can be rewritten thus:

```csharp
app.MapMethods("/Spies/{id:guid}", ["HEAD"], (Guid id) =>
```

We are using `HttpMethod.Head.Method` rather than specifying *HEAD* directly because it is good practice to avoid ["stringly typed objects"](https://wiki.c2.com/?StringlyTyped).

Or, if you are using a version of C# that does not support [collection expressions](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-12.0/collection-expressions) (Pre C# 12)

```csharp
app.MapMethods("/Spies/{id:guid}", new string[] { "HEAD"}, (Guid id) =>
```

What is the benefit of a [HEAD](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/HEAD) request over and above just fetching the object and returning the object or a [404](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404) if it wasn't found?

1. Sometimes you just want to check if the object exists for some conditional logic - in which case there is no reason to hydrate the entire object from the database, especially if it is a complex object like an `Invoice` that will require loading a collection of `InvoiceLineItem` and the `Customer`
2. It might be expensive to hydrate and load an object from the database
3. Since `HEAD` requests do not typically return a body, the payload being returned is much smaller. This makes your API performant when there is potential heavy load.
4. Makes it easier for your API consumers to be able to quickly and cheaply check for existence of entities before performing operations.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2024-12-09%20-%20HEAD%20Requests%20With%20Minimal%20APIs).

Happy hacking!