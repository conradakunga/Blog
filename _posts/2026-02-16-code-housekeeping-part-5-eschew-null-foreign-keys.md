---
layout: post
title: Code Housekeeping - Part 5 - Eschew NULL Foreign Keys
date: 2026-02-16 22:13:54 +0300
categories:
    - C#
    - Languages
    - CodeHouseKeeping
    - Code
    - Quality
---

This is **Part 5** of the **CodeHousekeeping Series**.

**Code Housekeeping** refers to general rules of thumb that make code easier to **read**, **digest**, and **modify** for other developers, **yourself** included.

Yesterday's post, "Code Housekeeping - Part 4 - Avoid NULL Wherever Possible" addressed the issue of using NULL for unknown data.

Today's post is an extension of the same, but on the database end.

Take this table that stores `Person` entities:

```sql
CREATE TABLE Persons
    (
        PersonID  INT          PRIMARY KEY,
        FirstName NVARCHAR(50) NULL,
        LastName  NVARCHAR(50) NULL,
        GenderID  TINYINT      NULL
            REFERENCES dbo.Genders (GenderID)
    );

```

It is referencing a Genders table, that looks like this:

```sql
CREATE TABLE Genders
    (
        GenderID TINYINT PRIMARY KEY,
        Name     NVARCHAR(50)
    );
```

We can seed the `Genders` as follows:

```sql
INSERT dbo.Genders
    (
        GenderID,
        Name
    )
VALUES
    (
        1, 'Male'
    ),
    (
        2, 'Female'
    );
```

And we can also seed some `Person` entities:

```sql
INSERT dbo.Persons
    (
        PersonID,
        FirstName,
        LastName,
        GenderID
    )
VALUES
    (
        1, 'James', 'Bond', 1
    ),
    (
        2, 'Jason', 'Bourne', 1
    ),
    (
        3, 'Jane', 'Bond', 2
    );
```

We can now query our data as follows:

```sql
SELECT
        Persons.PersonID,
        Persons.FirstName,
        Persons.LastName,
        Genders.Name Gender
FROM
        dbo.Persons
    INNER JOIN
        dbo.Genders
            ON Genders.GenderID = Persons.GenderID;
```

This returns the following:

| Person ID | FirstName | LastName | Gender |
| --------- | --------- | -------- | ------ |
| 1 | James | Bond | Male |
| 2 | Jason | Bourne | Male |
| 3 | Jane | Bond | Female |

Now, let us add a Person for whom we don't know the `Gender`.

```sql
INSERT dbo.Persons
    (
        PersonID,
        FirstName,
        LastName,
        GenderID
    )
VALUES
    (
        4, 'Great', 'Scott', NULL
    );
```

Our query will return exactly the same data, as the join fails.

To get this `Person` back in the results we need to use an [outer join](https://www.geeksforgeeks.org/sql/sql-outer-join/).

```sql
SELECT
        Persons.PersonID,
        Persons.FirstName,
        Persons.LastName,
        Genders.Name Gender
FROM
        dbo.Persons
    LEFT OUTER JOIN
        dbo.Genders
            ON Genders.GenderID = Persons.GenderID;
```

This now returns the following:

| Person ID | FirstName | LastName | Gender |
| --------- | --------- | -------- | ------ |
| 1 | James | Bond | Male |
| 2 | Jason | Bourne | Male |
| 3 | Jane | Bond | Female |
| 4 | Great | Scott | `NULL` |

You can hide the NULL by doing something like this:

```sql
SELECT
        Persons.PersonID,
        Persons.FirstName,
        Persons.LastName,
        ISNULL(Genders.Name, 'UNKNOWN') Gender
FROM
        dbo.Persons
    LEFT OUTER JOIN
        dbo.Genders
            ON Genders.GenderID = Persons.GenderID;
```

Which now returns:

| Person ID | FirstName | LastName | Gender |
| --------- | --------- | -------- | ------ |
| 1 | James | Bond | Male |
| 2 | Jason | Bourne | Male |
| 3 | Jane | Bond | Female |
| 4 | Great | Scott | UNKNOWN |

Rather than go through all these gymnastics, create an explicit `Gender` where it is unknown.

```sql
INSERT dbo.Genders
    (
        GenderID,
        Name
    )
VALUES
    (
        3, 'UNKNOWN'
    )
```

So when the `Gender` is unknown, insert as follows:

```sql
INSERT dbo.Persons
    (
        PersonID,
        FirstName,
        LastName,
        GenderID
    )
VALUES
    (
        5, 'Evelyn', 'Salt', 3
    );
```

Our original query now returns the following:

| Person ID | FirstName | LastName | Gender |
| --------- | --------- | -------- | ------ |
| 1 | James | Bond | Male |
| 2 | Jason | Bourne | Male |
| 3 | Jane | Bond | Female |
| 5 | Evelyn | Salt | UNKNOWN |

### TLDR

Avoid NULL foreign keys.

The code is in my GitHub.

Happy hacking!