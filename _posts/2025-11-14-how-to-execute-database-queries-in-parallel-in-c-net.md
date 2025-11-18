---
layout: post
title: How To Execute Database Queries In Parallel In C# & .NET
date: 2025-11-14 21:09:48 +0300
categories:
---

Yesterday's post, "[Beware - Parallel.ForEach And Async Don't Play Well Together]({% post_url 2025-11-15-beware-parallelforeach-and-async-dont-play-well-together %})", discussed the predicament I ran into when incorrectly running async code using [Parallel.ForEach](https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.parallel.foreach?view=net-9.0), which ran the code **synchronously** anyway.

The code in question was as follows:

![AsyncParalle](../images/2025/11/AsyncParalle.png)

Which is precisely the **wrong approach** - `async` here **does not do what you would expect it** to do.

In this post, we will look at how to do it **correctly**.

The solution to this problem is to use the [Parallel.ForEachAsync](https://learn.microsoft.com/en-us/dotnet/api/system.threading.tasks.parallel.foreachasync?view=net-9.0) construct, like so:

```c#
using Dapper;
using Microsoft.Data.SqlClient;

string[] collection = ["One", "Two", "Three"];

await Parallel.ForEachAsync(collection, async (element, _) =>
{
  await using var cn = new SqlConnection("......");
  await cn.ExecuteAsync("Query", new { ID = element }
  );
});
```

The discard parameter, `_`, is where we would pass a [CancellationToken](https://learn.microsoft.com/en-us/dotnet/api/system.threading.cancellationtoken?view=net-9.0), if we had one.

This code will correctly execute the queries in **multiple** threads **without exhausting connections**, given that the threads **will wait until the execution is complete** before creating **new connections**.

### TLDR

**`Parallel.ForEachAcync` is the correct way to execute multiple queries in parallel.**

The code is in my GitHub.

Happy hacking!
