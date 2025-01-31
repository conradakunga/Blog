---
layout: post
title: Beware - Mapping Classes With ReadOnly Properties Using Dapper With VB.NET, C# & F#
date: 2025-01-31 22:56:03 +0300
categories:
    - C#
    - Dapper
    - VB.NET
    - F#
---

One of the most monotonous tasks in building applications is **mapping data between your domain types and storage**.

There are, of course, a number of solutions to this problem - you could always use a full [ORM](https://en.wikipedia.org/wiki/Object–relational_mapping) (object-relational mapper) like [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/).

Of, especially if you have **legacy code**, you can use an excellent library called [Dapper](https://github.com/DapperLib/Dapper).

`Dapper` is implemented as several [extension methods](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods) to objects extending the [DbConnection](https://learn.microsoft.com/en-us/dotnet/api/system.data.common.dbconnection?view=net-9.0) object. This means it will work for any complete [ADO.NET providers](https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/data-providers) for [SQL Server](https://www.microsoft.com/en-gb/sql-server/sql-server-2022), [PostgreSQL](https://www.postgresql.org), [MySQL](https://www.mysql.com), [SQLite](https://www.sqlite.org), etc.

Let us assume we had this very simple object with a single property:

```c#
public class Result
{
  public DateTime Value { get; set; }
}
```

To use this, we start by installing the `Dapper` package into our program.

```bash
dotnet add package Dapper
```

Then, we add the data access libraries for SQL Server, [Microsoft.Data.SqlClient](https://www.nuget.org/packages/microsoft.data.sqlclient), which we will use in this example

```bash
dotnet add package Microsoft.Data.SqlClient
```

We can then write the code to map the current date on the database server onto this `Result` object.

```c#
using Dapper;
using Microsoft.Data.SqlClient;

var cn = new SqlConnection("Data Source=localhost;uid=sa;pwd=YourStrongPassword123;TrustServerCertificate=True");
var result = cn.QuerySingle<Result>("SELECT GETDATE() as Value");

Console.WriteLine(result.Value);
```

You should see the current date printed on the console.

```plaintext
31/01/2025 23:11:23
```

I am a huge proponent of [immutable types](https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/immutability), as it prevents inadvertent changing of state.

You can modify the Result class as appropriate.

```c#
public class Result
{
    public DateTime Value { get; set; }
}
```

This will still work, as `Dapper` will, behind the scenes, do some [reflection](https://www.geeksforgeeks.org/what-is-reflection-in-c-sharp/) to set the value appropriately.

Given that `Dapper` is a .NET library, it would work the same with other languages, so let us create a [VB.NET](https://learn.microsoft.com/en-us/dotnet/visual-basic/) project.

```bash
dotnet new console -o DapperTestVB -lang VB
```

We then add the `Dapper` and `Microsoft.Data.SqlClient`.

Finally, we create our types.

The first `Result` type is as follows:

```vb
Public Class Result
    public Property Value as DateTime 
End Class
```

Our VB.NET program will look like this:

```c#
Imports System
Imports Dapper
Imports Microsoft.Data.SqlClient

Module Program
    Sub Main(args As String())
        dim cn = new SqlConnection("Data Source=localhost;uid=sa;pwd=YourStrongPassword123;TrustServerCertificate=True")
        dim result = cn.QuerySingle (Of Result)("SELECT GETDATE() as Value")

        Console.WriteLine(result.Value)
    End Sub
End Module
```

You might be wondering why there is a `Module`, a `Main` class, etc. This is because VB.NET **does not support top-level statements**, and so we have to write a full traditional program.

Nevertheless, this code will still run.

```plaintext
31/01/2025 23:29:13
```

In VB.NET, we indicate a read-only property with the [ReadOnly](https://learn.microsoft.com/en-us/dotnet/visual-basic/language-reference/modifiers/readonly) keyword.

We can update our class as follows:

```vb
Public Class Result
    public ReadOnly Property Value as DateTime 
End Class
```

If we run this program, we get the following result:

```plaintext
01/01/0001 00:00:00
```

What has happened here? 

`Dapper` has been unable to map the property and has thus returned the default em**p**ty `DateTime` - year, month, date, hour, minute, and second are all 0.

This means that the behavior is different with VB.NET - it is unable to bind to read-only properties.

You might be wondering if [F#](https://learn.microsoft.com/en-us/dotnet/fsharp/what-is-fsharp) has this problem.

In F#, we can define our type thus:

```F#
type Result = { Value: System.DateTime }
```

By default, types in F# are [immutable](https://learn.microsoft.com/en-us/dotnet/fsharp/tutorials/functional-programming-concepts), and you have to go out of your way to change this.

Our program would look like this:

```F#
open Microsoft.Data.SqlClient
open Dapper

let connectionString =
    "Data Source=localhost;uid=sa;pwd=YourStrongPassword123;TrustServerCertificate=True"

let cn = new SqlConnection(connectionString)
let result = cn.QuerySingle<Result>("SELECT GETDATE() as Value")

printfn $"%A{result.Value}"
```

This, unsurprisingly, prints the correct result:

```plaintext
31/01/2025 23:39:13
```

### TLDR

**`Dapper` cannot bind to read-only properties when implemented in a VB.NET program.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-01-30%20-%20Dapper).

Happy hacking!
