---
layout: post
title: Viewing Redis Cache With Another Redis Desktop Manager
date: 2026-09-06 21:45:14 +0300
categories:
   - Tools
   - Redis
---

In a previous post, "[Storing Data In Redis With Command Line]({% post_url 2026-09-05-storing-data-in-redis-with-command-line %})", we looked at how to setup a [Redis](https://redis.io/) image for **cache** purposes, and how to **connect** to it, **insert**  and **retrieve** data.

In this post we will look at how to use [Another Redis Desktop Manager](https://goanother.com/).

This is a **smaller**, **nimbler** tool than [DataGrip](https://www.jetbrains.com/datagrip/) as its **only purpose** is to connect to **Redis**, unlike **DataGrip** that is a **general** database manager.

We begin by [downloading](https://goanother.com/#download) and **installing** to software.

Once launched, you should see the following screen.

![1RedisDesktop](../images/2026/09/1RedisDesktop.png)

Click **New Connection**.

![2NewConnection](../images/2026/09/2NewConnection.png)

You will get the following dialog to supply connection **parameters**.

![3ConnectDialog](../images/2026/09/3ConnectDialog.png)

Go on and provide the parameters - **host**, **port** and **password**, as well as a connection **name**.

![4Parameters](../images/2026/09/4Parameters.png)

Once supplied, you can **test** the connection.

![5Test](../images/2026/09/5Test.png)

Click **OK** to complete.

You will now see your new connection.

![6SetupComplete](../images/2026/09/6SetupComplete.png)

Click on the connection.

![7Connected](../images/2026/09/7Connected.png)

It will expand to show you the **available database(s)**, in this case `DB0` and your **key**.

If you **click** the **key**, you will see your **data**.

![8RedisData](../images/2026/09/8RedisData.png)

### TLDR

**Another Redis Desktop Manager is an excellent tool to view and manage your Redis data.**

Happy hacking!
