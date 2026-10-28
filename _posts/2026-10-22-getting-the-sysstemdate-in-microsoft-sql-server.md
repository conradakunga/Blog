---
layout: post
title: Getting the System Date in Microsoft SQL Server
date: 2026-10-22 18:49:22 +0300
categories:
    - SQL Server
---

When it comes to getting the current date and time in [Microsoft SQL Server](https://www.microsoft.com/en/sql-server), you have a number of options:

## GETDATE()

The [GETDATE()](https://learn.microsoft.com/en-us/sql/t-sql/functions/getdate-transact-sql?view=sql-server-ver17) function is usually the go-to for most people.

You can invoke it from pretty much anywhere, even in the definition of **default** values.

```sql
SELECT GETDATTE()
```

## SYSDATETIME()

We also have access to the [SYSDATETIME()](https://learn.microsoft.com/en-us/sql/t-sql/functions/sysdatetime-transact-sql?view=sql-server-ver17) function, which is pretty much a drop-in replacement for `GETDATE()`. 

This returns a `DateTime2(7)`

```sql
SELECT SYSDATETIME()
```

## CURRENT_TIMESTAMP

Another option is the [CURRENT_TIMESTAMP](https://learn.microsoft.com/en-us/sql/t-sql/functions/current-timestamp-transact-sql?view=sql-server-ver17) function **(note the lack of opening and closing brackets).**

These are specific to the server's **current locale.** For `date` functions that factor in time zones, that is the stuff of a **future post**.

### TLDR

**There are a number of different ways to get the current date from the server.**

Happy hacking!

