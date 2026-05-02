---
layout: post
title: Beware - User vs "User" in PostgreSQL
date: 2026-03-24 19:43:12 +0300
categories:
    - Database
    - PostgreSQL
---

[PostgreSQL](https://www.postgresql.org/) stores its users in a table named `user`, which is visible to all **sessions** and all **tables**.

```sql
SELECT * from user
```

This returns a result set as follows (will be different for you)

![publicspies](../images/2026/03/publicspies.png)

You might, for whatever reason, want to store the **users** of your **application** in a table named `user`.

`PostgreSQL` will not let you do this, at least not directly.

```sql
create table user(userid int, fullnames varchar(100) not null  unique )
```

You will get the following error:

![usersTableFail](../images/2026/03/usersTableFail.png)

If you really want to do this, enclose `user` in **double quotes**.

```sql
create table "user"(userid int, fullnames varchar(100) not null  unique )
```

However, you must be very **careful when querying** this table, as you must always remember to **include the quotes to refer to your table**.

Without the quotes:

![userWithoutQuotes](../images/2026/03/userWithoutQuotes.png)

With the quotes:

![userWithQuotes](../images/2026/03/userWithQuotes.png)

This is **important** because if you have code like this:

```sql
SELECT CASE
           WHEN EXISTS (SELECT 1 FROM "user") THEN 'Users exist'
           ELSE 'not exists'
           END;
```

You can see from the screenshots below you can get unexpected results if you **forget** the quotes.

![quoteSuccess](../images/2026/03/quoteSuccess.png)

![quoteFailed](../images/2026/03/quoteFailed.png)

### TLDR

**If your *users* table is named `user`, you must quote the table name to prevent the system users table from being used instead.**

Happy hacking!
