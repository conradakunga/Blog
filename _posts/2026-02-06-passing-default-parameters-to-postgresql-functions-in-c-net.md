---
layout: post
title: Passing Default Parameters to PostgreSQL Functions in C# & .NET
date: 2026-02-06 22:16:40 +0300
categories:
    - C#
    - .NET
    - PostgreSQL
---

Yesterday's post, "[Passing Default Parameters to SQL Server Functions in C# & .NET]({% postt_url 2026-02-05-passing-default-parameters-to-sql-server-functions-in-c-net %})", looked at how to call functions in [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server) [T-SQL](https://learn.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver17) functions and pass them **default** values.

In today's post, we will look at the same thing for [PostgreSQL](https://www.postgresql.org/).

The `function` we will use is as follows:

```sql
CREATE OR REPLACE FUNCTION get_day_of_week(day INT)
    RETURNS TEXT
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN CASE day
               WHEN 1 THEN 'Monday'
               WHEN 2 THEN 'Tuesday'
               WHEN 3 THEN 'Wednesday'
               WHEN 4 THEN 'Thursday'
               WHEN 5 THEN 'Friday'
               WHEN 6 THEN 'Saturday'
               ELSE 'Sunday'
        END;
END;
$$;
```

The function is invoked as follows, using [Dapper](https://github.com/DapperLib/Dapper):

```c#
using Dapper;
using Npgsql;

const string connection = "host=localhost;username=myuser;password=mypassword;database=spies";

await using (var cn = new NpgsqlConnection(connection))
{
    var result = await cn.QuerySingleAsync<string>("SELECT get_day_of_week(@Day)", new { Day = 3 });
    Console.WriteLine(result);
}
```

If you want to call the `function` with its **default** value, you invoke it like this:

```c#
await using (var cn = new NpgsqlConnection(connection))
{
    var result = await cn.QuerySingleAsync<string>("SELECT get_day_of_week()");
    Console.WriteLine(result);
}
```

Note that the invocation is **not passing any parameters** at all:

```c#
 var result = await cn.QuerySingleAsync<string>("SELECT get_day_of_week()");
```

### TLDR

**You can invoke functions in `PostgreSQL` and pass any required parameters. You can also instruct the database to use the function's default parameters by not passing anything.**

The code is in my GitHub.

Happy hacking!
