---
layout: post
title: Fix - SSL Provider, error 0 - The certificate chain was issued by an authority that is not trusted
date: 2022-05-16 14:34:04 +0300
categories:
    - C#
    - .NET
    - SQL Server
---
For many years, the provider to access SQL Server from .NET was [System.Data.SqlClient](https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient?view=dotnet-plat-ext-6.0).

With the advent of .NET Core, a new provider was provided as a replacement - [Microsoft.Data.SqlClient](https://docs.microsoft.com/en-us/dotnet/api/microsoft.data.sqlclient?view=sqlclient-dotnet-standard-4.1).

Why?

`System.Data.SqlClient` was part of the full .NET Framework and this could not be updated / improved independently. Extracting it to a nuget package with the same name could potentially break existing code, as the namespace would remain the same.

The new package is almost completely 100% compatible with the previous - upgrading involves simply adding a reference to the new package and changing the namespace imports to `Microsoft.Data.SqlClient` from `System.Data.SqlClient`.

You should migrate to this package, as the team says explicitly in [this blog post](https://devblogs.microsoft.com/dotnet/introducing-the-new-microsoftdatasqlclient/):

> It means the development focus has changed. We have no intention of dropping support for System.Data.SqlClient any time soon. It will remain as-is and we will fix important bugs and security issues as they arise. If you have a typical application that doesn’t use any of the newest SQL features, then you will still be well served by a stable and reliable System.Data.SqlClient for many years.
> 
> However, Microsoft.Data.SqlClient will be the only place we will be implementing new features going forward. We would encourage you to evaluate your needs and options and choose the right time for you to migrate your application or library from System.Data.SqlClient to Microsoft.Data.SqlClient.


However, after this upgrade you might get the following error from your previously working code:

```plaintext
A connection was successfully established with the server, but then an error occurred during the login process. (provider: SSL Provider, error: 0 - The certificate chain was issued by an authority that is not trusted.)
```

This error is because one of the breaking changes to the new package is that it expects the target SQL server database to be **secured by default** by SSL certificates.

The rationale is explained [here](https://docs.microsoft.com/en-us/sql/connect/ado-net/introduction-microsoft-data-sqlclient-namespace?view=sql-server-ver15#encrypt-default-value-set-to-true) 

> The default value of the Encrypt connection setting has been changed from false to true. With the growing use of cloud databases and the need to ensure those connections are secure, it's time for this backwards-compatibility-breaking change.

To correct this properly, one has to either:

1. Secure the target sever as outlined [here](https://www.ssltrust.com.au/help/setup-guides/securing-microsoft-sql-server-with-ssl)
2. Turn off encryption in the connection string.
    You can achieve this by appending the following to your connection string:
    
    ```plaintext
    encrypt=false
    ```
    
    Such that your connection string becomes:
    
    ```csharp
    new SqlConnection("data source=.;database=DB;trusted_connection=true;encrypt=false");
    ```
Happy hacking!