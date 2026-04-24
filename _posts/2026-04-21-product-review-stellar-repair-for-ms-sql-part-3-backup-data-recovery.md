---
layout: post
title: Product Review - Stellar Repair for MS SQL - Part 3: Backup Data Recovery
date: 2026-04-21 12:25:02 +0300
categories:
    - Product Review
    - SQL Server
---

This is **Part 3** of an independent review of a product, [Stellar Repair for MS SQL,](https://www.stellarinfo.com/sql-recovery.php) from the folks at [Stellar Info](https://www.stellarinfo.com/).

The version being reviewed is `11.0.1`

- [Part 1 - Introduction]({% post_url 2026-04-19-product-review-stellar-repair-for-ms-sql-part-1-introduction %})
- Part 2 - (this post)
- **Backup Data Recovery (this post)**

In our previous post, "[Product Review - Stellar Repair for MS SQL - Part 2: SQL Server Password Recovery]({% post_url 2026-04-20-product-review-stellar-repair-for-ms-sql-part-2-sql-server-password-recovery %})", we looked at the functionality of **retrieving a SQL Server password**.

In this post, we will look at how to **recover data from a SQL backup** (.[bak](https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/back-up-and-restore-of-sql-server-databases?view=sql-server-ver17#creating-backups)).

In preparation for this will 

1. **Prepare** a database
2. **Seed** it with test data
3. **Backup** the database
4. **Restore** data from the backup

For this exercise we will use SSMS.

First, connect to the server:

![serverConnect](../images/2026/03/serverConnect.png)

Next, we create a database:

![createDatabase](../images/2026/03/newDatabase.png)

Then we create our database. The name is `Spies`.

![createDatabase](../images/2026/03/createDatabase.png)

Next, we create a table so store our `Spies`.

```sql
CREATE TABLE Agencies
    (
        AgencyID UNIQUEIDENTIFIER PRIMARY KEY
            DEFAULT NEWSEQUENTIALID(),
        Name     NVARCHAR(250)    NOT NULL
            UNIQUE
    );

CREATE TABLE Spies
    (
        SpyID       uniqueidentifier PRIMARY KEY
            DEFAULT (NEWSEQUENTIALID()),
        AgencyID    uniqueidentifier NOT NULL
            REFERENCES Agencies (AgencyID),
        FullName    nvarchar(250)    NOT NULL,
        DateOfBirth Date             NOT NULL,
        UNIQUE (AgencyID, FullName)
    );
```

Finally, we **seed** the data.

First, we start with the `Agencies`.

```sql
INSERT INTO dbo.Agencies
    (
        AgencyID,
        Name
    )
VALUES
    (
        '{dc34433e-f36b-1410-8ddd-000326cb3e3a}', N'Central Intelligence Agency (United States)'
    ),
    (
        '{dd34433e-f36b-1410-8ddd-000326cb3e3a}', N'Intelligence Directorate (Cuba)'
    ),
    (
        '{db34433e-f36b-1410-8ddd-000326cb3e3a}', N'MI-6 (United Kingdon)'
    ),
    (
        '{da34433e-f36b-1410-8ddd-000326cb3e3a}', N'National Intelligence Service (Kenya)'
    );

```

Next, the `Spies`.

The script looks like this:

```sql
INSERT Spies (AgencyID,Fullname,DateOfBirth)
SELECT 'db34433e-f36b-1410-8ddd-000326cb3e3a','Reanna Runte','1998-05-28'UNION 
SELECT 'dc34433e-f36b-1410-8ddd-000326cb3e3a','Keegan Ullrich','2004-03-15'UNION 
SELECT 'da34433e-f36b-1410-8ddd-000326cb3e3a','Doris Greenholt','2002-12-12'UNION 
SELECT 'db34433e-f36b-1410-8ddd-000326cb3e3a','Janelle Wunsch','2024-10-17'UNION 
SELECT 'da34433e-f36b-1410-8ddd-000326cb3e3a','Zelda Pagac','2010-08-01'UNION 
--- Snipped here ---
```

Once ran, the table will have 6,000 rows.

Next, we backup the database.

![backupMenu](../images/2026/03/backupMenu.png)

The default options will suffice:

![backupResult](../images/2026/03/backupResult.png)

Once done, the backup file should be visible.

![backupFile](../images/2026/03/backupFile.png)

Next, we load the software to retrieve data from a backup.

![stellarBackupMenu](../images/2026/03/stellarBackupMenu.png)

This opens the following screen:

![StellarBackupUI](../images/2026/03/StellarBackupUI.png)

The home screen looks like this:

![stellarBackupHome](../images/2026/03/stellarBackupHome.png)

f
