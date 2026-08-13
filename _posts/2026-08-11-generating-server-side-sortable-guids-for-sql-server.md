---
layout: post
title: Generating Server-Side Sortable GUIDs for SQL Server
date: 2026-08-11 19:20:45 +0300
categories:
    - C#
    - .NET
    - Database
    - SQL Server
---

In [some]({% post_url 2026-08-08-beware-guidv7-generation-in-high-throughput-environments-sorting-gotcha %}) [previous]({% post_url 2026-08-09-guidv7-considerations-for-database-keys %}) posts, we have seen the sort of challenges that may arise when generating `Guid` values for database keys, and in particular, an issue specific to [SQL Server](https://www.microsoft.com/en-us/sql-server) [Guid sorting]({% post_url 2026-08-10-guidv7-considerations-for-sql-server %}).

In a nutshell, client-generated `GUIDs` **do not sort correctly**, even when using `Guid.CreateVersion7()`, due to a complication when multiple `Guid` values are generated in the same **millisecond**.

Additionally, **SQL Server** sorts `Guids` using a [different algorithm]({% post_url 2026-08-10-guidv7-considerations-for-sql-server %}).

In this post, we will look at how to resolve this problem on the **server side**.

The solution here is to use the [NEWSEQUENTIALID()](https://learn.microsoft.com/en-us/sql/t-sql/functions/newsequentialid-transact-sql?view=sql-server-ver17) function.

We have looked at this previously in the post [Tip - Generating GUIDs for Use in Primary Keys in SQL Server]({% post_url 2026-03-22-tip-generating-guids-for-use-in-primary-keys %}).

We will use our sample `type`, the `Thing`:

```c#
public sealed record Thing(Guid ID, string Caption);
```

Our table will look like this:

```sql
create table things
(
    id      uniqueidentifier primary key default (newsequentialid()),
    caption nvarchar(100) not null
)
```

Here we are using `NEWSEQUENTIALID()` to supply the **default** value. The function is **not usable as a normal function**.

Our code to **insert** will look like this:

```c#
using Dapper;
using Microsoft.Data.SqlClient;

const string connectionString =
    "data source=localhost;uid=sa;password=YourStrongPassword123;database=things;trustservercertificate=true";
var thingCaptions = new List<string>();
for (var i = 0; i < 10; i++)
{
    thingCaptions.Add($"{i}");
}

foreach (var thing in thingCaptions)
{
    Console.WriteLine($"Caption: {thing}");

    using (var cn = new SqlConnection(connectionString))
    {
        cn.Execute("insert into things(caption) values (@Caption)", new { Caption = thing });
    }
}
```

Upon **successful** execution, it will output this:

![serverSideGeneration](../images/2026/08/serverSideGeneration.png)

We can now go and inspect the **database**, by queriying all our `Thing` objects and sorting by `ID`.

```sql
select * from things order by id
```

We should see the following:

![sortedServerSideGuids](../images/2026/08/sortedServerSideGuids.png)

Here we can see they are **correctly ordered as they were inserted**.

### TLDR

**You can get correctly ordered `Guids` on the server side using the `NEWSEQUENTIALID()` function**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-08-11%20-%20GuidGeneration%20SQL%20Server%20Server%20Side).

Happy hacking!
