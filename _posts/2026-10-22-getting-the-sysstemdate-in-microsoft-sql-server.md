---
layout: post
title: Getting The System Date in Microsoft SQL Server
date: 2026-10-22 18:49:22 +0300
categories:
    - SQL Server
---

When it comes to getting the current date and time in SQL Server, you have a number of options:

## GETDATE()

The function [GETDATE()](https://learn.microsoft.com/en-us/sql/t-sql/functions/getdate-transact-sql?view=sql-server-ver17)  is usually the goto that most people have used for years.

You can invoke it from pretty much anywhere, even in the definition of default columns.

```sql
SELECT GETDATTE()
```

## SYSDATETIME()

We also have access to the [SYSDATETIME()](https://learn.microsoft.com/en-us/sql/t-sql/functions/sysdatetime-transact-sql?view=sql-server-ver17) function, that is pretty much a drop-in replacement for `GETDATE()`. 

This returns a `DateTime2(7)`

```sql
SELECT SYSDATETIME()
```

## CURRENT_TIMESTAMP

Another option is the [CURRENT_TIMESTAMP](https://learn.microsoft.com/en-us/sql/t-sql/functions/current-timestamp-transact-sql?view=sql-server-ver17) function **(note the lack of opening and closing brackets).**

These are specifically for the **current locale on the server.** For `date` functions that factor in time zones, that is the stuff of a future post.

### TLDR

**There are a number of different ways to get the current date from the server.**

Happy hacking!

