---
layout: post
title: Check SQL Server Version in T-SQL
date: 2025-10-16 19:12:13 +0300
categories:
    - SQL Server
    - TSQL
---

If you are working with [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server) as your database, you might find yourself in a position where you need to verify the **version of SQL Server** that you are connected to.

Perhaps you just want to **confirm the capabilities**, or you have some **conditional logic that is version-specific**.

You can interrogate the server and query the [SERVERPROPERTY](https://learn.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql?view=sql-server-ver16) property.

The **property** you are interested in here is `ProductVersion`

You fetch it like this:

```sql
SELECT
    SERVERPROPERTY('ProductVersion') AS ProductVersion;
```

This will return a result like this:

```plaintext
16.0.4215.2
```

The leading `16` will tell you the version of SQL Server.

The other values are as follows:

- `0` - minor version
- `4215` - build version
- `2` - revision

Below are the major versions of SQL Server that are still supported.

| **Major** | **SQL Server Version** | **Year** |
| --------- | ---------------------- | -------- |
| 16.x      | SQL Server 2022        | 2022     |
| 15.x      | SQL Server 2019        | 2019     |
| 14.x      | SQL Server 2017        | 2017     |
| 13.x      | SQL Server 2016        | 2016     |

The next version of SQL Server, [SQL Server 2025](https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2025), will presumably be major version `17`.

### TLDR

**You can query the `SERVERPROPERTY` to extract the version of SQL Server you are connected to.**

Happy hacking!
