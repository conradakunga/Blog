---
layout: post
title: "Product Review - Stellar Repair for MS SQL - Part 6: Conclusion"
date: 2026-05-02 18:21:57 +0300
categories:
    - Product Review
    - SQL Server
    - Stellar Repair
---

This is **Part 6** of an independent review of a product, [Stellar Repair for MS SQL,](https://www.stellarinfo.com/sql-recovery.php) from the folks at [Stellar Info](https://www.stellarinfo.com/).

The version being reviewed is `11.0.0.1`

- [Part 1 - Introduction]({% post_url 2026-04-27-product-review-stellar-repair-for-ms-sql-part-1-introduction %})
- [Part 2 - SQL Server Password Recovery]({% post_url 2026-04-28-product-review-stellar-repair-for-ms-sql-part-2-sql-server-password-recovery %})
- [Part 3 - Backup Data Recovery]({% post_url 2026-04-29-product-review-stellar-repair-for-ms-sql-part-3-backup-data-recovery %})
- [Part 4 - SQL Server Database Recovery]({% post_url 2026-04-30-product-review-stellar-repair-for-ms-sql-part-4-sql-server-database-recovery %})
- [Part 5 - File corruption]({% post_url 2026-05-01-product-review-stellar-repair-for-ms-sql-part-5-file-corruption %})
- **Part 6 - Conclusion (This post)**

In our previous post, "[Product Review - Stellar Repair for MS SQL - Part 5: File Corruption]({% post_url 2026-05-01-product-review-stellar-repair-for-ms-sql-part-5-file-corruption %})", we discussed exactly what "**corruption**" means and that recovery is highly **context-sensitive**.

In this post, I will draw my **conclusions**.

## Functionality

The functionality seems pretty well thought out for accessing and recovering data from [database files]({% post_url 2026-04-30-product-review-stellar-repair-for-ms-sql-part-4-sql-server-database-recovery %}) (`.MDF`) and [backups]({% post_url 2026-04-30-product-review-stellar-repair-for-ms-sql-part-4-sql-server-database-recovery %}) (`.BAK`).

I was, however, u**nable to recover the SQL Server password** from `master.mdf`.

I have also pointed out some potential **improvements** in the posts.

## User Interface

The user interface is generally **discoverable** and **easy to use**. I have, however, pointed out some **gotchas** and potential **improvements** in the review.

## Pricing

The price seems **reasonable** given the role that the tool is meant to play when things have really gone wrong.

![pricing](../images/2026/03/pricing.png)

You'd typically be better off with either **Technician** or **Toolkit**.

## Support

Support is available through a [help center](https://support.stellarinfo.com/?_ga=2.123204875.1498080002.1777735657-786564358.1776261044&_gac=1.162663246.1777015851.CjwKCAjwqazPBhALEiwAOuXqdN-nBVVgpTAC8Fm6UonrQE1yhbGoA_4UKSTx2PewZPKMlP9kY4BwxRoCDoUQAvD_BwE) where you can access FAQs and [raise tickets](https://tickets.stellarinfo.com/portal/en/signin?_ga=2.123728523.1498080002.1777735657-786564358.1776261044&_gac=1.147015365.1777015851.CjwKCAjwqazPBhALEiwAOuXqdN-nBVVgpTAC8Fm6UonrQE1yhbGoA_4UKSTx2PewZPKMlP9kY4BwxRoCDoUQAvD_BwE).

There is also a [comprehensive knowledge base](https://support.stellarinfo.com/kb/?_ga=2.123204875.1498080002.1777735657-786564358.1776261044&_gac=1.162663246.1777015851.CjwKCAjwqazPBhALEiwAOuXqdN-nBVVgpTAC8Fm6UonrQE1yhbGoA_4UKSTx2PewZPKMlP9kY4BwxRoCDoUQAvD_BwE).

## Platform Availability

As outlined in the [introduction]({% post_url 2026-04-27-product-review-stellar-repair-for-ms-sql-part-1-introduction %}), the software is available for [Windows](https://www.stellarinfo.com/sql-recovery.php) and [Linux](https://www.stellarinfo.com/database-recovery/sql-recovery-linux/free-download.php).

If you are ever in a situation where you have corrupted database files or backups, this is a tool you can definitely use.

Happy hacking!
