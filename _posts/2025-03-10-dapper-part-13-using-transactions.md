---
layout: post
title: Dapper Part 13 - Using Transactions
date: 2025-03-10 20:55:00 +0300
categories:
    - C#
    - .NET
    - Dapper
    - Database
---

This is Part 13 of a series on using `Dapper` to simplify data access with `ADO.NET`

* [Simpler .NET Data Access With Dapper - Part 1]({% post_url 2025-02-25-simpler-net-data-access-with-dapper-part-1 %})
* [Dapper Part 2 - Querying The Database]({% post_url 2025-02-26-dapper-part-2-querying-the-database %})
* [Dapper Part 3 - Executing Queries]({% post_url 2025-02-27-dapper-part-3-executing-queries %})
* [Dapper Part 4 - Passing Data To And From The Database]({% post_url 2025-02-28-dapper-part-4-passing-data-to-and-from-the-database %})
* [Dapper Part 5 - Passing Data In Bulk To The Database]({% post_url 2025-03-01-dapper-part-5-passing-data-in-bulk-to-the-database %})
* [Dapper Part 6 - Returning Multiple Sets Of Results]({% post_url 2025-03-02-dapper-part-6-returning-multiple-sets-of-results %})
* [Dapper Part 7 - Adding DateOnly & TimeOnly Support]({% post_url 2025-03-03-dapper-part-7-adding-dateonly-timeonly-support%})
* [Dapper Part 8 - Controlling Database Timeouts]({% post_url 2025-03-04-dapper-part-8-controlling-database-timeouts %})
* [Dapper Part 9 - Using Dynamic Types]({% post_url 2025-03-05-dapper-part-9-using-dynamic-types %})
* [Dapper Part 10 - Handling Cancellations]({% post_url 2025-03-06-dapper-part-10-handling-cancellations %})
* [Dapper Part 11 - Using Inheritance]({% post_url 2025-03-07-dapper-part-11-using-inheritance %})
* [Dapper Part 12 - Alternative Bulk Insert Technique]({% post_url 2025-03-08-dapper-part-12-alternative-bulk-insert-technique %})
* **Dapper Part 13 - Using Transactions (This Post)**
* [Dapper Part 14 - Multithreading]({% post_url 2025-03-11-dapper-part-14-multithreading %})
* [Dapper Part 15 - Using The IN Clause]({% post_url 2025-03-12-dapper-part-15-using-the-in-clause %})
* [Dapper Part 16 - Consideration When Passing Parameters]({% post_url 2025-05-07-dapper-part-16-consideration-when-passing-parameters %})

In the [last post of this series]({% post_url 2025-03-08-dapper-part-12-alternative-bulk-insert-technique %}), we looked at an alternative way to insert several rows at once.

