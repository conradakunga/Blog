---
layout: post
title: Check SQL Server Edition in T-SQL
date: 2025-10-17 20:22:48 +0300
categories:
    - SQL Server    
    - TSQL
---

In yesterday's post, "[Check SQL Server Version in T-SQL]({% post_url 2025-10-16-check-sql-server-version-in-t-sql %})", we looked at how to check the **version** of [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server) you are connected to.

A similar problem is when you need to verify the [edition](https://learn.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-2022?view=sql-server-ver17) you are connected to.

Remember, as of SQL Server `2022`, these are the available editions:

| Edition    | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| Express    | Free, entry-level database                                   |
| Web        | Low-cost edition primarily for web hosting scenarios         |
| Standard   | Edition with standard functionality to support small enterprises as a database management system and business intelligence platform |
| Enterprise | Premium edition with all the bells and whistles, including virtualization |
| Developer  | This is the same as the enterprise version, but only licensed for development use. |

In the post "[About The SQL Server 2025 Editions]({% post_url 2025-10-13-about-the-sql-server-2025-editions %})", I had mentioned a problem you might run into where the **Developer** edition is the same as the **Enterprise** edition in terms of features, but you might run into deployment issues if the **target** environment is not **Enterprise**.

You might therefore need to **check the edition of SQL Server that you are connected to**.

For this, we again turn to [SERVERPROPERTY](https://learn.microsoft.com/en-us/sql/t-sql/functions/serverproperty-transact-sql?view=sql-server-ver17) and retrieve the `Edition` property.

Like so:

```sql
SELECT
    SERVERPROPERTY('Edition') AS ProductVersion
```

This will return the actual edition you are connected to:

```plaintext
Developer Edition (64-bit)
```

Possible return values are as follows:

| **Edition**                |
| -------------------------- |
| Developer Edition (64-bit) |
| Enterprise Edition         |
| Standard Edition           |
| Express Edition            |
| Web Edition                |

### TLDR

**You can obtain the *edition* of SQL Server you are connected to by querying the `Edition` of `SERVERPROPERTY`**

Happy hacking!
