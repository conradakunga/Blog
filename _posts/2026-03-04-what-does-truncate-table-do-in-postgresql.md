---
layout: post
title: What Does Truncate Table Do In PostgreSQL
date: 2026-03-04 19:48:10 +0300
categories:
    - PostgreSQL
    - Database
---

Yesterday's post, "[What Does Truncate Table Do In SQL Server]()", looked at what happens when we execute the [TRUNCATE TABLE](https://learn.microsoft.com/en-us/sql/t-sql/statements/truncate-table-transact-sql?view=sql-server-ver17) command in a [SQL Server](https://www.microsoft.com/en-us/sql-server) Database.

In this post, we will look at the same, but for a [PostgreSQL](https://www.postgresql.org/) database.

Let us create two tables for this purpose:

```sql
create table user_types (user_typeID int primary key, Name varchar(100) not null )

create table  users(user_id int primary key, user_typeID int not null  references user_types(user_typeid), name nvarchar(50) not null  unique )
```

We then seed it as follows

```sql
insert into user_types values (1, 'Normal')
insert into user_types values (2, 'Admin')
insert into users values (1,1,'James')
insert into users values (2,2,'Jane')
```

`PostgreSQL` also has a `TRUNCATE` table command, and in many ways it is **similar** to the `SQL Server` version.

1. Will not fire `DELETE` triggers
2. By default, it will not run on tables **participating in foreign keys**
3. Can be wrapped in a **transaction**

There are also some differences:

## TRUNCATE Trigger

Unlike `SQL Server,` `PostgreSQL` offers [triggers](https://www.postgresql.org/docs/18/sql-createtrigger.html) for `TRUNCATION` events:

- **BEFORE** TRUNCATE
- **ON** TRUNCATE
- **AFTER** TRUNCATE

## Identity Reset

You can specify whether or not you want **IDENTITY** columns to **reset**. By default, they **won't**.

```sql
TRUNCATE users RESTART IDENTITY;
```

To be explicit that you want any **IDENTITY** values to continue:

```sql
TRUNCATE users CONTINUE IDENTITY;
```

## Foreign Keys

If the table is **referenced** by **foreign keys**, you have options:

`TRUNCATE` both tables at the same time, like this:

```sql
TRUNCATE TABLE users, user_types
```

Specify `CASCADE` when doing the `TRUNCATE`, like this:

```sql
TRUNCATE TABLE user_types CASCADE
```

In many ways, the `PostgreSQL` version of `TRUNCATE` is more flexible.

In `PostgreSQL`, the `TRUNCATE TABLE` command requires the `TRUNCATE` [privilege](https://www.postgresql.org/docs/current/ddl-priv.html).

### TLDR

**`PostgreSQL` also has a TRUNCATE TABLE command that is much more flexible than the `SQL Server` equivalent.**

Happy hacking
