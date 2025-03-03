---
layout: post
title: Simpler .NET Data Access With Dapper - Part 1
date: 2025-02-25 03:18:34 +0300
categories:
    - C#
    - .NET
    - Dapper
    - Database
---

This is Part 1 of a series on using `Dapper` to simplify data access with `ADO.NET`

* **Simpler .NET Data Access With Dapper - Part 1 (This post)**
* [Dapper Part 2 - Querying The Database]({% post_url 2025-02-26-dapper-part-2-querying-the-database %})
* [Dapper Part 3 - Executing Queries]({% post_url 2025-02-27-dapper-part-3-executing-queries %})
* [Dapper Part 4 - Passing Data To And From The Database]({% post_url 2025-02-28-dapper-part-4-passing-data-to-and-from-the-database %})
* [Dapper Part 5 - Passing Data In Bulk To The Database]({% post_url 2025-03-01-dapper-part-5-passing-data-in-bulk-to-the-database %})
* [Dapper Part 6 - Returning Multiple Sets Of Results]({% post_url 2025-03-02-dapper-part-6-returning-multiple-sets-of-results %})
* [Dapper Part 7 - Adding DateOnly & TimeOnly Support]({% post_url 2025-03-03-dapper-part-7-adding-dateonly-timeonly-support %})

In our last two posts, we have used raw [ADO.NET](https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/) for data access. You will realize that there is quite a bit of ceremony involved whenever you need to execute a query.

1. Create a **connection**
2. **Open** the connection
3. Create a **command**
4. Set the command **text**
5. Set the **parameters**, if any
6. **Execute** the query
7. If there are results, **map them to .NET types**
8. **Close** the connection

There are a bunch of drawbacks

1. This is very **monotonous**
2. **More code** to write means more places to **introduce errors** and more code to **debug**
3. Should you need to **change databases**, there is a lot of code that you need to update

