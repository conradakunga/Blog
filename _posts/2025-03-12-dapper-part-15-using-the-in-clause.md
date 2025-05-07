---
layout: post
title: Dapper Part 15 - Using the IN Clause
date: 2025-03-12 20:43:08 +0300
categories:
    - C#
    - .NET
    - Dapper
    - Database
---

This is Part 15 of a series on using `Dapper` to simplify data access with `ADO.NET`

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
* [Dapper Part 13 - Using Transactions]({% post_url 2025-03-10-dapper-part-13-using-transactions %})
* [Dapper Part 14 - Multithreading]({% post_url 2025-03-11-dapper-part-14-multithreading %})
* **Dapper Part 15 - Using The IN Clause (This Post)**
* [Dapper Part 16 - Consideration When Passing Parameters]({% post_url 2025-05-07-dapper-part-16-consideration-when-passing-parameters %})

In the [last post]({% post_url 2025-03-11-dapper-part-14-multithreading %}), we looked at considerations for **multithreading**.

This post will discuss how to use the [SQL IN clause](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/in-transact-sql?view=sql-server-ver16).

In a [previous post]({% post_url 2025-03-01-dapper-part-5-passing-data-in-bulk-to-the-database %}), we saw how to use [table-valued parameters](https://learn.microsoft.com/en-us/sql/relational-databases/tables/use-table-valued-parameters-database-engine?view=sql-server-ver16) to bulk-send data to the database.

Sometimes, you have a situation where your data is in a simple **list of primitives**.

In such a situation, you do not need the overhead of a [user-defined type](https://learn.microsoft.com/en-us/sql/relational-databases/clr-integration-database-objects-user-defined-types/working-with-user-defined-types-in-sql-server?view=sql-server-ver16) and a `table-valued parameter`.

Let us take a situation where we need to load the details of several `Spy` entities with their `SpyIDs` provided at runtime.

If we knew the IDs **in advance**, we would write a query like this:

```sql
SELECT *
FROM Spies
WHERE Spies.SpyID in (1, 2 ,3 ,4, 6, 10, 13, 56)
```

However, if the IDs are being provided at **runtime**, we do something like this:

```c#
app.MapGet("/List", async (SqlConnection cn) =>
{
    // create query
    const string query = """
                         SELECT * FROM Spies
                         WHERE Spies.SpyID IN @Spies
                         """;
    // define a collection to store the IDs
    int[] ids = [1, 2, 3, 4, 6, 10, 13, 56];

    // Fetch the spies
    var spies = await cn.QueryAsync<Spy>(query, new { Spies = ids});
    return spies;
});
```

This will return the following:

![SpiesINResult](../images/2025/03/SpiesINResult.png)

The magic is taking place here:

```c#
 // Fetch the spies
 var spies = await cn.QueryAsync<Spy>(query, new { Spies = ids});
```

`Dapper` can use the list to construct a valid `IN` query.

Note that the query itself **does not have brackets around the parameter.**

```sql
SELECT * FROM Spies
WHERE Spies.SpyID IN @Spies
```

### TLDR

**Dapper can construct and execute valid `IN` clause statements using collections.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-03-12%20-%20Dapper%20Part%2015).

Happy hacking!
