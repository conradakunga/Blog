---
layout: post
title: Connecting To MySQL & MariaDB using MySQLConnector in C# & .NET 
date: 2026-05-08 12:56:15 +0300
categories:
    - MySQL
    - MariaDB
    - Database
    - C#
    - .NET
---

When it comes to working with MySQL and MariaDB in C# & any of the languages on the .NET platform, the first port of call is which managed drivers to use.

Here, we have a number of choices:

| Driver                                                       | Comments                                                   |
| ------------------------------------------------------------ | ---------------------------------------------------------- |
| [MySqlConnector](https://mysqlconnector.net/)                | De facto standard, officially supporting MySQL and MariaDB |
| [MySql.Data](https://dev.mysql.com/downloads/)               | Official driver maintained by Oracle                       |
| [DevArt.Data.MySQL](https://www.devart.com/dotconnect/mysql/) | Commercial driver                                          |

In this post, we will look at how to use the [MySQLConnector](https://www.nuget.org/packages/MySqlConnector/) package.

Create a new project and then add the `MySqlConnector` package as follows:

```bash
dotnet add package MySqlConnector
```

We then write some code to **connect** to the database and fetch the **current date and time**.

```c#
using System.Data;
using MySqlConnector;

const string connectionString = "Server=localhost;userid=root;password=mystrongpassword123;database=testdb";

using (var cn = new MySqlConnection(connectionString))
{
    // Open the connection
    cn.Open();
    // Create a command object
    using (var cmd = cn.CreateCommand())
    {
        // Query the current date and time
        cmd.CommandText = "Select CURRENT_TIMESTAMP";
        // Get the result from command execution
        DateTime result = (DateTime)cmd.ExecuteScalar()!;
        // Write to console
        Console.WriteLine(result);
    }

    cn.Close();
}
```

You can also do it this way, though it is more **unwieldy**.

```c#
using System.Data;
using MySqlConnector;

const string connectionString = "Server=localhost;userid=root;password=mystrongpassword123;database=testdb";
using (var cn = new MySqlConnection(connectionString))
{
    // Open the connection
    cn.Open();
    // Create a command object
    using (var cmd = cn.CreateCommand())
    {
        // Query the current date and time
        cmd.CommandText = "Select CURRENT_TIMESTAMP";
        // Get a reader, specifying to close the connection when done
        using (var reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
        {
            // Fetch the date and time
            while (reader.Read())
            {
                // Write to console
                Console.WriteLine(reader.GetDateTime(0));
            }

            // Close the read
            reader.Close();
        }
    }
}
```

A benefit of this package is its support for [asynchronous](https://learn.microsoft.com/en-us/dotnet/csharp/asynchronous-programming/) operation.

So you can rewrite the previous samples.

The **scalar** version:

```c#
await using (var cn = new MySqlConnection(connectionString))
{
    // Open the connection
    await cn.OpenAsync();
    // Create a command object
    await using (var cmd = cn.CreateCommand())
    {
        // Query the current date and time
        cmd.CommandText = "Select CURRENT_TIMESTAMP";
        // Get the result from command execution
        DateTime result = (DateTime)(await cmd.ExecuteScalarAsync())!;
        // Write to console
        Console.WriteLine(result);
    }

    await cn.CloseAsync();
}
```

The **reader** version

```c#
using (var cn = new MySqlConnection(connectionString))
{
    // Open the connection
    await cn.OpenAsync();
    // Create a command object
    using (var cmd = cn.CreateCommand())
    {
        // Query the current date and time
        cmd.CommandText = "Select CURRENT_TIMESTAMP";
        // Get a reader, specifying to close the connection when done
        await using (var reader = await cmd.ExecuteReaderAsync(CommandBehavior.CloseConnection))
        {
            // Fetch the date and time
            while (await reader.ReadAsync())
            {
                // Write to console
                Console.WriteLine(reader.GetDateTime(0));
            }

            // Close the read
            await reader.CloseAsync();
        }
    }
}
```

If we run this program, we should get something like this in the console:

![consoleDates](../images/2026/05/consoleDates.png)

### TLDR

**You can use the `MySqlConnector` to connect to MySQL and MariaDB databases.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-05-08%20-%20MySqlConnection).

Happy hacking!
