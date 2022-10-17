---
layout: post
title: Tip - SQL Server Management Studio - Server Colouring
date: 2022-10-17 14:16:42 +0300
categories:
    - SQL Server
    - SQL Server Management Studio
    - Tips
    - RedGate
---
We've all done it - ran a query on the server we thought was the test but was in fact the production 

SQL Server Management Studio has a very simple solution for this problem - you can configure it to display different servers in different colours, and even give them environment names.

This is achieved using a utility from [RedGate Software](https://www.red-gate.com/) named [SQL Compare](https://www.red-gate.com/products/sql-development/sql-compare/)

With this tool installed you get an additional menu on the server node:

![](../images/2022/10/ServerMenu.png)

If you designate one server as `Production` and the other as `Development` it is easier to tell **where** exactly you are running your queries.

The tabs now will look like this:

`Production`:

![](../images/2022/10/Production.png)

  
`Development`:

![](../images/2022/10/Development.png)


It is that much more difficult (but not impossible!) to shoot yourself in the foot.

Happy hacking!