---
layout: post
title: What Does Truncate Table Do In SQL Server
date: 2026-03-03 19:24:17 +0300
categories:
    - SQL Server
---

If you have a large amount of data in a [SQL Server](https://www.microsoft.com/en-us/sql-server) table and want to quickly **purge** it, one way is to truncate the table using the [TRUNCATE](https://learn.microsoft.com/en-us/sql/t-sql/statements/truncate-table-transact-sql?view=sql-server-ver17) command.

```sql
TRUNCATE TABLE Users
```

This will quickly **purge** the table.

The caveat is that it only works under the following conditions:

1. The table has no [foreign keys](https://learn.microsoft.com/en-us/sql/relational-databases/tables/primary-and-foreign-key-constraints?view=sql-server-ver17)
2. The table is participating in [replication](https://learn.microsoft.com/en-us/sql/relational-databases/replication/sql-server-replication?view=sql-server-ver17)
3. The table is being used in an [indexed view](https://learn.microsoft.com/en-us/sql/relational-databases/views/create-indexed-views?view=sql-server-ver17)

You must also keep in mind the following considerations:

1. If the table has any [IDENTITY](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-table-transact-sql-identity-property?view=sql-server-ver17) columns, these are reset
2. `DELETE` [triggers](https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql?view=sql-server-ver17) will not fire

If this is in order, then you can truncate the table.

What happens internally is the following:

1. Data pages are **de-allocated**
2. **Minimal logging** takes place

This frees the database engine from the extensive work of doing row-by-row logging.

Another thing to keep in mind is that you can wrap `TRUNCATE` statements in [transactions](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver17), meaning that `ROLLBACK` and `COMMIT` work.

In other words, the following statements will reset the `Users` table to its original state.

```sql
BEGIN TRAN
TRUNCATE TABLE Users
ROLLBACK
```

### TLDR

**`TRUNCATE` is a quick way to empty a database table, provided it meets the criteria for truncation.**

Happy hacking!
