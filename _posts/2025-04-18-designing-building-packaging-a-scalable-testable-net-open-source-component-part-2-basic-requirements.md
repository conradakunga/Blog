---
layout: post
title: Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 2 - Basic Requirements
date: 2025-04-18 16:16:40 +0300
categories:
    - .NET
    - C#
    - OpenSource
    - Design
---

This is Part 2 of a series on Designing, Building & Packaging A Scalable, Testable .NET Open Source Component.

- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 1 - Introduction]({% post_url 2025-04-17-designing-building-packaging-a-scalable-testable-net-open-source-component-part-1-introduction %})
- **Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 2 - Basic Requirements (This Post)**
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
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 13 - Database Configuration]({% post_url 2025-04-29-designing-building-packaging-a-scalable-testable-net-open-source-component-part-13-database-configuration %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 14 - Virtualizing Infrastructure]({% post_url 2025-04-30-designing-building-packaging-a-scalable-testable-net-open-source-component-part-14-virtualizing-infrastructure %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 15 - Test Organization]({% post_url 2025-05-01-designing-building-packaging-a-scalable-testable-net-open-source-component-part-15-test-organization %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 16 - Large File Consideration]({% post_url 2025-05-02-designing-building-packaging-a-scalable-testable-net-open-source-component-part-16-large-file-consideration %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 17 - Large File Consideration On PostgreSQL]({% post_url 2025-05-03-designing-building-packaging-a-scalable-testable-net-open-source-component-part-17-large-file-consideration-on-postgresql %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 18 - Azure Blob Storage]({% post_url 2025-05-04-designing-building-packaging-a-scalable-testable-net-open-source-component-part-18-azure-blob-storage %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 19 - Testing Azure Blob Storage Locally]({% post_url 2025-05-05-designing-building-packaging-a-scalable-testable-net-open-source-component-part-19-testing-azure-blob-storage-locally %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 20 - Amazon S3 Storage]({% post_url 2025-05-25-designing-building-packaging-a-scalable-testable-net-open-source-component-part-20-amazon-s3-storage %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 21 - Testing Amazon S3 Storage Locally]({% post_url 2025-05-26-designing-building-packaging-a-scalable-testable-net-open-source-component-part-21-testing-amazon-s3-storage-locally %}) 

[Our last post]({% post_url 2025-04-17-designing-building-packaging-a-scalable-testable-net-open-source-component-part-1-introduction %}) was an introduction to this series.

This post will look at defining the basic requirements.

As explained earlier, I have a pet project that will require the uploading of files (PDFs to be precise), storage and then processing. These files may require re-processing, so I cannot discard them after completion.

They therefore need to be stored.

### Introduction

This is the rationale of what we are building.

We will build a component that facilitates the following:

1. **Uploading** (storage) of a file
2. **Retrieval** (download) of a file
3. **Deletion** of a file

Upon upload of a file, we need to generate some sort of **identifier** that can be used in the application.

Also, we probably will need to store some **metadata** to make it easier to implement some functionality in the application - for example a page to view file details, icon, etc.

This metadata will include:

1. File **name**
2. File **size** (in bytes)
3. **Extension** (Will need this to know how to render the file if being viewed by the browser)
4. **Date Uploaded**
5. File **Hash** (Hash to detect changes to the file (for whatever reason). Also to tell if this file has been uploaded before)

We can then improve this component by performing some operations before persistence. At present these will include:

1. **Compression** - whenever possible, cut down on storage
2. **Encryption** - in this age of hackers and mistakes, better encrypt the file contents in case the storage is ever breached.

With regards to storage, this component should support the following:

1. **File system** - the files will be stored on a folder in the server
2. **Database** - the files will be stored as [BLOBs](https://en.wikipedia.org/wiki/Binary_blob) on the database. Preliminary support will be for [SQL Server](https://www.microsoft.com/en-us/sql-server) first, and then [PostgreSQL](https://www.postgresql.org/)
3. **Cloud BLOB storage** - the files will be stored as BLOB objects in the cloud. Preliminary support will be for [Azure](https://azure.microsoft.com/en-us/) and [Amazon](https://aws.amazon.com/).

The component itself should support dependency injection, and should be configurable at this point in terms of:

- Storage, & settings
- Compression & settings
- Encryption & settings

The dependency injection requirement will make it easy to use for

- APIs
- Web applications
- Console applications
- Service applications

 We will build it in such a way to make it extensible so that it will be easy to support:

- Other databases - MySQL, SQLite
- Other BLOB storage providers - [Google](https://cloud.google.com/), [Dreamhost](https://www.dreamhost.com/cloud/storage/), [Hetzner](https://www.hetzner.com/storage/object-storage/), [Heroku](https://elements.heroku.com/addons/ah-s3-object-storage-stackhero)

Finally, some (preliminary) deliberate decisions

### Uniqueness

If you upload two files with the same name, **the system will treat them as different** and store both and give you two different IDs. We will not make any effort to detect and prevent duplicates (either by file name, or by contents)

### Context

Files are usually uploaded with some **context** - e.g. an upload file will belong to the logged in user. **This component will make no effort to preserve this - that will be responsibility of the application**. The component will purely deal with the file alone.

### Changes Of Settings

Given we are going to support encryption and compression, it will probably be a good idea to persist whatever encryption algorithm and compression algorithm were used at the point of storage as part of the metadata. This way should we need to change them, updating existing files will be much easier. It will look repetitive, but this is an acceptable choice to balance future changes.

### Hashing

We will use SHA

In our [next post]({% post_url 2025-04-19-designing-building-packaging-a-scalable-testable-net-open-source-component-part-3-project-setup %}) we shall setup our project and start the preliminary work.

### Encryption

We will use AES

### Compression

We will use Zip compression

### File IDs

We will use Guid as file IDs

### Update

There will be **no support for update**. To update, **delete** the existing and **upload** the replacement.

### TLDR

**This post outlines the requirements we want to address with the proposed software.**

Happy hacking!
