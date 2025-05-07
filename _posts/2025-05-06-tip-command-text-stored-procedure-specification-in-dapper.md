---
layout: post
title: Tip - Command Text & Stored Procedure Specification In Dapper
date: 2025-05-06 06:58:12 +0300
categories:
    - .NET
    - C#
    - Dapper
    - StarLibrary
---

[Dapper](https://github.com/DapperLib/Dapper), is a very powerful library that makes it very easy to work with [ADO.NET](https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview).

I have done a [series of posts]({% post_url 2025-02-25-simpler-net-data-access-with-dapper-part-1%}) on how to use **Dapper**.

Given that **Dapper** is layered on top of **ADO.NET,** it is important to remember that there are **two** ways to send commands to your database.

I will use a simple WebAPI to demonstrate this:

The first is as **query text**, like this:

```c#
app.MapGet("/SpiesByText", async (SqlConnection cn) =>
{
    var result = await cn.QueryAsync<Spy>("SELECT * FROM Spies", commandType: CommandType.Text);

    return result;
});
```

This is a wrapper around the way you would normally do it with direct **ADO.NET**. 

```c#
app.MapGet("/SpiesByTextRaw", async (SqlConnection cn, CancellationToken token) =>
{
    var spies = new List<Spy>();
    // Open the connection
    await cn.OpenAsync(token);
    // Create  a command
    await using var cmd = cn.CreateCommand();
    // Set the command text
    cmd.CommandText = "SELECT * FROM Spies";
    // Set the command type
    cmd.CommandType = CommandType.Text;
    // Execute the command and get back a reader, specifying the connection to be closed
    // after the reader is closed
    var reader = await cmd.ExecuteReaderAsync(CommandBehavior.CloseConnection, token);
    // Scroll forwards through the results
    while (await reader.ReadAsync(token))
    {
        // Add to the collection
        spies.Add(new Spy
        {
            // Read the value from the column specified
            SpyID = reader.GetInt32(reader.GetOrdinal("SpyID")),
            Name = reader.GetString(reader.GetOrdinal("Name")),
            DateOfBirth = reader.GetDateTime(reader.GetOrdinal("DateOfBirth")),
        });
    }

    // Close the reader
    await reader.CloseAsync();

    return spies;
});
```

The other way to do it is with a [stored procedure](https://en.wikipedia.org/wiki/Stored_procedure).

```c#
app.MapGet("/SpiesByProcedure", async (SqlConnection cn) =>
{
  var result = await cn.QueryAsync<Spy>("[Spies.GetAll]", commandType: CommandType.StoredProcedure);
  return result;
});
```

You can see how much code **Dapper** has saved us.

Of interest is the part where we tell **Dapper** whether we are passing a stored procedure name, or a query.

The procedure:

```c#
var result = await cn.QueryAsync<Spy>("[Spies.GetAll]", commandType: CommandType.StoredProcedure);
```

The query:

```c#
var result = await cn.QueryAsync<Spy>("SELECT * FROM Spies", commandType: CommandType.Text);
```

**Dapper** is smart enough to figure out which one to use.

So you do not need to specify the `CommandType`.

It is, however, advisable to so that the intent is clear to whoever is reading the code.

### TLDR

**You do not need to specify the `CommandType` when executing queries with Dapper.**

The code is in my GitHub.

Happy hacking!
