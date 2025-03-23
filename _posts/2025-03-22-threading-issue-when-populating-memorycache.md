---
layout: post
title: Threading Issue When Populating MemoryCache
date: 2025-03-22 05:29:02 +0300
categories:
    - C#
    - MemoryCache
---

The [MemoryCache](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.caching.memory?view=net-9.0-pp) is a lightweight, simple cache you can use in most applications to **cache data** and **improve** your application **performance**.

You would typically use it like this:

First, add the [Microsoft.Extensions.Caching.Memory](https://www.nuget.org/packages/microsoft.extensions.caching.memory/) library to your project.

```bash
dotnet add package Microsoft.Extensions.Caching.Memory
```

Next, we create a console application

```bash
dotnet new console -o CachingThreading
```

Then, we write a small program that simulates the **generation of an expensive resource**.

```c#
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

Log.Information("Starting up");


// Create our cache options (default)
var options = new MemoryCacheOptions();
// Create our Memory Cache
var cache = new MemoryCache(options);

// Crate and cache resource
var x = await cache.GetOrCreateAsync("Key", async _ =>
{
    // Perform work here
    return await GenerateThing();
});

// Print result fetched from cache
Log.Information("The cached entry is {Entry}", x);

// Simulate repeat
x = await cache.GetOrCreateAsync("Key", async _ =>
{
    // Perform work here
    return await GenerateThing();
});

Log.Information("The cached entry is {Entry}", x);
return;

async Task<int> GenerateThing()
{
    // Simulate expensive task
    Log.Information("Generating thing from thread {ThreadId}", Environment.CurrentManagedThreadId);
    await Task.Delay(TimeSpan.FromSeconds(5));
    return Random.Shared.Next();
}
```

If we look at the results:

```plaintexst
[05:53:20 INF] Starting up
[05:53:20 INF] Generating thing from thread 1
[05:53:25 INF] The cached entry is 813557459
[05:53:25 INF] The cached entry is 813557459
```

We can see here that after a 5-second delay, the second call to [GetOrCreateAsync](https://learn.microsoft.com/en-us/dotnet/api/microsoft.extensions.caching.memory.cacheextensions.getorcreateasync?view=net-9.0-pp) succeeds **immediately**, as the key is already in the cache.

Now let us try to simulate a scenario where multiple threads are in play.

```c#
// Create 10 threads to generate the Thing
await Parallel.ForEachAsync(Enumerable.Range(1, 10), async (item, token) =>
{
    // Crate and cache resource
    var x = await cache.GetOrCreateAsync("Key", async _ =>
    {
        // Perform work here
        return await GenerateThing();
    });
});
```

The logs show something interesting:

```bash
[05:57:41 INF] Starting up
[05:57:41 INF] Generating thing from thread 4
[05:57:41 INF] Generating thing from thread 9
[05:57:41 INF] Generating thing from thread 6
[05:57:41 INF] Generating thing from thread 13
[05:57:41 INF] Generating thing from thread 8
[05:57:41 INF] Generating thing from thread 10
[05:57:41 INF] Generating thing from thread 7
[05:57:41 INF] Generating thing from thread 12
[05:57:41 INF] Generating thing from thread 14
[05:57:41 INF] Generating thing from thread 11
[05:57:46 INF] The cached entry is 635424508
```

We can see here that there are **10 attempts** to generate the expensive resource.

This generally **isn't** what we want. We want only **one thread to make the attempt and the others to wait**.

We can get this behaviour by using the [LazyCache](https://github.com/alastairtree/LazyCache) library.

```c#
dotnet add package LazyCache
```

We then update our code as follows:

```c#
// Create our cache options (default)
var options = new MemoryCacheOptions();
// Create our Memory Cache
var memoryCache = new MemoryCache(options);
// Generate our Lazy Cache
var lazyCache = new CachingService();

Log.Information("Using memory cache");

// Create 10 threads to generate the Thing
await Parallel.ForEachAsync(Enumerable.Range(1, 10), async (item, token) =>
{
    // Crate and cache resource
    var x = await memoryCache.GetOrCreateAsync("Key", async _ =>
    {
        // Perform work here
        return await GenerateThing();
    });
});

// Print result fetched from cache
Log.Information("The cached entry is {Entry}", memoryCache.Get<int>("Key"));

Log.Information("Using Lazy Cache");

// Create 10 threads to generate the Thing
await Parallel.ForEachAsync(Enumerable.Range(1, 10), async (item, token) =>
{
    // Crate and cache resource
    var x = await lazyCache.GetOrAddAsync("Key", async _ =>
    {
        // Perform work here
        return await GenerateThing();
    });
});

// Print result fetched from cache
Log.Information("The cached entry is {Entry}", lazyCache.Get<int>("Key"));

```

Our logs now paint a different picture:

```plaintext
[06:06:17 INF] Starting up
[06:06:17 INF] Using memory cache
[06:06:17 INF] Generating thing from thread 10
[06:06:17 INF] Generating thing from thread 9
[06:06:17 INF] Generating thing from thread 11
[06:06:17 INF] Generating thing from thread 8
[06:06:17 INF] Generating thing from thread 13
[06:06:17 INF] Generating thing from thread 12
[06:06:17 INF] Generating thing from thread 4
[06:06:17 INF] Generating thing from thread 7
[06:06:17 INF] Generating thing from thread 6
[06:06:17 INF] Generating thing from thread 14
[06:06:22 INF] The cached entry is 530327150
[06:06:22 INF] Using Lazy Cache
[06:06:22 INF] Generating thing from thread 10
[06:06:27 INF] The cached entry is 1239099699
```

Here, only one thread, `10`, is attempting to generate the resource.

### TLDR

**Calling the `GetOrCreateAsync` of the `MemoryCache` will call the factory method as many times as concurrent threads are calling it, which probably isn't what you want. In such a scenario, an alternative like `LazyCache` can be used.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-03-22%20-%20Cache%20Threading).

Happy hacking!
