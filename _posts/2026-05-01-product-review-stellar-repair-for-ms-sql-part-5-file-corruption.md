---
layout: post
title: "Product Review - Stellar Repair for MS SQL - Part 5: File Corruption"
date: 2026-05-01 16:41:08 +0300
categories:
    - Product Review
    - SQL Server
    - Stellar Repair
---

This is **Part 5** of an independent review of a product, [Stellar Repair for MS SQL,](https://www.stellarinfo.com/sql-recovery.php) from the folks at [Stellar Info](https://www.stellarinfo.com/).

The version being reviewed is `11.0.0.1`

- [Part 1 - Introduction]({% post_url 2026-04-27-product-review-stellar-repair-for-ms-sql-part-1-introduction %})
- [Part 2 - SQL Server Password Recovery]({% post_url 2026-04-28-product-review-stellar-repair-for-ms-sql-part-2-sql-server-password-recovery %})
- [Part 3 - Backup Data Recovery]({% post_url 2026-04-29-product-review-stellar-repair-for-ms-sql-part-3-backup-data-recovery %})
- [Part 4 - SQL Server Database Recovery]({% post_url 2026-04-30-product-review-stellar-repair-for-ms-sql-part-4-sql-server-database-recovery %})
- **Part 5 - File corruption (This post)**
- [Part 6 - Conclusion]({% post_url 2026-05-02-product-review-stellar-repair-for-ms-sql-part-6-conclusion %})

In our previous post, "[Product Review - Stellar Repair for MS SQL - Part 4: SQL Server Database Recovery]({% post_url 2026-04-30-product-review-stellar-repair-for-ms-sql-part-4-sql-server-database-recovery %})", we looked at **how to recover data from a database file** (.`MDF`).

In this post, we will discuss **corruption**.

Throughout the series, you will no doubt have been curious about the fact that I have demonstrated the retrieval of data and objects from an `.MDF` and a `.BAK` that were **fully functional**.

You might have wondered **what the point was**, given the review is for a tool that helps you with **recovery**.

At this point, we need to **define** corruption.

And to define that, we need to look at the structure of the various files.

## Database

A [SQL Server](https://www.microsoft.com/en-us/sql-server) database is composed of the following:

1. At least one **primary data file**, `.MDF`. This contains database metadata and pointers to the other files in the database.
2. At least one **transaction log**, .`LDF`. This contains information for database recovery.
3. Optional **secondary data file**, `.NDF`.

The primary data files (`.MDF` and .NDF) are logically divided into [pages](https://learn.microsoft.com/en-us/sql/relational-databases/pages-and-extents-architecture-guide?view=sql-server-ver17), and operations in the database are performed at the page level.

## Backup

[Database backups](https://sqlbak.com/blog/sql-server-backup-bak-vs-sqb/) are stored in the `.BAK` format, which is a format based on the [Microsoft Tape Format](https://en.wikipedia.org/wiki/Microsoft_Tape_Format) (MTF).

When it comes to corruption, we can mean one (or more of the following)

1. **Loss** of data - either the headers or the file data itself via various options - physical disk damage, truncation of data or read/write errors
2. **Flipping** of data - again, bytes in the file get flipped for myriad reasons, such as physical disk damage, truncation of data, or read/write errors
3. File system **corruption** during the reading or writing of data

At this juncture, I must share an anecdote of an issue that I ran into many years ago.

The database server had files on a [FAT32](https://www.coursera.org/articles/fat32) partition.

In case you did not know, **FAT32** had a maximum file size of **4GB**.

You can see where this is going.

The backup files `.BAK` for this database were **generated and saved correctly**. The backup sizes, however, **continued to grow until the hard limit was reached**, after which the backup files were **truncated** at 4 GB. As this was taking place using a command utility at 2 AM, there was **nobody around to review the error messages**.

SQL Server itself comes with tools to **detect** damage and **attempt to repair** databases - [DBCC](https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-transact-sql?view=sql-server-ver17).

Details of how to use this tool can be found [here](https://learn.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-checkdb-transact-sql?view=sql-server-ver17).

This is the space in which **Stellar Repair** is playing.

The reality of the matter is that the ability to recover data from either the backup (`.BAK`) or the data files (.MDF) depends entirely on:

1. How much of the **file** is available
2. How much data is **corrupted**
3. How much data is **missing**

At this point, I must point out that any **responsible** operations procedure must do the following:

1. Regularly **back up** the database, and regular here has context - daily at the very least.
2. **Verify** that the backup is functional, preferably by immediately **restoring** the backup to a different environment with a similar configuration.
3. Store backups in at least 3 different locations, one of which must be entirely offsite
4. Have **alerting mechanisms** in case anything fails.

### TLDR

The ability to recover a database from a file or a backup will depend entirely on the nature and extent of the damage and/or corruption.

Happy hacking!
