---
layout: post
title: FIX - SQL Server Database Stuck In 'Restoring' State
date: 2026-03-01 22:12:10 +0300
categories:
    - SQL Server
    - FIX
---

Recently, I noticed one of my [SQL Server](https://www.microsoft.com/en-us/sql-server) databases had been **stuck** in a 'Restoring' state for quite some time.

Which was strange, because I had not done anything to the database in question.

It looked like this:

![restoring](../images/2026/03/restoring.png)

And it was stuck in that state for **hours**.

While in this state, you naturally **cannot connect** to the database.

The solution is to run the following command:

```sql
RESTORE DATABASE InnovaSuite WITH RECOVERY
```

This will restore the database and make it accessible.

![recoveredRestore](../images/2026/03/recoveredRestore.png)

### TLDR

**You can recover databases stuck in the *Restoring* state using the `RESTORE DATABASE` command.**

Happy hacking!
