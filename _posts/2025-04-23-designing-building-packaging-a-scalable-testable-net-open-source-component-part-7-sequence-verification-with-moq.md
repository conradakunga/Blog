---
layout: post
title: Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 7 - Sequence Verification With Moq
date: 2025-04-23 21:21:29 +0300
categories:
    - .NET
    - C#
    - OpenSource
    - Design
    - Testing
    - StarLibrary
    - Moq
---

This is Part 7 of a series on Designing, Building & Packaging A Scalable, Testable .NET Open Source Component.

- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 1 - Introduction]({% post_url 2025-04-17-designing-building-packaging-a-scalable-testable-net-open-source-component-part-1-introduction %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 2 - Basic Requirements]({% post_url 2025-04-18-designing-building-packaging-a-scalable-testable-net-open-source-component-part-2-basic-requirements %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 3 - Project Setup]({% post_url 2025-04-19-designing-building-packaging-a-scalable-testable-net-open-source-component-part-3-project-setup %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 4 - Types & Contracts]({% post_url 2025-04-20-designing-building-packaging-a-scalable-testable-net-open-source-component-part-4-types-contracts %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 5 - Component Implementation]({% post_url 2025-04-21-designing-building-packaging-a-scalable-testable-net-open-source-component-part-5-component-implementation %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 6 - Mocking & Behaviour Tests]({% post_url 2025-04-22-designing-building-packaging-a-scalable-testable-net-open-source-component-part-6-mocking-behaviour-tests %})
- **Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 7 - Sequence Verification With Moq (This Post)**
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
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 22 - Refactoring Azure Storage Engine For Initialization]({% post_url 2025-05-29-designing-building-packaging-a-scalable-testable-net-open-source-component-part-22-refactoring-azure-storage-for-initialization %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 23 - Refactoring Amazon Storage Engine For Initialization]({% post_url 2025-05-30-designing-building-packaging-a-scalable-testable-net-open-source-component-part-23-refactoring-amazon-storage-engine-for-initialization %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 24 - Google Cloud Storage]({% post_url 2025-07-13-designing-building-packaging-a-scalable-testable-net-open-source-component-part-24-google-cloud-storage %})

Our last post explored how to write **behaviour tests** via **mocking** using [Moq](https://github.com/devlooped/moq).

This post will look at additional **improvements to verify** that our component behaves correctly.

In our code, the following takes place:

1. **Compression**
2. **Encryption** 
3. **Storage**

These have to take place in the **correct order**. How do we verify the correct order?

As a reminder, the signatures are as follows:

```c#
// Compress the data
var compressed = _fileCompressor.Compress(data);
// Encrypt the data
var encrypted = _fileEncryptor.Encrypt(compressed);
//
// Snipped out code
//
// Persist the file data
await _filePersistor.StoreFileAsync(fileName, extension, encrypted, cancellationToken);
        return metadata;
```

One way would be to assert that the **specific arguments were called**, given that we have set them up.

```c#
// Check that the compressor's Compress method was called once
compressor.Verify(x => x.Compress(new MemoryStream(originalBytes)), Times.Once);
// Check that the encryptor's Encrypt method was called once
encryptor.Verify(x => x.Encrypt(new MemoryStream(compressedBytes)), Times.Once);
// Check that the persistor's StoreFileAsync method was called once
persistor.Verify(
    x => x.StoreFileAsync(fileName, extension, new MemoryStream(encryptedBytes),
        CancellationToken.None),
    Times.Once);
```

This, however, does not work as a [Stream](https://learn.microsoft.com/en-us/dotnet/api/system.io.stream?view=net-9.0) is a reference type, and therefore the **Moq** engine cannot determine **equality** out of the box without some extra work.

Luckily, a better solution exists: **Moq** supports a construct - the `MockSequence`. This can be used to set up the **order in which methods are expected to be called**.

This is implemented as follows:

```c#
// Create a sequence to track invocation order
var sequence = new MockSequence();

// Configure the behaviour for methods called and properties, specifying the sequence
compressor.InSequence(sequence).Setup(x => x.Compress(It.IsAny<Stream>()))
    .Returns(new MemoryStream(compressedBytes));
compressor.Setup(x => x.CompressionAlgorithm)
    .Returns(CompressionAlgorithm.Zip);

encryptor.InSequence(sequence).Setup(x => x.Encrypt(It.IsAny<Stream>()))
    .Returns(new MemoryStream(encryptedBytes));
encryptor.Setup(x => x.EncryptionAlgorithm)
    .Returns(EncryptionAlgorithm.Aes);

persistor.InSequence(sequence).Setup(x =>
        x.StoreFileAsync(It.IsAny<string>(), It.IsAny<string>(), It.IsAny<Stream>(),
            CancellationToken.None))
    .ReturnsAsync(metaData)
```

**Note that I have reorderd the setup to conform to the sequence, as now it matters.**

The magic is taking place in this call:

```c#
Service.InSequence(sequence).Setup
```

Each time we pass in the `sequence` object, the **mock** is instructed on the expected order.

If we run our code now, our tests will pass.

To verify that the order is enforced, try modifying this code in the `UploadFileManager` to **swap** the order.

```c#
// Compress the data
var compressed = _fileCompressor.Compress(data);
// Encrypt the data
var encrypted = _fileEncryptor.Encrypt(compressed);
//
// Snipped out code
//
// Persist the file data
      await _filePersistor.StoreFileAsync(fileName, extension, encrypted, cancellationToken);
      return metadata;
```

To look like this;

```c#
// Encrypt the data
var encrypted = _fileEncryptor.Encrypt(compressed);
// Compress
var compressed = _fileCompressor.Compress(data);
//
// Snipped out code
//
// Persist the file data
      await _filePersistor.StoreFileAsync(fileName, extension, compressed, cancellationToken);
      return metadata;
```

Upon running, the test now **fails**.

![OrderFail](../images/2025/04/OrderFail.png)

The error message, though, is not very **helpful** for troubleshooting.

```plaintext
Moq.MockException: IFileEncryptor.Encrypt(MemoryStream) invocation failed with mock behavior Strict.

Moq.MockException
IFileEncryptor.Encrypt(MemoryStream) invocation failed with mock behavior Strict.
All invocations on the mock must have a corresponding setup.
   at Moq.FailForStrictMock.Handle(Invocation invocation, Mock mock) in /_/src/Moq/Interception/InterceptionAspects.cs:line 182
```

In our [next post]({% post_url 2025-04-24-designing-building-packaging-a-scalable-testable-net-open-source-component-part-8-compressor-implementation %}), we will start to implement the concrete implementations of the services.

### TLDR

**Using the `MockSequence`, `Moq` allows us to verify the sequence in which methods are called.**

The code is in my [GitHub](https://github.com/conradakunga/UploadFileManager).

Happy hacking!
