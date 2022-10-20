---
layout: post
title: Tip - SQL Server Management Studio - Reorder Lines
date: 2022-10-20 14:08:46 +0300
categories:
    - SQL Server
    - SQL Server Management Studio
    - Tips
---
Most of your time when working with the SQL Server Management Studio you will be writing and modifying queries.

A common scenario is you want to move around the lines in a query.

So assuming we have this query:

```sql
SELECT
    Countries.CountryID,
    Countries.Name,
    Countries.Code,
    Countries.EditUserID,
    Countries.DateModified,
    Countries.CreateUserID,
    Countries.DateCreated,
    Countries.Approved,
    Countries.ApprovedUserID,
    Countries.DateApproved
FROM
    dbo.Countries;
```

If we want to change the order of Name and Code we would have to:

1. Highlight the row with Code
1. Cut (`Ctrl + C`)
1. Move the cursor up ⬆
1. Press Enter
1. Paste (`Ctrl + V`)
1. Move the cursor 2 lines down ⬇⬇
1. Delete the space ❌

Alternatively, you can hold down `ALT` and move the current line with the cursor up ⬆ or down ⬇ with the keyboard arrows.

Like so:

![](../images/2022/10/ReorderLines.gif)

Happy hacking!