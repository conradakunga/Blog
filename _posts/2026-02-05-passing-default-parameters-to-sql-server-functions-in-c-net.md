---
layout: post
title: Passing Default Parameters to SQL Server Functions in C# & .NET
date: 2026-02-05 21:39:18 +0300
categories:
    - C#
    - .NET
    - SQL Server
---

Yesterday's post, "[Beware - The Folly of Default Parameters in SQL Server Stored Procedures]({% post_url 2026-02-04-beware-the-folly-of-default-parameters-in-sql-server-stored-procedures %})", looked at a gotcha that might catch you off guard if you do not have **robust** [integration tests](https://www.geeksforgeeks.org/software-testing/software-engineering-integration-testing/) for your [Microsoft SQL Server](https://learn.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver17) database.

Given SQL Server also supports [fuctions](https://learn.microsoft.com/en-us/sql/relational-databases/user-defined-functions/user-defined-functions?view=sql-server-ver17) one might wonder - **are they susceptible to the same problem**?

We can rewrite the `procedure` as a `function`, thus:

```sql
CREATE OR ALTER FUNCTION fn_GetDayOfWeek
    (
        @Day TINYINT
    )
RETURNS NVARCHAR(15)
AS
    BEGIN
        DECLARE @Return NVARCHAR(15);
        SELECT
            @Return = CASE @Day
                          WHEN 1
                              THEN
                              'Monday'
                          WHEN 2
                              THEN
                              'Tuesday'
                          WHEN 3
                              THEN
                              'Wednesday'
                          WHEN 4
                              THEN
                              'Thursday'
                          WHEN 5
                              THEN
                              'Friday'
                          WHEN 6
                              THEN
                              'Saturday'
                          WHEN 7
                              THEN
                              'Sunday'
                      END;
        RETURN @Return;
    END;
GO


```

This is called like this (using [Dapper](https://github.com/DapperLib/Dapper)):

```c#
using Dapper;
using Microsoft.Data.SqlClient;

const string connection = "Data Source=;database=Spies;uid=sa;pwd=YourStrongPassword123;TrustServerCertificate=True;";

await using (var cn = new SqlConnection(connection))
{
    var result = await cn.QuerySingleAsync<string>("SELECT dbo.fn_GetDayOfWeek(@Day)", new { Day = 3 });
    Console.WriteLine(result);
}
```

`Functions`, like `stored procedures`, also support **default values**.

So we can do the following:

```sql
CREATE OR ALTER FUNCTION fn_GetDayOfWeek
    (
        @Day TINYINT = 4
    )
RETURNS NVARCHAR(15)
AS
    BEGIN
        DECLARE @Return NVARCHAR(15);
        SELECT
            @Return = CASE @Day
                          WHEN 1
                              THEN
                              'Monday'
                          WHEN 2
                              THEN
                              'Tuesday'
                          WHEN 3
                              THEN
                              'Wednesday'
                          WHEN 4
                              THEN
                              'Thursday'
                          WHEN 5
                              THEN
                              'Friday'
                          WHEN 6
                              THEN
                              'Saturday'
                          WHEN 7
                              THEN
                              'Sunday'
                      END;
        RETURN @Return;
    END;
GO


```

So, you might wonder, what happens if **we don't pass a parameter at all**?

```c#
await using (var cn = new SqlConnection(connection))
{
    var result = await cn.QuerySingleAsync<string>("SELECT dbo.fn_GetDayOfWeek(@Day)");
    Console.WriteLine(result);
}
```

You will get the following exception:

```plaintext
Unhandled exception. Microsoft.Data.SqlClient.SqlException (0x80131904): Must declare the scalar variable "@Day".
   at Microsoft.Data.SqlClient.SqlCommand.<>c.<ExecuteDbDataReaderAsync>b__270_0(Task`1 result)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location ---
   at System.Threading.ExecutionContext.RunInternal(ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location ---
   at Dapper.SqlMapper.QueryRowAsync[T](IDbConnection cnn, Row row, Type effectiveType, CommandDefinition command) in /_/Dapper/SqlMapper.Async.cs:line 489
   at Program.<Main>$(String[] args) in /Users/rad/Projects/BlogCode/2026-02-06 - DefaultPararemterFunctions/Program.cs:line 14
   at Program.<Main>$(String[] args) in /Users/rad/Projects/BlogCode/2026-02-06 - DefaultPararemterFunctions/Program.cs:line 16
   at Program.<Main>(String[] args)
ClientConnectionId:ec73ab70-9fad-463c-baff-08c282fe4692
Error Number:137,State:2,Class:15

```

So, then **how** do we pass a **default parameter**?

```c#
await using (var cn = new SqlConnection(connection))
{
    var result = await cn.QuerySingleAsync<string>("SELECT dbo.fn_GetDayOfWeek(DEFAULT)");
    Console.WriteLine(result);
}
```

This means **you cannot actually forget to pass a parameter** and expect the function to execute.

### TLDR

**To invoke a function with default parameters, you must pass `DEFAULT` as the argument to the parameter.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-02-06%20-%20DefaultPararemterFunctions).

Happy hacking!
