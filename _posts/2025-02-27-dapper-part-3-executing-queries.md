---
layout: post
title: Dapper Part 3 - Executing Queries
date: 2025-02-27 21:20:36 +0300
categories:
    - C#
    - .NET
    - Dapper
    - Database
---

This is Part 3 of a series on using `Dapper` to simplify data access with `ADO.NET`

* [Simpler .NET Data Access With Dapper - Part 1]({% post_url 2025-02-25-simpler-net-data-access-with-dapper-part-1 %})
* [Dapper Part 2 - Querying The Database]({% post_url 2025-02-26-dapper-part-2-querying-the-database %})
* **Dapper Part 3 - Executing Queries (This post)**
* [Dapper Part 4 - Passing Data To And From The Database]({% post_url 2025-02-28-dapper-part-4-passing-data-to-and-from-the-database %})
* [Dapper Part 5 - Passing Data In Bulk To The Database]({% post_url 2025-03-01-dapper-part-5-passing-data-in-bulk-to-the-database %})
* [Dapper Part 6 - Returning Multiple Sets Of Results]({% post_url 2025-03-02-dapper-part-6-returning-multiple-sets-of-results %})
* [Dapper Part 7 - Adding DateOnly & TimeOnly Support]({% post_url 2025-03-03-dapper-part-7-adding-dateonly-timeonly-support %})
* [Dapper Part 8 - Controlling Database Timeouts]({% post_url 2025-03-04-dapper-part-8-controlling-database-timeouts %})
* [Dapper Part 9 - Using Dynamic Types]({% post_url 2025-03-05-dapper-part-9-using-dynamic-types %})
* [Dapper Part 10 - Handling Cancellations]({% post_url 2025-03-06-dapper-part-10-handling-cancellations %})
* [Dapper Part 11 - Using Inheritance]({% post_url 2025-03-07-dapper-part-11-using-inheritance %})
* [Dapper Part 12 - Alternative Bulk Insert Technique]({% post_url 2025-03-08-dapper-part-12-alternative-bulk-insert-technique %})
* [Dapper Part 13 - Using Transactions]({% post_url 2025-03-10-dapper-part-13-using-transactions %})
* [Dapper Part 14 - Multithreading]({% post_url 2025-03-11-dapper-part-14-multithreading %})
* [Dapper Part 15 - Using The IN Clause]({% post_url 2025-03-12-dapper-part-15-using-the-in-clause %})
* [Dapper Part 16 - Consideration When Passing Parameters]({% post_url 2025-05-07-dapper-part-16-consideration-when-passing-parameters %})

In our [last post]({% post_url 2025-02-26-dapper-part-2-querying-the-database %}), we looked at how to use [Dapper](https://github.com/DapperLib/Dapper) to query a database and return results, either a **collection** of types, a **single type**, or a **single value**.

In this post, we will examine how to execute database queries that do not return anything.

## 1. Ad Hoc SQL

Occasionally, you might need to execute some queries against your database. For example, some ad-hoc SQL to delete some records.

You do this using the `Execute` method or the `async` equivalent, `ExecuteAsync`.

Let us create an endpoint to **delete all inactive agents**:

```c#
app.MapGet("/Purge", async (SqlConnection cn, ILogger<Program> logger) =>
{
    const string query = """
                         DELETE FROM
                                dbo.Spies
                         WHERE
                             Spies.Active = 0;;
                         """;
    await cn.ExecuteAsync(query);
});
```

We can also **pass parameters** to our query. 

Let us create a second endpoint that will allow us to **pass the status of what to delete.**

```c#
app.MapGet("/PurgeByStatus/{status:bool}", async (SqlConnection cn, ILogger<Program> logger, bool status) =>
{
    const string query = """
                         DELETE FROM
                                dbo.Spies
                         WHERE
                             Spies.Active = @Status
                         """;

    var param = new DynamicParameters();
    param.Add("Status", status);

    await cn.ExecuteAsync(query);
});
```

Remember, we can also use [anonymous types](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/anonymous-types) rather than `DynamicParameters`.

```c#
app.MapGet("/PurgeByStatus/{status:bool}", async (SqlConnection cn, ILogger<Program> logger, bool status) =>
{
    const string query = """
                         DELETE FROM
                                dbo.Spies
                         WHERE
                             Spies.Active = @Status
                         """;

    await cn.ExecuteAsync(query, new { Status = status });
});
```

## 2. Executing Stored Procedures

Rather than ad-hoc SQL, you can also execute **stored procedures**.

Suppose we had the following stored procedure:

```sql
CREATE OR ALTER PROC [Spies.PurgeByStatus] @Status BIT
AS
    BEGIN
        DELETE FROM
               dbo.Spies
        WHERE
            Spies.Active = @Status;
    END;
```

We can build an endpoint to execute this, very similar to our previous example:

```c#
app.MapGet("/PurgeByStatusProcedure/{status:bool}", async (SqlConnection cn, ILogger<Program> logger, bool status) =>
{
    var param = new DynamicParameters();
    param.Add("Status", status);

    await cn.ExecuteAsync("[Spies.PurgeByStatus]", param);
});
```

The queries you execute can be of **any kind**, including [DDL](https://en.wikipedia.org/wiki/Data_definition_language) (data definition language). You can create, alter, and drop database objects if you have the requisite rights.

```c#
app.MapGet("/Admin", async (SqlConnection cn, ILogger<Program> logger) =>
{
    const string query = """
                         CREATE TABLE Temp
                         (
                             ID   TINYINT       PRIMARY KEY,
                             Name NVARCHAR(100) NOT NULL
                                 UNIQUE
                         );
                         """;
    await cn.ExecuteAsync(query);
});
```

In our [next post]({% post_url 2025-02-28-dapper-part-4-passing-data-to-and-from-the-database %}), we will examine the **various methods for passing data between a database and a client**.

### TLDR

**You can execute ad-hoc queries or stored procedures using the `Execute` or the `ExecuteAsync` method.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-27%20-%20Dapper%20Part%203).

Happy hacking!
