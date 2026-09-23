---
layout: post
title: Viewing Redis Data with JetBrains DataGrip
date: 2026-09-06 20:52:10 +0300
categories:
    - Tools
    - Redis
---

In our previous post, "[Storing Data In Redis With Command Line]({% post_url 2026-09-05-storing-data-in-redis-with-command-line %})", we looked at how to setup a [Redis](https://redis.io/) image for **cache** purposes, and how to **connect** to it, **insert**  and **retrieve** data.

In this post we will look at how to use my go-to database tool, [JetBrains](https://www.jetbrains.com/) [DataGrip](https://www.jetbrains.com/datagrip/), to **view** and **manage** data stored in **Redis**.

First, [download](https://www.jetbrains.com/datagrip/download/), **install** and then **launch** software.

Our next step is to **configure** it to **understand** and **connect** to **Redis**.

From the main menu, go to the **Data Sources** menu.

![1DataSource](../images/2026/09/1DataSource.png)

From there, click the **Drivers** icon:

![2Drivers](../images/2026/09/2Drivers.png)

You will be presented with a list of **supported drivers** from a number of databases.

![3Support](../images/2026/09/3Support.png)

Choose **Redis**.

Proceed to choose the **latest stable** version.

![4RedisLatest](../images/2026/09/4RedisLatest.png)

We then switch to the driver we want to use by clicking the option '**Switch to ver 1.6.**'

![5SelectDriver](../images/2026/09/5SelectDriver.png)

The screen should now look like this:

![6Setup](../images/2026/09/6Setup.png)

Now we are ready to **connect**.

From the main screen, the **Database Explorer**, click the icon to create a **new connection**.

![7ConnectDataSource](../images/2026/09/7ConnectDataSource.png)

Choose **Redis**.

This will take you to a screen to **configure** your database connection.

For **Redis**, this is typically the **port** and **password**.

![8ConfigRedis](../images/2026/09/8ConfigRedis.png)

If you used the `docker-compose.yaml` from my [previous post]({% post_url 2026-09-05-storing-data-in-redis-with-command-line %}), the **password** is `YourStrongPassword123`. The **port** is the default,  `6379`.

You can **test** the connection to ensure all is well:

![9TestConnection](../images/2026/09/9TestConnection.png)

You should see the following dialog:

![10testSuccess](../images/2026/09/10testSuccess.png)

Our connection should be **ready** to browse.

Expand the **keys** from the top level, usually a database named `0`.

![11ViewDatabases](../images/2026/09/11ViewDatabases.png)

We can see our key, `my-Key` is available.

**Double click** to view the data.

![12ViewData](../images/2026/09/12ViewData.png)

### TLDR

**JetBrains DataGrip can be used to view Redis data.**

Happy hacking!
