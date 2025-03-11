---
layout: post
title: Dapper Part 12 - Alternative Bulk Insert Technique
date: 2025-03-08 23:11:01 +0300
categories:
    - C#
    - .NET
    - Dapper
    - Database
---

This is Part 12 of a series on using `Dapper` to simplify data access with `ADO.NET`

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
* **Dapper Part 12 - Alternative Bulk Insert Technique (This Post)**
* [Dapper Part 13 - Using Transactions]({% post_url 2025-03-10-dapper-part-13-using-transactions %})
* [Dapper Part 14 - Multithreading]({% post_url 2025-03-11-dapper-part-14-multithreading %})

In a [previous post]({% post_url 2025-03-01-dapper-part-5-passing-data-in-bulk-to-the-database %}), we discussed inserting multiple entities in a **loop**.

In this post, we will look at a different way of achieving the same thing.

We will use the following type:

```c#
public class FieldAgent
{
    public int AgentID { get; }
    public string Name { get; } = null!;
    public DateTime DateOfBirth { get; }
    public AgentType AgentType { get; }
    public string? CountryOfPosting { get; }
    public bool HasDiplomaticCover { get; }
}
```

Next, we write a query to insert `FieldAgents`

```sql
INSERT dbo.Agents
(
   Name,
   DateOfBirth,
   CountryOfPosting,
   HasDiplomaticCover,
   AgentType
)
VALUES
(
   @Name, @DateOfBirth, @CountryOfPosting, HasDiplomaticCover, @AgentType
) 
```

Finally, we create our endpoint:

```c#
app.MapPost("/", async (SqlConnection cn) =>
{
    // Create query to insert
    const string sql = """
                       INSERT dbo.Agents
                           (
                               Name,
                               DateOfBirth,
                               CountryOfPosting,
                               HasDiplomaticCover,
                               AgentType
                           )
                       VALUES
                           (
                               @Name, @DateOfBirth, @CountryOfPosting, HasDiplomaticCover, @AgentType
                           ) 
                       """;
    // Configure bogus
    var faker = new Faker<FieldAgent>();
    // Generate a full name
    faker.RuleFor(x => x.Name, f => f.Name.FullName());
    // Date of birth, max 90 years go
    faker.RuleFor(x => x.DateOfBirth, f => f.Date.Past(90));
    // Country of posting
    faker.RuleFor(x => x.CountryOfPosting, f => f.Address.Country());
    // Randomly assign diplomatic cover
    faker.RuleFor(x => x.HasDiplomaticCover, f => f.Random.Bool());
    // Agent type is field
    faker.RuleFor(x => x.AgentType, AgentType.Field);

    // Generate  a list of 100 field agents
    var fieldAgents = faker.Generate(100);
    // Now execute the query
    var inserted = await cn.ExecuteAsync(sql, fieldAgents);

    return inserted;
});
```

If we run this, we will get the following:

![CollectionInsert](../images/2025/03/CollectionInsert.png)

Our 100 rows have been **inserted**.

We can verify this by checking the table.

![NewSpies](../images/2025/03/NewSpies.png)

**It is important to note that you may have provided a collection of entities to insert, but what is going to happen is the insert query will be run 100 times to insert each `FieldAgent`.**

### TLDR

**Rather than writing your own loop, you can provide a collection of entities for entry, and `Dapper` will execute the relevant queries for each element.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-03-08%20-%20Dapper%20Part%2012).

Happy hacking!
