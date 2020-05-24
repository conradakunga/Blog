---
id: 260
title: Decimals, Precision And Scale
date: 2020-04-28T12:51:47+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=260
permalink: /2020/04/28/decimals-precision-and-scale/
categories:
  - SQL Server
---
The .NET framework has a decimal data type.

SQL Server has a decimal datatype.

**These are not the same thing!**

First of all, SQL server’s decimal has a [precision of 38](https://docs.microsoft.com/en-us/sql/t-sql/data-types/decimal-and-numeric-transact-sql?view=sql-server-ver15), while the .NET framework decimal has a precision of 29.

And even having said that, the maximum value you can store in a decimal is 79,228,162,514,264,337,593,543,950,335, so for all intents and purposes we can safely consider 28 to be the largest **effective** precision

In short, SQL server’s decimal can store bigger numbers than .NETs. Beware of this if you are dealing with large numbers.

Secondly, SQL server allows you to specify the scale.

Which begs the question – what is precision and what is scale?

Given a number, 10,000 the diagram below illustrates them.

[<img style="display: inline; background-image: none;" title="Scale 1" src="images/2020/04/Scale-1_thumb.png" alt="Scale 1" width="1039" height="219" border="0" />](images/2020/04/Scale-1.png)

The **precision** is 11 and the **scale** is 6.

In SQL server this is defined as **decimal (11,6)**

Remember: **precision includes the decimals**

Things to be aware of:

  1. In SQL Server if you do not specify the precision and neither do you specify the scale, it defaults to a precision of **18** and a scale of ****
  2. In SQL server if you specify the precision only, the database engine assumes a scale of ****
  3. If you are using entity framework with a decimal type, the default precision is **18** and the scale is **2**
  4. To avoid overflow errors when passing data to .NET from SQL Server especially if numbers are introduced into the database via TSQL or another system, have a maximum precision of **28**
  5. If you pass a value with **greater** scale to a stored procedure or function, that number will be **rounded** to fit the defined
  6. If you pass a  value with greater scale to the database via the **SqlBulkCopy** class, the number will be **truncated** to fit the defined
  
Happy Hacking!