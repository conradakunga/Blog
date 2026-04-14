---
layout: post
title: Fix - Deploying CLR Procedures & Functions In SQL Server 2022
date: 2026-03-06 11:40:11 +0300
categories:
    - Database
    - SQL Server
    - C#
    - .NET
---

One of the innovations introduced in [SQL Server 2005](https://learn.microsoft.com/en-us/lifecycle/products/microsoft-sql-server-2005) was the ability to create procedures, functions, and types in [.NET](https://dotnet.microsoft.com/en-us/), usually C#.

This extended the database engine to support custom logic written in C#, bringing functionality that wasn't available in the database engine.

I have used this myself in several ways

1. Custom **rounding**
2. Custom **hashing**
3. Custom **date** functions
4. Formatting (before the [format](https://learn.microsoft.com/en-us/sql/t-sql/functions/format-transact-sql?view=sql-server-ver17) function was natively added in [SQL Server 2012](https://learn.microsoft.com/en-us/lifecycle/products/microsoft-sql-server-2012))

With great power, however, comes great responsibility because the fact that you can leverage the .NET framework also means that technically, **your code can do anything**.

This has meant every subsequent release of SQL Server has tightened the [security](https://learn.microsoft.com/en-us/sql/relational-databases/clr-integration/security/clr-integration-security?view=sql-server-ver17) around this feature.

If you deploy your CLR code, you might get an error like this:

```plaintext
SQL72014: Framework Microsoft SqlClient Data Provider: Msg 10343, Level 14, State 1, Line 1 CREATE or ALTER ASSEMBLY for assembly 'YourDLL' with the SAFE or EXTERNAL_ACCESS option failed because the 'clr strict security' option of sp_configure is set to 1. Microsoft recommends that you sign the assembly with a certificate or asymmetric key that has a corresponding login with UNSAFE ASSEMBLY permission. Alternatively, you can trust the assembly using sp_add_trusted_assembly.
```

The solution to this problem is this [PowerShell](https://learn.microsoft.com/en-us/powershell/) script that will correctly set all the relevant settings to allow your code to be deployed to the database of your choice.

```powershell
# Set variables
$library = 'C:\Projects\innova-core\Innova.Database\bin\Release\Innova.Database.dll'
$dllName = 'Innova.Database'
$database = 'monkey'
$server = '10.211.55.2'
$username = 'sa'
$password = 'YourStrongPassword123'

# Get the MD5 hash of the build DLL
$hash = (Get-FileHash -Algorithm SHA512 "C:\Projects\innova-core\Innova.Database\bin\Release\Innova.Database.dll").Hash

# build the trusted assembly query
$query = "EXEC sys.sp_add_trusted_assembly
    @hash = 0x$hash,
    @description = N'$dllName'"

# Display the hash (in case you need to grab it
Write-Host "The hash is - $hash"
Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $username -Password $password -Query $query -TrustServerCertificate

# Get the assembly binary
$bytes = [System.BitConverter]::ToString([System.IO.File]::ReadAllBytes($library)).Replace("-", "")

# drop assembly if exists in the datavase
# build the create assembly statement
$query = "CREATE ASSEMBLY [$dllName]
    FROM 0x$bytes"

Write-Host "The bytes are $($bytes.Substring(0, 5))"

Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $username -Password $password -Query $query -TrustServerCertificate

Write-Host 'CREATION COMPLETE'
```

You will need to provide the following:

1. `$library` - **Path** to the compiled DLL for deployment
2. `$dllName` - **Name** to refer to the DLL during deployment
3. `$database` - **Database** to deploy CLR artefacts to
4. `$server` - **IP address** of server
5. `$username` - Database **username**
6. $password - Database **password**

### TLDR

**This `PowerShell` script allows you to deploy trusted SQL CLR artifacts to your database with the appropriate settings.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-03-06%20-%20Deploy%20SQLCLR).

Happy hacking!
