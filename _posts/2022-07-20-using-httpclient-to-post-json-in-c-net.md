---
layout: post
title: Using HttpClient To Post JSON In C# & .NET
date: 2022-07-20 17:11:42 +0300
categories:
    - C#
    - .NET
---
For a long time if you wanted to post JSON using a [HttpClient](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-6.0), you would do it like this:

```csharp
// Create the HttpClient
var client = new HttpClient();

// Set the base address to simplify maintenance & requests
client.BaseAddress = new Uri("https://localhost:5001/");

// Create an object
var person = new Person() { Names = "James Bond", DateOfBirth = new DateTime(1990, 1, 1) };

// Serialize class into JSON
var payload = JsonSerializer.Serialize(person);

// Wrap our JSON inside a StringContent object
var content = new StringContent(payload, Encoding.UTF8, "application/json")

// Post to the endpoint
var response = await client.PostAsync("Create", content);
```

The `Person` object we are submitting here is this one:

```csharp
public class Person
{
	public string Names { get; set; }
	public DateTime DateOfBirth { get; set; }
}
```

The code here relies of the fact that to do a `POST` to a [HttpClient](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.httpclient?view=net-6.0), it expects a [StringContent](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.stringcontent?view=net-6.0) object that you have to construct in advance.

This is very tedious.

Which is why you can use the extensions in the `System.Net.Http.Json` namespace to simplify this. The extension method we can employ here is [PostAsJsonAsync](https://docs.microsoft.com/en-us/dotnet/api/system.net.http.json.httpclientjsonextensions.postasjsonasync?view=net-6.0).

This extension method does the heavy lifting of accepting your object and serializing it for posting to the target URL.

This is achieved like so:


```csharp
// Create a second person
var otherPerson = new Person() { Names = "Jason Bourne", DateOfBirth = new DateTime(2000, 1, 1) };

// Post to the endpoint
response = await client.PostAsJsonAsync("Create", otherPerson);
```

The code is thus vastly simplified.

There is also an overload that allows you to pass a CancellationToken.

```csharp
// Post to the endpoint with a cancellation token
response = await client.PostAsJsonAsync("Create", otherPerson, ctx);
```

The beauty of this is that for most simple cases you can use the `HttpClient` directly and not have to depend on libraries like [Refit](https://github.com/reactiveui/refit), [RestSharp](https://restsharp.dev/) and [Flurl](https://flurl.dev/)

Happy hacking!