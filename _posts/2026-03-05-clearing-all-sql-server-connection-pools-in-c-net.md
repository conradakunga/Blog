---
layout: post
title: Clearing All SQL Server Connection Pools In C# & .NET
date: 2026-03-05 20:30:53 +0300
categories:
    - SQL Server
    - C#
    - .NET
---

Creating database connections from an application is an **expensive operation**.

A lot is happening here:

1. Establishment of a **connection** to the database engine
2. **Authentication** and **authorization**
3. Session initialization between the server and client

To mitigate this, the [ADO.NET](https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview) provider ([Microsoft.Data.SqlClient](https://github.com/dotnet/sqlclient)) leverages [connection pools](https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/sql-server-connection-pooling), which can be thought of as a cache of previously established connections that are kept available for re-use.

When a connection is through with a connection and **closes** it, rather than **destroying** the connection, it is **returned to the pool**, and the next time a connection is requested, one of these is reused.

Connection pools are maintained **per connection string and per process**, so **every different connection string for each application** will, subject to server resources, get allocated a different connection pool.

Generally, **you do not need to manage the pool** yourself.

But if you need to, you can clear all the existing connection pools using the static [ClearAllPools](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqlconnection.clearallpools?view=sqlclient-dotnet-core-6.1) method of the [SqlConnection](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqlconnection?view=sqlclient-dotnet-core-6.1) like so:

```c#
SqlConnection.ClearAllPools();
```

If you want to clear the connection pool **associated with an existing connection**, you do it using the static [ClearPool](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqlconnection.clearpool?view=sqlclient-dotnet-core-6.1) method of the [SqlConnection](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqlconnection?view=sqlclient-dotnet-core-6.1), like this :

```c#
SqlConnection.ClearPool(cn);
```

Here, `cn` is an existing [SqlConnection](https://learn.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlconnection?view=netframework-4.8.1).

Why would you need to clear the pool? Certain classes of errors, such as t**ransport-level errors**.

### TLDR

You can clear SQL Server ADO.NET connection pools using either `SqlConnection.ClearAllPools()` or `SqlConnection.ClearPool()`

Happy hacking!
