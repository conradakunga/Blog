---
layout: post
title: Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 13 - Database Configuration
date: 2025-04-29 05:04:30 +0300
categories:
    - .NET
    - C#
    - OpenSource
    - Design
    - Testing
    - PostgreSQL
    - SQL Server
    - Dapper
---

This is Part 13 of a series on Designing, Building & Packaging A Scalable, Testable .NET Open Source Component.

- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 1 - Introduction]({% post_url 2025-04-17-designing-building-packaging-a-scalable-testable-net-open-source-component-part-1-introduction %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 2 - Basic Requirements]({% post_url 2025-04-18-designing-building-packaging-a-scalable-testable-net-open-source-component-part-2-basic-requirements %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 3 - Project Setup]({% post_url 2025-04-19-designing-building-packaging-a-scalable-testable-net-open-source-component-part-3-project-setup %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 4 - Types & Contracts]({% post_url 2025-04-20-designing-building-packaging-a-scalable-testable-net-open-source-component-part-4-types-contracts %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 5 - Component Implementation]({% post_url 2025-04-21-designing-building-packaging-a-scalable-testable-net-open-source-component-part-5-component-implementation %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 6 - Mocking & Behaviour Tests]({% post_url 2025-04-22-designing-building-packaging-a-scalable-testable-net-open-source-component-part-6-mocking-behaviour-tests %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 7 - Sequence Verification With Moq]({% post_url 2025-04-23-designing-building-packaging-a-scalable-testable-net-open-source-component-part-7-sequence-verification-with-moq %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 8 - Compressor Implementation]({% post_url 2025-04-24-designing-building-packaging-a-scalable-testable-net-open-source-component-part-8-compressor-implementation %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 9 - Encryptor Implementation]({% post_url 2025-04-25-designing-building-packaging-a-scalable-testable-net-open-source-component-part-9-encryptor-implementation %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 10 - In Memory Storage]({% post_url 2025-04-26-designing-building-packaging-a-scalable-testable-net-open-source-component-part-10-in-memory-storage %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 11 - SQL Server Storage]({% post_url 2025-04-27-designing-building-packaging-a-scalable-testable-net-open-source-component-part-11-sql-server-storage %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 12 - PostgreSQL Storage]({% post_url 2025-04-28-designing-building-packaging-a-scalable-testable-net-open-source-component-part-12-postgresql-storage %})
- **Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 13 - Database Configuration (This Post)**
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 14 - Virtualizing Infrastructure]({% post_url 2025-04-30-designing-building-packaging-a-scalable-testable-net-open-source-component-part-14-virtualizing-infrastructure %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 15 - Test Organization]({% post_url 2025-05-01-designing-building-packaging-a-scalable-testable-net-open-source-component-part-15-test-organization %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 16 - Large File Consideration]({% post_url 2025-05-02-designing-building-packaging-a-scalable-testable-net-open-source-component-part-16-large-file-consideration %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 17 - Large File Consideration On PostgreSQL]({% post_url 2025-05-03-designing-building-packaging-a-scalable-testable-net-open-source-component-part-17-large-file-consideration-on-postgresql %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 18 - Azure Blob Storage]({% post_url 2025-05-04-designing-building-packaging-a-scalable-testable-net-open-source-component-part-18-azure-blob-storage %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 19 - Testing Azure Blob Storage Locally]({% post_url 2025-05-05-designing-building-packaging-a-scalable-testable-net-open-source-component-part-19-testing-azure-blob-storage-locally %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 20 - Amazon S3 Storage]({% post_url 2025-05-25-designing-building-packaging-a-scalable-testable-net-open-source-component-part-20-amazon-s3-storage %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 21 - Testing Amazon S3 Storage Locally]({% post_url 2025-05-26-designing-building-packaging-a-scalable-testable-net-open-source-component-part-21-testing-amazon-s3-storage-locally %}) 
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 22 - Refactoring Azure Storage Engine For Initialization]({% post_url 2025-05-29-designing-building-packaging-a-scalable-testable-net-open-source-component-part-22-refactoring-azure-storage-for-initialization %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 23 - Refactoring Amazon Storage Engine For Initialization]({% post_url 2025-05-30-designing-building-packaging-a-scalable-testable-net-open-source-component-part-23-refactoring-amazon-storage-engine-for-initialization %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 24 - Google Cloud Storage]({% post_url 2025-07-13-designing-building-packaging-a-scalable-testable-net-open-source-component-part-24-google-cloud-storage %})

In our last post, we implemented the [PostgreSQL](https://www.postgresql.org/) storage engine.

In this post we shall look at the considerations around the **database** itself, **regardless of the engine**.

A couple of questions come to mind:

1. In **which database** will the table that stores the files be? Should it have a dedicated database, or will the table be part of the host application's database?
2. How will the **table(s)** and **index(es)** be created? Will they be **automated**, or will they someone need to create them **manually**.

Let us tackle them one by one.

### Which Database

**We will leave the decision of which database to the host application**. Given we are providing a connection string, the host can pass the details of the database to use to our component.

### Schema & Objects Creation

We will also leave the creation of the table and index(es) to the user. In other words, this will not be automated. Why?

1. Automation requires **system administration rights**, or at least roles for `CREATE TABLE` ` / `ALTER TABLE, which implies **escalated permission** levels. It is not **reasonable** (or **wise**) to expect such a component to be working with such permissions.
2. It is always a good thing for any component, tool or software to extend **visibility** of exactly what is being done on the server. It is good to know exactly **what SQL** is being ran.

What we will do is provide **scripts** that can be ran to create the objects, that can be ran in advance. And when the connection string is being passed to the component, a low privilege user can be used.

Below is the script for **SQL Server:**

```sql
-- TABLE

-- Create table if it doesn't exist
IF NOT EXISTS (SELECT *
               FROM INFORMATION_SCHEMA.TABLES
               WHERE TABLE_NAME = 'Files'
                 AND TABLE_SCHEMA = 'dbo')
    BEGIN
        CREATE TABLE dbo.Files
        (
            FileID               UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
            Name                 NVARCHAR(500)                NOT NULL,
            Extension            NVARCHAR(10)                 NOT NULL,
            DateUploaded         DATETIME2                    NOT NULL,
            OriginalSize         INT                          NOT NULL,
            PersistedSize        INT                          NOT NULL,
            CompressionAlgorithm TINYINT                      NOT NULL,
            EncryptionAlgorithm  TINYINT                      NOT NULL,
            Hash                 BINARY(32)                   NOT NULL,
            Data                 VARBINARY(MAX)
        );
    END
GO

-- INDEXES

IF NOT EXISTS (SELECT 1
               FROM sys.indexes
               WHERE name = 'IX_Files_Metadata'
                 AND object_id = OBJECT_ID('dbo.Files'))
    BEGIN
        CREATE NONCLUSTERED INDEX IX_Files_Metadata
            ON dbo.Files (FileID)
            INCLUDE (
                     Name,
                     Extension,
                     DateUploaded,
                     OriginalSize,
                     PersistedSize,
                     CompressionAlgorithm,
                     EncryptionAlgorithm,
                     Hash
                );
    END
GO
```

Below is the script for **PostgreSQL**:

```sql
-- Table creation
CREATE TABLE IF NOT EXISTS public.files
(
    fileid               UUID PRIMARY KEY NOT NULL,
    name                 VARCHAR(500)     NOT NULL,
    extension            VARCHAR(10)      NOT NULL,
    dateuploaded         TIMESTAMPTZ      NOT NULL,
    originalsize         INT              NOT NULL,
    persistedsize        INT              NOT NULL,
    compressionalgorithm SMALLINT         NOT NULL,
    encryptionalgorithm  SMALLINT         NOT NULL,
    hash                 BYTEA            NOT NULL,
    data                 BYTEA
);

-- Index creation
CREATE INDEX IF NOT EXISTS ix_files_metadata
    ON public.files (fileid)
    INCLUDE (name, extension, dateuploaded, originalsize, persistedsize, compressionalgorithm, encryptionalgorithm, hash);
```

Prior to use, this script can be run with the rights of a higher privilege user.

What if you don't want to use the name `Files` in SQL Server, or `files` in PostgreSQL?

We can **rewrite** the scripts to allow changing of the table name, so that at configuration the user can decide which name to use.

For **SQL Server**:

```sql
-- Modify the table name for use
DECLARE @TableName NVARCHAR(128) = 'Files';
DECLARE @SchemaName NVARCHAR(128) = 'dbo';
DECLARE @FullTableName NVARCHAR(256) = QUOTENAME(@SchemaName) + '.' + QUOTENAME(@TableName);
DECLARE @Sql NVARCHAR(MAX);

-- Check if table exists
IF NOT EXISTS (SELECT *
               FROM INFORMATION_SCHEMA.TABLES
               WHERE TABLE_NAME = @TableName
                 AND TABLE_SCHEMA = @SchemaName)
    BEGIN
        SET @Sql = '
    CREATE TABLE ' + @FullTableName + ' (
        FileID               UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
        Name                 NVARCHAR(500)                NOT NULL,
        Extension            NVARCHAR(10)                 NOT NULL,
        DateUploaded         DATETIME2                    NOT NULL,
        OriginalSize         INT                          NOT NULL,
        PersistedSize        INT                          NOT NULL,
        CompressionAlgorithm TINYINT                      NOT NULL,
        EncryptionAlgorithm  TINYINT                      NOT NULL,
        Hash                 BINARY(32)                   NOT NULL,
        Data                 VARBINARY(MAX)
    );';
        EXEC sp_executesql @Sql;
    END;

-- Check if index exists
IF NOT EXISTS (SELECT 1
               FROM sys.indexes
               WHERE name = 'IX_' + @TableName + '_Metadata'
                 AND object_id = OBJECT_ID(@FullTableName))
    BEGIN
        SET @Sql = '
    CREATE NONCLUSTERED INDEX' + ' IX_' + @TableName + '_Metadata
    ON ' + @FullTableName + ' (FileID)
    INCLUDE (
             Name,
             Extension,
             DateUploaded,
             OriginalSize,
             PersistedSize,
             CompressionAlgorithm,
             EncryptionAlgorithm,
             Hash
        );';
        EXEC sp_executesql @Sql;
    END;
```

For **PostgreSQL**:

```sql
DO $$
    DECLARE
        -- Change this to your desired table name
        table_name text := 'files';
    BEGIN
        EXECUTE format('
        CREATE TABLE IF NOT EXISTS public.%I (
            fileid               UUID PRIMARY KEY NOT NULL,
            name                 VARCHAR(500)     NOT NULL,
            extension            VARCHAR(10)      NOT NULL,
            dateuploaded         TIMESTAMPTZ      NOT NULL,
            originalsize         INT              NOT NULL,
            persistedsize        INT              NOT NULL,
            compressionalgorithm SMALLINT         NOT NULL,
            encryptionalgorithm  SMALLINT         NOT NULL,
            hash                 BYTEA            NOT NULL,
            data                 BYTEA
        );
    ', table_name);

        EXECUTE format('
                   CREATE INDEX IF NOT EXISTS ix_%I_metadata
    ON public.%I (fileid)
    INCLUDE (name, extension, dateuploaded, originalsize, persistedsize, compressionalgorithm, encryptionalgorithm, hash);
                   ', table_name,table_name);
    END $$;
```

The name of the table will be passed in the connection string.

For SQL Server it will look like this:

```plaintext
DataSource=myserver;uid=mylogin;pwd=mypass;database=mydatabase
```

And for PostgreSQL

```plaintext
Host=myserver;Username=mylogin;Password=mypass;Database=mydatabase
```

Which begs the question - what if we **omit the database**?

The code will actually still work - provided the other parameters are correct.

The problem is the table will be created in the system databases - `master` for **SQL Server** and `postgres` for **PostgreSQL**.

We will need to **parse** the connection string and ensure there is a **database** passed.

We can write two parsers for this, using the respective implementations of the [DbConnectionStringBuilder](https://learn.microsoft.com/en-us/dotnet/api/System.Data.Common.DbConnectionStringBuilder?view=net-9.0) for parsing.

For **SQL Server**:

```c#
public sealed class SqlServerConnectionStringParser
{
    private readonly string _connectionString;

    public SqlServerConnectionStringParser(string connectionString)
    {
        _connectionString = connectionString;
    }

    public string Database
    {
        get
        {
            var builder = new SqlConnectionStringBuilder(_connectionString);
            return builder.InitialCatalog;
        }
    }
}
```

For **PostgreSQL**

```c#
public sealed class PostgreSQLConnectionStringParser
{
    private readonly string _connectionString;

    public PostgreSQLConnectionStringParser(string connectionString)
    {
        _connectionString = connectionString;
    }

    public string? Database
    {
        get
        {
            var builder = new NpgsqlConnectionStringBuilder(_connectionString);
            return builder.Database;
        }
    }
}
```

Finally we can use the parser in the constructor of the `IStorageEngine` implementations.

SQL Server:

```c#
/// <summary>
/// Constructor, taking the connection string
/// </summary>
/// <param name="connectionString"></param>
public SqlServerStorageEngine(string connectionString)
{
    _connectionString = connectionString;
    // Parse the connection string
    var parser = new SqlServerConnectionStringParser(connectionString);
    if (string.IsNullOrEmpty(parser.Database))
        throw new ArgumentException($"{nameof(parser.Database)} cannot be null or empty");
}
```

PostgreSQL:

```c#
/// <summary>
/// Constructor, taking the connection string
/// </summary>
/// <param name="connectionString"></param>
public PosgrgreSQLStorageEngine(string connectionString)
{
    _connectionString = connectionString;
    // Parse the connection string for a database
    var parser = new PostgreSQLConnectionStringParser(connectionString);
    if (string.IsNullOrEmpty(parser.Database))
        throw new ArgumentException($"{nameof(parser.Database)} cannot be null or empty");
}
```

Thus we can ensure that the user has the responsibility to configure the database beforehand before using the component.

### TLDR

**In this post we have written scripts for the configuration of the SQL Server and PostgreSQL storage engines, as well as code to ensure a database is specified at startup.**

The code is in my [GitHub](https://github.com/conradakunga/UploadFileManager).

Happy hacking!
