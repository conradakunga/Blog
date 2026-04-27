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

The version being reviewed is `11.0.1`

- [Part 1 - Introduction]({% post_url 2026-04-19-product-review-stellar-repair-for-ms-sql-part-1-introduction %})
- [Part 2 - SQL Server Passwod Recovery]({% post_url 2026-04-28-product-review-stellar-repair-for-ms-sql-part-2-sql-server-password-recovery %})
- [Backup Data Recovery]({% post_url 2026-04-29-product-review-stellar-repair-for-ms-sql-part-3-backup-data-recovery %})
- [Part 4 - Database Recovery]({% post_url 2026-04-30-product-review-stellar-repair-for-ms-sql-part-4-sql-server-database-recovery %})
- Part 5 - File corruption
- Part 6 - Conclusion

In our previous post, "[Product Review - Stellar Repair for MS SQL - Part 3: Backup Data Recovery]({% post_url 2026-04-29-product-review-stellar-repair-for-ms-sql-part-3-backup-data-recovery %})", we looked at how to recover data from a backup file (**.bak**).

In this post we will look at how to recover data from a **potentially corrupted database** file (**.mdf**).

For this we access the tool from the dashboard.

![DatabaseRepairMenu](../images/2026/03/DatabaseRepairMenu.png)
