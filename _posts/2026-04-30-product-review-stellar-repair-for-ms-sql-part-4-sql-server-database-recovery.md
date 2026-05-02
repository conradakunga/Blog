---
layout: post
title: "Product Review - Stellar Repair for MS SQL - Part 4: SQL Server Database Recovery"
date: 2026-04-30 11:56:40 +0300
categories:
    - Product Review
    - SQL Server
    - Stellar Repair
---

This is **Part 4** of an independent review of a product, [Stellar Repair for MS SQL,](https://www.stellarinfo.com/sql-recovery.php) from the folks at [Stellar Info](https://www.stellarinfo.com/).

The version being reviewed is `11.0.0.1`

- [Part 1 - Introduction]({% post_url 2026-04-27-product-review-stellar-repair-for-ms-sql-part-1-introduction %})
- [Part 2 - SQL Server Password Recovery]({% post_url 2026-04-28-product-review-stellar-repair-for-ms-sql-part-2-sql-server-password-recovery %})
- [Backup Data Recovery]({% post_url 2026-04-29-product-review-stellar-repair-for-ms-sql-part-3-backup-data-recovery %})
- **Part 4 - SQL Server Database Recovery (This post)**
- Part 5 - File corruption
- Part 6 - Conclusion

In our previous post, "[Product Review - Stellar Repair for MS SQL - Part 3: Backup Data Recovery]({% post_url 2026-04-29-product-review-stellar-repair-for-ms-sql-part-3-backup-data-recovery %})", we looked at how to recover data from a backup file (**.bak**).

In this post, we will look at how to recover data from a **potentially corrupted database** file (**.mdf**).

For this, we access the tool from the dashboard.

![DatabaseRepairMenu](../images/2026/03/DatabaseRepairMenu.png)

This will launch the tool that will ask the path to the file:

![browseMDF](../images/2026/03/browseMDF.png)

Here we will browse to our test database file, `Spies.mdf`.

![selectMDFFile](../images/2026/03/selectMDFFile.png)

Nothing seems to have changed in the selection UI.

![mdfSelectionAfter](../images/2026/03/mdfSelectionAfter.png)

Click **Repair** anyway.

There seems to be a **UI bug** with **loading the metadata** of the selected file.

We are presented with the following dialog:

![scanMDF](../images/2026/03/scanMDF.png)

We then get our old friend the version selector:

![mdfVersionSelector](../images/2026/03/mdfVersionSelector.png)

**SQL 2025** is missing from these options, so we will select the option that has all the others.

![mdfVersion2025](../images/2026/03/mdfVersion2025.png)

After processing the file we get the following interface, that seems to mirror the one for recovery form a backup.

![MDFRetrieval](../images/2026/03/MDFRetrieval.png)

At the bottom is a log report, that you can use to view additional information.

![logReport](../images/2026/03/logReport.png)

The UI offers a **search** functionality, but it **does not seem to work**.

![searchResults](../images/2026/03/searchResults.png)

The options to save are the same as for the backup recovery.

## Existing database

![mdfExisting](../images/2026/03/mdfExisting.png)

This allows you to connect to an existing database.

![MDFConnect](../images/2026/03/MDFConnect.png)

## New Database

![MDFNewDatabase](../images/2026/03/MDFNewDatabase.png)

## Other Format

![MDFOther](../images/2026/03/MDFOther.png)

### TLDR

**Stellar Repair allows you to extract data and objects from a database file (`.mdf`).**

Happy hacking!
