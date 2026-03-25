---
layout: post
title: Beware - The Folly of Default Parameters in SQL Server ßStored Procedures
date: 2026-02-05 18:27:11 +0300
categories:
    - C#
    - .NET
    - SQL Server
---

The question of whether or not to use **stored procedures** in application development is one that can generate considerable heat due to the strong opinions held by the two camps:

1. **Never** use stored procedures.
2. Use stored procedures **whenever possible**.

And there are valid arguments for both sides.

![proceduresSuck](../images/2026/02/proceduresSuck.png)

## Pros

1. Logic is **centralized** in one place
2. Issues can (often) be fixed **after deployment**
3. An experienced DBA can assist in **improving design** and **performance**
4. You have granular **security control** over table access and procedure execution
5. **Logic can be shared** across applications (where applicable)

## Cons

1. Developers may **not have access to the database** (or the DBA)
2. Use of **constructs** like loops is **clunky**
3. Cannot leverage **logic and libraries outside** of what the database provides
4. **Version control and maintainability** can be a challenge
5. **IDE and tooling support** (refactoring, etc.) is usually a challenge

As always, I am ever the **pragmatist**. There are occasions when they are **appropriate** and when they **aren't**.

**Adapt accordingly**.

Stored procedures are essentially logic that is stored in the database that can be called from applications.

Take this simplistic [T-SQL](https://learn.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver17) (**Microsoft SQL Server**) that returns the day of the week:

```sql
CREATE OR ALTER PROC GetDayOfWeek @Day TINYINT
AS
    BEGIN
        SELECT
            CASE @Day
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
                ELSE
                    'Sunday'
            END;
    END;
```

You would use it like this:

```sql
EXEC GetDayOfWeek
    @Day = 3;
```

Which will return:

```plaintext
Wednesday
```

You can invoke this from **code**, using my preferred method - [Dapper](https://github.com/DapperLib/Dapper).

```c#
using Dapper;
using Microsoft.Data.SqlClient;

const string connection = "Data Source=;database=Spies;uid=sa;pwd=YourStrongPassword123;TrustServerCertificate=True;";

await using (var cn = new SqlConnection(connection))
{
    var result = await cn.QuerySingleAsync<string>("GetDayOfWeek", new { Day = 3 });
    Console.WriteLine(result);
}
```

This will print the same result.

One feature of stored procedures is that they allow you to pass **default parameters**. There are **values that will be used if none are provided** for the call.

This means you can do this:

```sql
CREATE OR ALTER PROC GetDayOfWeek @Day TINYINT = 4
AS
    BEGIN
        SELECT
            CASE @Day
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
                ELSE
                    'Sunday'
            END;
    END;
GO
```

`4` here is the default parameter.

![defaultParameter](../images/2026/02/defaultParameter.png)

This means if you call this procedure without passing any parameters, it will use that value.

You can see where this is going.

```c#
await using (var cn = new SqlConnection(connection))
{
    var result = await cn.QuerySingleAsync<string>("GetDayOfWeek");
    Console.WriteLine(result);
}
```

This code will print:

```plaintext
Thursday
```

This **may or may not be what you want!**

If you **forgot** to pass the parameter, or it got **deleted** by accident, the procedure will **always return the same result**.

You may argue that this can be caught by [integration tests](https://www.geeksforgeeks.org/software-testing/software-engineering-integration-testing/).

It depends on the **quality** of the tests in question.

If the **test** value happens to be the **default** value, your test will, in fact, **pass**!

How to migtigate against this?

1. Increase the number of **test cases**
2. **Avoid** using default parameters
3. Use an **obvious** default value that you can use to tell there is a problem

One way would be this:

```sql
CREATE OR ALTER PROC GetDayOfWeek @Day TINYINT = 8
AS
    BEGIN
        SELECT
            CASE @Day
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
                    'Satruday'
                WHEN 7
                    THEN
                    'Sunday'
                ELSE
                    'This is a problem!'
            END;
    END;
GO
EXEC GetDayOfWeek
```

Or, more explicitly:

```sql
CREATE OR ALTER PROC GetDayOfWeek @Day TINYINT = 8
AS
    BEGIN
        IF @Day = 8
            BEGIN
                RAISERROR('Something went wrong', 16, 1);
                RETURN;
            END;
        SELECT
            CASE @Day
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
                    'Satruday'
                WHEN 7
                    THEN
                    'Sunday'
            END;
    END;
GO
EXEC GetDayOfWeek;

```

Personally, I would prefer a combination of the **previous** method and robust tests.

### TLDR

**If you forget to pass parameters to a stored procedure and have specified default values, the procedure will run silently and successfully with those default values.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-02-05%20-%20DefaultPararemterProcedures).

Happy hacking!