There is a library that you can use to make this code much easier to write, maintain, and adapt - [Dapper](https://github.com/DapperLib/Dapper).

`Dapper` is a set of extension methods on the [DbConnection](https://learn.microsoft.com/en-us/dotnet/api/system.data.common.dbconnection?view=net-9.0) object that you can use to simplify your code.

Installing it is as follows:

```bash
dotnet add package Dapper
```

Going back to our SQL injection project, we can begin to simplify our code.

We can start with our database initialization code:

```c#
const string initializeDatabase = """
                                          CREATE TABLE IF NOT EXISTS USERS(UserID INTEGER PRIMARY KEY, Username VARCHAR(100), Password VARCHAR(100));

                                          INSERT INTO USERS (UserID, Username,Password) VALUES (1, 'jbond','jimmybond12$');
                                          """;

const string checkForTable = "SELECT COUNT(1) FROM sqlite_master WHERE type='table' AND name='USERS'";
// Create a connection object
using (var cn = new SqliteConnection(ConnectionString))
{
    // Open the connection
    cn.Open();
    var cmd = cn.CreateCommand();
    //
    // Check if table exists
    //

    // Set the command text to our query defined above
    cmd.CommandText = checkForTable;
    // Execute the query and obtain the returned value
    var returns = cmd.ExecuteScalar();
    if (Convert.ToInt32(returns) == 0)
    {
        // Table does not exist. Initialize
        // Set the command text to the query defined above
        // to generate the database
        cmd.CommandText = initializeDatabase;
        // Execute the query
        cmd.ExecuteNonQuery();
    }
}
```

We can replace this with the following:

```c#
using (var cn = new SqliteConnection(ConnectionString))
{
    //
    // Check if table exists
    //

    // Set the command text to our query defined above,
    // execute and capture the returned result
    var returns = cn.QuerySingle<int>(checkForTable);
    if (returns == 0)
    {
        // Table does not exist. Initialize
        // Set the command text to the query defined above
        // to generate the database and execute
        cn.Execute(initializeDatabase);
    }
}
```

Reading a result from a query is as simple as knowing what you expect and then using the generic `QuerySingle` and mapping it to what you are getting back. In this case, we expect a count, which is an `integer`, to be returned. And hence:

```c#
var returns = cn.QuerySingle<int>(checkForTable);
```

We can also simplify our login code, which currently looks like this:

```c#
app.MapPost("/Login", (SqliteConnection cn, ILogger<Program> logger, LoginRequest request) =>
{
    // Open a connection to the database from the injected connection
    cn.Open();
    // Create a command object from the connection
    var cmd = cn.CreateCommand();
    // Set the command query text
    cmd.CommandText = "SELECT 1 FROM USERS WHERE Username=@Username AND Password=@Password";
    //
    // Add the parameters
    //

    // Create the Username parameter
    var paramUsername = cmd.CreateParameter();
    // Set the data type
    paramUsername.SqliteType = SqliteType.Text;
    // Set the parameter name
    paramUsername.ParameterName = "@Username";
    // Set the parameter size
    paramUsername.Size = 100;
    // Set the parameter value
    paramUsername.Value = request.Username;
    // Add the parameter to the command object
    cmd.Parameters.Add(paramUsername);
    
    // Password
    cmd.Parameters.AddWithValue("@Password", request.Password).Size = 100;


    // Loop through the parameters and print the name and value
    foreach (SqliteParameter param in cmd.Parameters)
    {
        logger.LogWarning("Parameter Name: {Name}; Value: {Value}", param.ParameterName, param.Value);
    }

    // Execute the query
    var status = Convert.ToInt32(cmd.ExecuteScalar());
    // Check the returned number
    if (status == 1)
    {
        // We are now logged in
        logger.LogInformation("User logged in successfully");
        return Results.Ok();
    }

    logger.LogError("Login Failed");
    // Return a 401
    return Results.Unauthorized();
});
```

`Dapper` has a much simpler way to interact with parameters - the `DynamicParameters` object.

We can update our code as follows:

```c#
app.MapPost("/Login", (SqliteConnection cn, ILogger<Program> logger, LoginRequest request) =>
{
    var param = new DynamicParameters();
    // Create the Username parameter, specifying all the details
    param.Add("Username", request.Username, DbType.String, ParameterDirection.Input, 100);
    // Crete the password parameter
    param.Add("Password", request.Password);
    // Set the command query text
    var query = "SELECT 1 FROM USERS WHERE Username=@Username AND Password=@Password";
    // Execute the query
    var status = cn.QuerySingleOrDefault<int>(query, param);
    // Check the returned number
    if (status == 1)
    {
        // We are now logged in
        logger.LogInformation("User logged in successfully");
        return Results.Ok();
    }

    logger.LogError("Login Failed");
    // Return a 401
    return Results.Unauthorized();
});
```

A couple of things of interest:

1. The code is much **less**.
2. You don't need to do a lot of the **routime** work of opening the connection yourself, or dealing with the [DBCommand](https://learn.microsoft.com/en-us/dotnet/api/system.data.common.dbcommand?view=net-9.0) class; in the case of [Sqlite](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlite?view=msdata-sqlite-9.0.0), the [SqliteCommand](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlite.sqlitecommand?view=msdata-sqlite-8.0.0)
3. When it comes to `parameters`, you can either specify exhaustively each `parameter` setting - **name**, **value**, **data type**, **[direction](https://learn.microsoft.com/en-us/dotnet/api/system.data.parameterdirection?view=net-9.0)** (input or output parameter), and **size**, or you can just specify the **minimum** required settings - the **name** and the **value**. **Most of the time, the latter is sufficient**.
4. We are using the generic `QuerySingleOrDefault<T>` rather than `QuerySingle<T>,` which we used in the initialization code. The difference is that `QuerySingle` will **throw an exception if you are expecting a result and none returns** (as is the case with a failed login) but `QuerySingleOrDefault` will return the **default of the expected type**  - `0` for `int`.
5. `Parameter` names do not need a prefix like `@`, $ or `:`
6. We don't need to manage the **opening** and **closing** of **connections** for ourselves.

Currently, we are using the Sqlite [SqliteConnection](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlite.sqliteconnection?view=msdata-sqlite-9.0.0) object to interface with the database. If, in the future, we needed to upgrade to SQLServer, we would do the following:

1. Install the SQL Server data access library - [Microsoft.Data.SqlClient](https://www.nuget.org/packages/microsoft.data.sqlclient)
2. Use the [SqlConnection](https://learn.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient.sqlconnection?view=sqlclient-dotnet-standard-5.2) object rather than the `SqliteConnection`

`Dapper` will (largely) continue to work unchanged

Of course, **you may need to adjust your queries to factor in the nuances of the database engine.**

The same will apply to other database engines.

| Database   | Package                                                      | Connection         |
| ---------- | ------------------------------------------------------------ | ------------------ |
| PostgreSQL | [Npgsql](https://github.com/npgsql/npgsql)                   | `NpgConnection`    |
| MySQL      | [MySql.Data](https://www.nuget.org/packages/mysql.data/)     | `MySqlConnection`  |
| Oracle     | [Oracle.ManagedDataAccess](https://www.nuget.org/packages/oracle.manageddataaccess) | `OracleConnection` |

In our [next post]({% post_url 2025-02-26-dapper-part-2-querying-the-database %}), we will look at how to fetch data from the database.

### TLDR

**Dapper makes it very simple to interact with databases, avoiding the complexity of directly using ADO.NET.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-25%20-%20Dapper).

Happy hacking!
