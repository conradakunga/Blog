---
layout: post
title: Beware - Handling Of 2 Digit Years In SQL Server T-SQL
date: 2024-12-26 02:09:23 +0300
categories:
    - SQL Server
    - T-SQL
---

SQL Server's TSQL engine is very versatile when it comes to understanding dates.

If you have this declaration:

```sql
DECLARE @Date Date
```

SQL Server is smart enough to figure out all these are the same date:[]()

```sql
SET @Date = '26 December 2024'
SET @Date = '26 Dec 2024'
SET @Date = '26Dec2024'
SET @Date = '26Dec24'
SET @Date = '26 Dec 24'
SET @Date = 'Dec 26 2024'
SET @Date = 'December 26 2024'
SET @Date = 'December 26 24'
```

You need to be extremely careful when you specify the year with only two digits.

Given the following assignments:

```sql
declare @Date1 date ='26dec00'
declare @Date2 date ='26dec24'
declare @Date3 date ='26dec49'
declare @Date4 date ='26dec50'
declare @Date5 date ='26dec99'
```

If you output them as follows:

```sql
select @Date1
union all
Select @Date2
union all
select @Date3
union all
select @Date4
union all
select @Date5
```

You will get the following results:

```plaintext
2000-12-26
2024-12-26
2049-12-26
1950-12-26
1999-12-26
```

Any two-digit year past **49** is considered part of the [20th century](https://en.wikipedia.org/wiki/20th_century) (1901-2000), so `26dec50` is considered **26 December 1950**, while `26dec99` is considered **26 December 1999**.

If you want to change this behaviour, say to 2070, you can run the following script:

```sql
USE master;
GO

EXECUTE sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

EXECUTE sp_configure 'two digit year cutoff', 2070;
GO

RECONFIGURE;
GO

EXECUTE sp_configure 'show advanced options', 0;
GO

RECONFIGURE;
GO
```

The current default is **2049**.

You will need `ALTER SETTINGS` permissions. The change takes place immediately.

Happy hacking!

