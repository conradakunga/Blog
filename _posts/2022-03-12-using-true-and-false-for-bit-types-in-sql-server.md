---
layout: post
title: Using 'TRUE' and 'FALSE' For Bit Types In SQL Server
date: 2022-03-12 08:55:51 +0300
categories:
    - SQL
    - SQL Server
---
SQL Server, as you are no doubt aware, has a type that can be used to represent boolean states - `true` and `false`.

This type is called [BIT](https://docs.microsoft.com/en-us/sql/t-sql/data-types/bit-transact-sql?view=sql-server-ver15)

`true` is represented as 1, and `false` as 0.

Like so:

```sql
DECLARE @IsDaylight BIT = 1;
DECLARE @IsNightTime BIT = 0;

SELECT
    @IsDaylight  IsDayLight,
    @IsNightTime IsNightTime;
```

If you run this it will print the following:

| IsDayLight    | IsNightTime |
|:---------------:|:----------------:|
| 1 | 0 |

What you might not know is that you can use `strings` to represent true and false values.

```sql
SET @IsDaylight = 'FALSE';
SET @IsNightTime = 'TRUE';

SELECT
    @IsDaylight  IsDayLight,
    @IsNightTime IsNightTime;
```

The strings have to be the values '`True`' or '`False`' (not case sensitive). Any other values will give you an error.

I think this is easier to read than 0 or 1.

Running the script will return the following:

| IsDayLight    | IsNightTime |
|:---------------:|:----------------:|
| 0 | 1 |

Another interesting thing to note - **any value that is not 0 is considered `true`**, including negative numbers.

```sql
SET @IsDaylight = 2

SELECT
    @IsDaylight IsDayLight;

SET @IsDaylight = -1;
SELECT
    @IsDaylight IsDayLight;
```

This script will print the following:

| IsDayLight    |
|:---------------:|
| 1 |


| IsDayLight    |
|:---------------:|
| 1 |

Happy hacking!