In this post, we will look at how to use [database transactions](https://www.geeksforgeeks.org/transaction-in-dbms/).

You will need this functionality in scenarios where we need **multiple database operations to be treated as a unit.** Which is to say, **they all fail together or they all succeed together**.

Let us look at our existing data in the `Spy` table.

![SpiesData](../images/2025/03/SpiesData.png)

Suppose we want to change some information for the first 3 spies.

We would create an endpoint as follows:

```c#
app.MapPost("/Update/v1", async (SqlConnection cn) =>
{
    // setup our update queries
    const string firstUpdate = "UPDATE Spies SET Name = 'James Perceval Bond' WHERE SpyID = 1";
    const string secondUpdate = "UPDATE Spies SET Name = 'Eve Janet MoneyPenny' WHERE SpyID = 2";
    const string thirdUpdate = "UPDATE Spies SET Name = 'Vesper Leonora Lynd' WHERE SpyID = 3";

    // Execute our queries
    await cn.ExecuteAsync(firstUpdate);
    await cn.ExecuteAsync(secondUpdate);
    await cn.ExecuteAsync(thirdUpdate);

    // Return ok
    return Results.Ok();
});
```

If we execute this endpoint and query our database again, we get the following:

![UpdatedSpies](../images/2025/03/UpdatedSpies.png)

So far, so good.

Here, all three queries are **independent of each other**. If, for some reason, the update for ***Vesper Lynd*** failed - `thirdUpdate`, **the other two would be unaffected**.

Sometimes, we do not want this. 

A common situation is where you insert an `Order` and some `OrderItems`.

In this situation, we will require a [transaction](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqltransaction?view=sqlclient-dotnet-standard-5.2).

This is done as follows:

```c#
app.MapPost("/Update/v2", async (SqlConnection cn, ILogger<Program> logger) =>
{
    // Open the connection
    await cn.OpenAsync();
    // Obtain a transaction from the connection
    await using (var transaction = await cn.BeginTransactionAsync())
    {
        try
        {
            // setup our update queries
            const string firstUpdate = "UPDATE Spies SET Name = 'James Michael Bond' WHERE SpyID = 1";
            const string secondUpdate = "UPDATE Spies SET Name = 'Eve Jean MoneyPenny' WHERE SpyID = 2";
            const string thirdUpdate = "UPDATE Spies SET Name = 'Vesper Madison Lynd' WHERE SpyID = 3";

            // Execute our queries, passing the transaction to each
            await cn.ExecuteAsync(firstUpdate, transaction);
            await cn.ExecuteAsync(secondUpdate, transaction);
            await cn.ExecuteAsync(thirdUpdate, transaction);

            // Commit the transaction if all queries
            // executed successfully
            await transaction.CommitAsync();
        }
        catch (Exception ex)
        {
            // Log the exception
            logger.LogError(ex, "An error occured during transaction");
            // Rollback changes
            await transaction.RollbackAsync();
        }
    }

    // Return ok
    return Results.Ok();
});
```

If we run this endpoint, we get the following results:

![UpdatedSpies2](../images/2025/03/UpdatedSpies2.png)

This is as expected.

To demonstrate what happens if one of the queries fails, let us introduce an exception into a third endpoint.

```c#
app.MapPost("/Update/v3", async (SqlConnection cn, ILogger<Program> logger) =>
{
    // Open the connection
    await cn.OpenAsync();
    // Obtain a transaction from the connection
    await using (var trans = await cn.BeginTransactionAsync())
    {
        try
        {
            // setup our update queries
            const string firstUpdate = "UPDATE Spies SET Name = 'James Bond' WHERE SpyID = 1";
            const string secondUpdate = "UPDATE Spies SET Name = 'Eve MoneyPenny' WHERE SpyID = 2";
            const string thirdUpdate = "UPDATE Spies SET Name = 'Vesper Lynd' WHERE SpyID = 3";

            // Execute our queries, passing the transaction to each
            await cn.ExecuteAsync(firstUpdate, transaction: trans);
            await cn.ExecuteAsync(secondUpdate, transaction: trans);
            await cn.ExecuteAsync(thirdUpdate, transaction: trans);

            // throw some exception here
            throw new Exception("A random exception");

            // Commit the transaction if all queries
            // executed successfully
            await trans.CommitAsync();
        }
        catch (Exception ex)
        {
            // Log the exception
            logger.LogError(ex, "An error occured during transaction");
            // Rollback changes
            await trans.RollbackAsync();
            // Return an error response
            return Results.InternalServerError();
        }
    }

    // Return ok
    return Results.Ok();
});
```

This returns the following:

![ErrorResponse](../images/2025/03/ErrorResponse.png)

If we look at the logs:

![LogException](../images/2025/03/LogException.png)

And finally if we look at the database:

![FinalResults](../images/2025/03/FinalResults.png)

Here we can see that much as the queries themselves **should have executed successfully**, the fact that we indicated that we should **rollback any transaction once we encounter an exception** overrides that.

### TLDR

**`Dapper`, through the underling `DbConnection`, allows us to use database transactions in our logic.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-03-10%20-%20Dapper%20Part%2013).

Happy hacking!
