---
layout: post
title: Determining the Operating System SQL Server Is Running On Remotely
date: 2025-05-21 23:32:44 +0300
categories:
    - SQL Server
    - .NET
    - Dapper
---

Suppose, for whatever (legit!) reason, you want to know what **operating system** the [SQL Server](https://www.microsoft.com/en-us/sql-server) database engine you are connecting to is running.

There are three ways to do this:

1. [System views](https://www.red-gate.com/simple-talk/databases/sql-server/learn/sql-server-system-views-the-basics/)
2. [@@Version](https://learn.microsoft.com/en-us/sql/t-sql/functions/version-transact-sql-configuration-functions?view=sql-server-ver16) property
3. ~~[xp_cmdshell](https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/xp-cmdshell-transact-sql?view=sql-server-ver16)~~

### System Views

There are two system views that you can use for this purpose:

1. [sys.dm_os_windows_info](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-windows-info-transact-sql?view=azuresqldb-current)
2. [sys.dm_os_host_info](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-host-info-transact-sql?view=sql-server-ver17)

The first one is probably not the best to use, given that [SQL Server can now run on Linux](https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-overview?view=sql-server-ver16).

### @@Version Property

SQL Server exposes the `@@Version` property that you can query directly

### xp_cmdshell

This is generally **not an option** because no serious DBA will enable this. It is **disabled by default**.

Let us then confine ourselves to the two remaining options.

We will need the following packages:

1. [Microsoft.Data.SqlClient](https://www.nuget.org/packages/microsoft.data.sqlclient) - to connect to and interact with the database server
2. [Dapper](https://www.nuget.org/packages/Dapper) - to make the former easier.

```bash
dotnet add package Microsoft.Data.SqlClient
dotnet add package Dapper
```

I have [written extensively on using Dapper](https://www.conradakunga.com/blog/simpler-net-data-access-with-dapper-part-1/).

We can get the server property `@@version` as a `string` as follows:

```c#
using (var cn = new SqlConnection("data source=localhost;trustservercertificate=true;uid=sa;pwd=YourStrongPassword123"))
{
    var result = cn.QuerySingle<string>("SELECT @@version");
    Console.WriteLine(result);
}
```

This will print something like the following:

```plaintext
Microsoft SQL Server 2022 (RTM-CU19) (KB5054531) - 16.0.4195.2 (X64) 
        Apr 18 2025 13:42:14 
        Copyright (C) 2022 Microsoft Corporation
        Developer Edition (64-bit) on Linux (Ubuntu 22.04.5 LTS) <X64>
```

We can also use the system view `sys.dm_os_host_info`.

Given that it is a known view, we can get its columns.

```sql
SELECT dm_os_host_info.host_platform,
       dm_os_host_info.host_distribution,
       dm_os_host_info.host_release,
       dm_os_host_info.host_service_pack_level,
       dm_os_host_info.host_sku,
       dm_os_host_info.os_language_version,
       dm_os_host_info.host_architecture FROM sys.dm_os_host_info
```

From this, we have options:

1. Create a type to store the information
2. Leverage the fact that `Dapper` supports [dynamic types](https://www.conradakunga.com/blog/dapper-part-9-using-dynamic-types/).

The type would look like this:

```c#
public sealed class HostInfo
{
    public string host_platform { get; set; }
    public string host_distribution { get; set; }
    public string host_release { get; set; }
    public string host_service_pack_level { get; set; }
    public string host_sku { get; set; }
    public string os_language_version { get; set; }
    public string host_architecture { get; set; }
}
```

And we can **query** and **print** the results like this:

```c#
using (var cn = new SqlConnection("data source=localhost;trustservercertificate=true;uid=sa;pwd=YourStrongPassword123"))
{
    var result = cn.QuerySingle<HostInfo>("SELECT * FROM sys.dm_os_host_info");
    Console.WriteLine($"Host platform: {result.host_platform}");
    Console.WriteLine($"Host distribution: {result.host_distribution}");
    Console.WriteLine($"Host release: {result.host_release}");
    Console.WriteLine($"Host service pack level: {result.host_service_pack_level}");
    Console.WriteLine($"Host SKU: {result.host_sku}");
    Console.WriteLine($"Host OS Language Version: {result.os_language_version}");
    Console.WriteLine($"Host architecture: {result.host_architecture}");
}
```

This will print something like this:

```plaintext
Host platform: Linux
Host distribution: Ubuntu
Host release: 22.04
Host service pack level: 
Host SKU: 
Host OS Language Version: 0
Host architecture: X64
```

Rather than go to the bother of creating a type, we can leverage the fact that `Dapper` supports [dynamic types](https://learn.microsoft.com/en-us/dotnet/csharp/advanced-topics/interop/using-type-dynamic).

We can achieve the same result as follows:

```c#
using (var cn = new SqlConnection("data source=localhost;trustservercertificate=true;uid=sa;pwd=YourStrongPassword123"))
{
    var result = cn.QuerySingle("SELECT * FROM sys.dm_os_host_info");
    Console.WriteLine($"Host platform: {result.host_platform}");
    Console.WriteLine($"Host distribution: {result.host_distribution}");
    Console.WriteLine($"Host release: {result.host_release}");
    Console.WriteLine($"Host service pack level: {result.host_service_pack_level}");
    Console.WriteLine($"Host SKU: {result.host_sku}");
    Console.WriteLine($"Host OS Language Version: {result.os_language_version}");
    Console.WriteLine($"Host architecture: {result.host_architecture}");
}
```

Here, `result` is a `dynamic` type.

Now, you may wonder if there are any [security implications](https://learn.microsoft.com/en-us/sql/relational-databases/security/securing-sql-server?view=sql-server-ver17) to this approach.

There are!

You will need some [permissions](https://learn.microsoft.com/en-us/sql/relational-databases/security/permissions-database-engine?view=sql-server-ver16) to access this information.

The [documentation](https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-host-info-transact-sql?view=sql-server-ver17&viewFallbackFrom=azuresqldb-current) says the following:

> On SQL Server 2019 (15.x) and earlier versions, the `SELECT` permission on `sys.dm_os_host_info` is granted to the public role by default. If revoked, you require `VIEW SERVER STATE` permission on the server.
>
> On SQL Server 2022 (16.x) and later versions, you require `VIEW SERVER PERFORMANCE STATE` permission on the server.

### TLDR

**SQL Server exposes properties and system views that you can query to obtain some server information.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-05-21%20-%20SQL%20Server%20Info).

Happy hacking!
