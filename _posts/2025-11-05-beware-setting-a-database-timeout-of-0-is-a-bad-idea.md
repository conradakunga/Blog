---
layout: post
title: Beware - Setting A Database Timeout Of 0 Is A Bad Idea
date: 2025-11-05 18:54:06 +0300
categories:
    - C#
    - .NET
    - Dapper
---

When interacting with a database, of whatever kind, you will need to establish a connection to the database using the access technology of choice - either Entity Framework, Dapper, or direct ADO (ActiveX Data Objects).

These connections usually have a default timeout, if you don't specify one.

SQL Server, for example, has a 30-second timeout.

You can, of course, change this.

I have discussed this extensively in this post - "Dapper Part 8 - Controlling Database Timeouts"

Recently, when reviewing some old code, I came across this line:

```c#
SqlMapper.Settings.CommandTimeout = 0
```

This essentially means that the connection will **never time out**.

At first glance, this might appear to be a good thing.

It isn't.

Database connections are **expensive**, and locking one away will cause problems, as you will eventually **run out of connections**. 

This is especially the case when you **create many** connections, perhaps in a **loop**.

When you run out of connections, SQL Server will start to **reject any new incoming connections**, resulting in angst for users.

Another problem is that on the server side, there may be a bug in your code, perhaps a cursor or some other such construct, that results in an **infinite loop**.

You **will never know about this**, as the code will continue to run **indefinitely**.

### TLDR

Do not set database commands to wait infinitely in their connections.

Happy hacking!
