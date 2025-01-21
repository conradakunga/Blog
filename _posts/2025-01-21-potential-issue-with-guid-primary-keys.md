---
layout: post
title: Potential Issue With Guid Primary Keys
date: 2025-01-21 21:03:53 +0300
categories:
    - C#
    - Database
---

When working with relational databases, you will invariably have to deal with [primary keys](https://www.w3schools.com/sql/sql_primarykey.ASP). You will need to make decisions on two fronts:

1. What **data type** should the primary key be? Generally,[](https://learn.microsoft.com/en-us/dotnet/api/system.guid.createversion7?view=net-9.0#system-guid-createversion7(system-datetimeoffset)) you have three options
    1. A **number** (usually `int` or `bigint`)
    2. A `Guid` (which, technically, is a number!)
    3. A `string`
2. **Where** will the key be generated?
    1. In the **database**
    2. By the **application**

As with all things in computing, and in life, really, whichever of these to go for has **benefits** and **drawbacks** depending on context.

The data type affects the **storage** - `Guid` tends to require a lot more storage than `int`.

**Where** the generation takes place is an important consideration in distributed systems with complex logic. For example, if you are generating the primary keys in the database and  you need to generate an `Invoice` that has `InvoiceLines` - you must create the `Invoice` first and wait for the database to generate an `InvoiceID` that you then use to generate the `InvoiceLines`.

If you are generating the key yourself, you can generate the `Invoice` entirely in your code, and since you are generating the `InvoiceID`, you can use that directly to generate your `InvoiceLines` then submit them all at once for persistence.

For this latter scenario, if you are using [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/), **you can have the best of both worlds**, which we will look at in a subsequent post.

A consideration on the database side is the physical storage of the data rows. Primary keys tend to have a [clustered index](https://learn.microsoft.com/en-us/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver16) in most database engines, which means the data is stored in the order of the primary key, which makes row location and retrieval easier.

This isn't an issue with numeric keys - they will be stored in **sequence**. It becomes an issue with `Guid` keys.

Let us take a simple example of this simple type.

```c#
public sealed class Spy
{
  public required Guid ID { get; init; }
  public required string Name { get; init; }
}
```

Suppose we need to generate a bunch of `Spy` entities.

We would do that like so:

```c#
Spy[] spies =
[
    new Spy { ID = Guid.NewGuid(), Name = "James Bond" },
    new Spy { ID = Guid.NewGuid(), Name = "Evelyn Salt" },
    new Spy { ID = Guid.NewGuid(), Name = "George Smiley" },
    new Spy { ID = Guid.NewGuid(), Name = "Jason Bourne" },
    new Spy { ID = Guid.NewGuid(), Name = "Roz Myers" },
    new Spy { ID = Guid.NewGuid(), Name = "Harry Pearce" },
];
```

Then, let us print the values, and in particular the primary key we are inserting - `ID`

```c#
foreach (var spy in spies)
{
    Console.WriteLine($" ID: {spy.ID}, Name: {spy.Name}");
}
```

The output will be something like this:

```plaintext
ID: f4b2ba09-7424-4fcf-b534-39ce3d532fa7, Name: James Bond
ID: fcebc591-30a0-4c55-967f-989caaedb63b, Name: Evelyn Salt
ID: 5142be2e-287b-48de-a9bb-6ed4ded55c29, Name: George Smiley
ID: ae673754-1adf-487c-9a53-03c8a5d128ff, Name: Jason Bourne
ID: c4879be3-968f-4f34-bf9c-2accfecc4184, Name: Roz Myers
ID: 2e159b63-a399-4695-a3dc-e34992c42a3c, Name: Harry Pearce
```

If you look at the `ID` values, you will realize that they are effectively random - they are not in any particular **sequence**.

This is precisely the problem.

Since the primary key is backed by a clustered index, the database will effectively have to do a lot of work making sure that the data is physically ordered for storage and retrieval by the primary key. This is called [index fragmentation](https://www.solarwinds.com/resources/it-glossary/index-fragmentation).

The data will actually be stored in this order:

```plaintext
ID: ae673754-1adf-487c-9a53-03c8a5d128ff, Name: Jason Bourne
ID: c4879be3-968f-4f34-bf9c-2accfecc4184, Name: Roz Myers
ID: f4b2ba09-7424-4fcf-b534-39ce3d532fa7, Name: James Bond
ID: 5142be2e-287b-48de-a9bb-6ed4ded55c29, Name: George Smiley
ID: fcebc591-30a0-4c55-967f-989caaedb63b, Name: Evelyn Salt
ID: 2e159b63-a399-4695-a3dc-e34992c42a3c, Name: Harry Pearce
```

This problem gets **worse** when you have:

1. Very **many rows** in the table
2. You are **inserting a large number of rows** at once.

Luckily, there are solutions to this problem.

If you are using [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads), you can have the server generate for you sequential `Guid` values. You can do this using a [default](https://learn.microsoft.com/en-us/sql/relational-databases/tables/specify-default-values-for-columns?view=sql-server-ver16).

Typically, we'd create a table with a server-side generated primary key like this:

```sql
CREATE TABLE Spies
(
    ID   UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (NEWID()),
    Name NVARCHAR(200) NOT NULL UNIQUE
);
```

To have SQL Server generate sequential `Guid` values we do [it](https://learn.microsoft.com/en-us/dotnet/api/system.guid.createversion7?view=net-9.0#system-guid-createversion7(system-datetimeoffset)) like this:

```sql
CREATE TABLE Spies
(
    ID   UNIQUEIDENTIFIER PRIMARY KEY DEFAULT (NEWSEQUENTIALID()),
    Name NVARCHAR(200) NOT NULL UNIQUE
);
```

The magic is achieved by using the function [NEWSEQUENTIALID](https://learn.microsoft.com/en-us/sql/t-sql/functions/newsequentialid-transact-sql?view=sql-server-ver16) rather than [NEWID](https://learn.microsoft.com/en-us/sql/t-sql/functions/newid-transact-sql?view=sql-server-ver16)

For PostgreSQL you can achieve this using an [extension](https://www.enterprisedb.com/blog/sequential-uuid-generators).

If you are generating the IDs on the client side, you can. take advantage of a new feature of .NET 9 that allows you to generate `Guid` values that are compliant with [RFC 9562](https://www.rfc-editor.org/rfc/rfc9562.html).

We can update our code as follows:

```c#
Spy[] newSpies =
[
    new Spy { ID = Guid.CreateVersion7(), Name = "James Bond" },
    new Spy { ID = Guid.CreateVersion7(), Name = "Evelyn Salt" },
    new Spy { ID = Guid.CreateVersion7(), Name = "George Smiley" },
    new Spy { ID = Guid.CreateVersion7(), Name = "Jason Bourne" },
    new Spy { ID = Guid.CreateVersion7(), Name = "Roz Myers" },
    new Spy { ID = Guid.CreateVersion7(), Name = "Harry Pearce" },
];
```

This will use the new method [CreateVersion7](https://learn.microsoft.com/en-us/dotnet/api/system.guid.createversion7?view=net-9.0) to generate the following:

```plaintext
 ID: 01948a56-2e30-75b8-85b6-90fe4e8bcfb5, Name: James Bond
 ID: 01948a56-2e30-7688-82d3-a67dbd7a6fcc, Name: Evelyn Salt
 ID: 01948a56-2e30-7841-8ce5-df43e2e0356d, Name: George Smiley
 ID: 01948a56-2e30-77b1-a1aa-6ad22797bec7, Name: Jason Bourne
 ID: 01948a56-2e30-7bef-8ca4-3a9ccfd951fe, Name: Roz Myers
 ID: 01948a56-2e30-7e38-ac97-1f6a66a4a7b6, Name: Harry Pearce
```

You can see from these values the nature of the **sequencing**.

Since by default the algorithm uses the **current time**, there is an [overload](https://learn.microsoft.com/en-us/dotnet/api/system.guid.createversion7?view=net-9.0#system-guid-createversion7(system-datetimeoffset)) that allows you to specify your own time.

```c#
var time = TimeProvider.System.GetUtcNow();
Spy[] newSpies =
[
    new Spy { ID = Guid.CreateVersion7(time), Name = "James Bond" },
    new Spy { ID = Guid.CreateVersion7(time), Name = "Evelyn Salt" },
    new Spy { ID = Guid.CreateVersion7(time), Name = "George Smiley" },
    new Spy { ID = Guid.CreateVersion7(time), Name = "Jason Bourne" },
    new Spy { ID = Guid.CreateVersion7(time), Name = "Roz Myers" },
    new Spy { ID = Guid.CreateVersion7(time), Name = "Harry Pearce" },
];
```

The beauty of this approach is it will work for any relational database.

### TLDR

**Guid primary keys can cause performance issues at scale. You can address this at the RDBMS level or at application level. If at application level, .NET 9 has the ability to generate sequential `Guid` values that can be very useful**

Happy hacking!
