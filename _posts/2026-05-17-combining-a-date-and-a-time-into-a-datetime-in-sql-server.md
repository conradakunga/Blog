---
layout: post
title: Combining A Date and a Time into a DateTime in SQL Server
date: 2026-05-17 20:48:50 +0300
categories:
    - SQL Server
---

In [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server), there are several types for handling dates and times.

- [DateTime](https://learn.microsoft.com/en-us/sql/t-sql/data-types/datetime-transact-sql?view=sql-server-ver17)
- [DateTime2](https://learn.microsoft.com/en-us/sql/t-sql/data-types/datetime2-transact-sql?view=sql-server-ver17)
- [DateTimeOffset](https://learn.microsoft.com/en-us/sql/t-sql/data-types/datetimeoffset-transact-sql?view=sql-server-ver17)
- [Time](https://learn.microsoft.com/en-us/sql/t-sql/data-types/time-transact-sql?view=sql-server-ver17)
- [Date](https://learn.microsoft.com/en-us/sql/t-sql/data-types/date-transact-sql?view=sql-server-ver17)

For this post, we will not deal with `DateTimeOffset`, as that has additional implications.

For `DateTime` and `DateTime2`, the `date` and `time` components are contained within the type.

```sql
declare @DateTime  datetime = getdate()
declare @DateTime2 datetime2 = getdate()

select @DateTime [DateTime], @DateTime2 [DateTime2]
```

If we run this, we will get the following:

![datetimeresults](../images/2026/05/datetimeresults.png)

The date and time types, however, are specialized.

```sql
declare @Date date=getdate()
declare @Time time = getdate()

select @Date [Date], @Time [Time]
```

This returns the following:

![dateandtimeresult](../images/2026/05/dateandtimeresult.png)

The situation may arise when you want to combine these `date` and `time` objects into a `DateTime`.

This is achieved as follows:

```sql
SELECT CAST(@Date AS DATETIME) + CAST(@Time AS DATETIME)
```

This will return the following:

![dateTimeResult](../images/2026/05/dateTimeResult.png)

Note: **this solution will not work for a `DateTime2`**. We will look at that in the next post.

### TLDR

**You can combine a SQL Server `date` and `time` into a `DateTime` using *casting* and *addition*.**

Happy hacking!
