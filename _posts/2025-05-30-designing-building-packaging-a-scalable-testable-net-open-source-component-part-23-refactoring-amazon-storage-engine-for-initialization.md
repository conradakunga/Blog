---
layout: post
title: Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 23 - Refactoring Amazon Storage Engine For Initialization
date: 2025-05-30 21:52:14 +0300
categories:
    - .NET
    - C#
    - OpenSource
    - Design
    - Amazon	
---

This is Part 23 of a series on Designing, Building & Packaging A Scalable, Testable .NET Open Source Component.

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
- **Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 23 - Refactoring Amazon Storage Engine For Initialization (This Post)**
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 24 - Google Cloud Storage]({% post_url 2025-07-13-designing-building-packaging-a-scalable-testable-net-open-source-component-part-24-google-cloud-storage %})

Our [last post in the series]({% post_url 2025-05-29-designing-building-packaging-a-scalable-testable-net-open-source-component-part-22-refactoring-azure-storage-for-initialization %}) looked at how to refactor the `AzureBlobStorageEngine` to perform asynchronous initialization.

This post will examine the refactoring required to enable the `AmazonS3StorageEngine` to utilize asynchronous initialization.

The `constructor` for the `Amazon3StorageEngine` currently looks like this:

```c#
public AmazonS3StorageEngine(string username, string password, string amazonLocation, string dataContainerName,
    string metadataContainerName)
{
    // Configuration for the amazon s3 client
    var config = new AmazonS3Config
    {
        ServiceURL = amazonLocation,
        ForcePathStyle = true
    };

    _dataContainerName = dataContainerName;
    _metadataContainerName = metadataContainerName;
    _client = new AmazonS3Client(username, password, config);
    _utility = new TransferUtility(_client);
}
```

We then have a `InitializeAsync` method that looks like this:

```c#
public static async Task<AmazonS3StorageEngine> InitializeAsync(string username, string password,
    string amazonLocation,
    string dataContainerName,
    string metadataContainerName, CancellationToken cancellationToken = default)
{
    var engine = new AmazonS3StorageEngine(username, password, amazonLocation, dataContainerName,
        metadataContainerName);

    // Configuration for the amazon s3 client
    var config = new AmazonS3Config
    {
        ServiceURL = amazonLocation,
        ForcePathStyle = true
    };

    var client = new AmazonS3Client(username, password, config);
    // Check if the metadata bucket exists
    if (!await AmazonS3Util.DoesS3BucketExistV2Async(client, metadataContainerName))
    {
        var request = new PutBucketRequest
        {
            BucketName = metadataContainerName,
            UseClientRegion = true
        };

        await client.PutBucketAsync(request, cancellationToken);
    }

    // Check if the data bucket exists
    if (!await AmazonS3Util.DoesS3BucketExistV2Async(client, dataContainerName))
    {
        var request = new PutBucketRequest
        {
            BucketName = dataContainerName,
            UseClientRegion = true
        };

        await client.PutBucketAsync(request, cancellationToken);
    }

    return engine;
}
```

As before, our first step is to make the `constructor` **private**, so that we control the initialization of the object.

```c#
private AmazonS3StorageEngine(string username, string password, string amazonLocation, string dataContainerName,
    string metadataContainerName)
{
    // Configuration for the amazon s3 client
    var config = new AmazonS3Config
    {
        ServiceURL = amazonLocation,
        ForcePathStyle = true
    };

    _dataContainerName = dataContainerName;
    _metadataContainerName = metadataContainerName;
    _client = new AmazonS3Client(username, password, config);
    _utility = new TransferUtility(_client);
}
```

Next, we make the `InitializeAsync` static and refactor it to construct and return an `AmazonS3StorageEngine` object. We also need to pass all the parameters required to call the constructor.

```c#
public static async Task<AmazonS3StorageEngine> InitializeAsync(string username, string password,
    string amazonLocation,
    string dataContainerName,
    string metadataContainerName, CancellationToken cancellationToken = default)
{
    var engine = new AmazonS3StorageEngine(username, password, amazonLocation, dataContainerName,
        metadataContainerName);

    // Configuration for the amazon s3 client
    var config = new AmazonS3Config
    {
        ServiceURL = amazonLocation,
        ForcePathStyle = true
    };

    var client = new AmazonS3Client(username, password, config);
    // Check if the metadata bucket exists
    if (!await AmazonS3Util.DoesS3BucketExistV2Async(client, metadataContainerName))
    {
        var request = new PutBucketRequest
        {
            BucketName = metadataContainerName,
            UseClientRegion = true
        };

        await client.PutBucketAsync(request, cancellationToken);
    }

    // Check if the data bucket exists
    if (!await AmazonS3Util.DoesS3BucketExistV2Async(client, dataContainerName))
    {
        var request = new PutBucketRequest
        {
            BucketName = dataContainerName,
            UseClientRegion = true
        };

        await client.PutBucketAsync(request, cancellationToken);
    }

    return engine;
}
```

Again, we have some repetition here - we are creating another `AmazonS3Client`, but this one is **specifically to perform initialization work**, as well as its necessary configuration.

The last step is the methods that all currently call `InitializeAsync`:

```c#
/// <inheritdoc />
public async Task<FileMetadata> StoreFileAsync(FileMetadata metaData, Stream data,
    CancellationToken cancellationToken = default)
{
    // Initialize
    await InitializeAsync(cancellationToken);

    // Upload the data and the metadata in parallel
    await Task.WhenAll(
        _utility.UploadAsync(new MemoryStream(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(metaData))),
            _metadataContainerName, metaData.FileId.ToString(), cancellationToken),
        _utility.UploadAsync(data, _dataContainerName, metaData.FileId.ToString(), cancellationToken)
    );
    return metaData;
}

/// <inheritdoc />
public async Task<FileMetadata> GetMetadataAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Initialize
    await InitializeAsync(cancellationToken);

    //Verify file exists
    if (!await FileExistsAsync(fileId, _metadataContainerName, cancellationToken))
        throw new FileNotFoundException($"File {fileId} not found");

    // Create a request
    var request = new GetObjectRequest
    {
        BucketName = _metadataContainerName,
        Key = fileId.ToString()
    };

    // Retrieve the data
    using var response = await _client.GetObjectAsync(request, cancellationToken);
    await using var responseStream = response.ResponseStream;
    var memoryStream = new MemoryStream();
    await responseStream.CopyToAsync(memoryStream, cancellationToken);

    // Reset position
    memoryStream.Position = 0;
    using var reader = new StreamReader(memoryStream);
    var content = await reader.ReadToEndAsync(cancellationToken);
    return JsonSerializer.Deserialize<FileMetadata>(content) ?? throw new FileNotFoundException();
}

/// <inheritdoc />
public async Task<Stream> GetFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Initialize
    await InitializeAsync(cancellationToken);

    //Verify file exists
    if (!await FileExistsAsync(fileId, _dataContainerName, cancellationToken))
        throw new FileNotFoundException($"File {fileId} not found");

    // Create a request
    var request = new GetObjectRequest
    {
        BucketName = _dataContainerName,
        Key = fileId.ToString()
    };

    // Retrieve the data
    using var response = await _client.GetObjectAsync(request, cancellationToken);
    await using var responseStream = response.ResponseStream;
    var memoryStream = new MemoryStream();
    await responseStream.CopyToAsync(memoryStream, cancellationToken);
    // Reset position
    memoryStream.Position = 0;
    return memoryStream;
}

/// <inheritdoc />
public async Task DeleteFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Initialize
    await InitializeAsync(cancellationToken);

    //Verify file exists
    if (!await FileExistsAsync(fileId, _dataContainerName, cancellationToken))
        throw new FileNotFoundException($"File {fileId} not found");

    // Delete metadata and data in parallel
    await Task.WhenAll(
        _client.DeleteObjectAsync(_metadataContainerName, fileId.ToString(), cancellationToken),
        _client.DeleteObjectAsync(_dataContainerName, fileId.ToString(), cancellationToken));
}

/// <inheritdoc />
public async Task<bool> FileExistsAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Initialize
    await InitializeAsync(cancellationToken);

    return await FileExistsAsync(fileId, _dataContainerName, cancellationToken);
}

private async Task<bool> FileExistsAsync(Guid fileId, string containerName,
    CancellationToken cancellationToken = default)
{
    try
    {
        await _client.GetObjectMetadataAsync(containerName, fileId.ToString(), cancellationToken);
        return true;
    }
    catch (AmazonS3Exception ex)
    {
        if (ex.StatusCode == HttpStatusCode.NotFound)
        {
            return false;
        }

        throw;
    }
}
```

We can **remove all those calls**, so that they now look like this:

```c#
/// <inheritdoc />
public async Task<FileMetadata> StoreFileAsync(FileMetadata metaData, Stream data,
    CancellationToken cancellationToken = default)
{
    // Upload the data and the metadata in parallel
    await Task.WhenAll(
        _utility.UploadAsync(new MemoryStream(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(metaData))),
            _metadataContainerName, metaData.FileId.ToString(), cancellationToken),
        _utility.UploadAsync(data, _dataContainerName, metaData.FileId.ToString(), cancellationToken)
    );
    return metaData;
}

/// <inheritdoc />
public async Task<FileMetadata> GetMetadataAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    //Verify file exists
    if (!await FileExistsAsync(fileId, _metadataContainerName, cancellationToken))
        throw new FileNotFoundException($"File {fileId} not found");

    // Create a request
    var request = new GetObjectRequest
    {
        BucketName = _metadataContainerName,
        Key = fileId.ToString()
    };

    // Retrieve the data
    using var response = await _client.GetObjectAsync(request, cancellationToken);
    await using var responseStream = response.ResponseStream;
    var memoryStream = new MemoryStream();
    await responseStream.CopyToAsync(memoryStream, cancellationToken);

    // Reset position
    memoryStream.Position = 0;
    using var reader = new StreamReader(memoryStream);
    var content = await reader.ReadToEndAsync(cancellationToken);
    return JsonSerializer.Deserialize<FileMetadata>(content) ?? throw new FileNotFoundException();
}

/// <inheritdoc />
public async Task<Stream> GetFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    //Verify file exists
    if (!await FileExistsAsync(fileId, _dataContainerName, cancellationToken))
        throw new FileNotFoundException($"File {fileId} not found");

    // Create a request
    var request = new GetObjectRequest
    {
        BucketName = _dataContainerName,
        Key = fileId.ToString()
    };

    // Retrieve the data
    using var response = await _client.GetObjectAsync(request, cancellationToken);
    await using var responseStream = response.ResponseStream;
    var memoryStream = new MemoryStream();
    await responseStream.CopyToAsync(memoryStream, cancellationToken);
    // Reset position
    memoryStream.Position = 0;
    return memoryStream;
}

/// <inheritdoc />
public async Task DeleteFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    //Verify file exists
    if (!await FileExistsAsync(fileId, _dataContainerName, cancellationToken))
        throw new FileNotFoundException($"File {fileId} not found");

    // Delete metadata and data in parallel
    await Task.WhenAll(
        _client.DeleteObjectAsync(_metadataContainerName, fileId.ToString(), cancellationToken),
        _client.DeleteObjectAsync(_dataContainerName, fileId.ToString(), cancellationToken));
}

/// <inheritdoc />
public async Task<bool> FileExistsAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    return await FileExistsAsync(fileId, _dataContainerName, cancellationToken);
}

private async Task<bool> FileExistsAsync(Guid fileId, string containerName,
    CancellationToken cancellationToken = default)
{
    try
    {
        await _client.GetObjectMetadataAsync(containerName, fileId.ToString(), cancellationToken);
        return true;
    }
    catch (AmazonS3Exception ex)
    {
        if (ex.StatusCode == HttpStatusCode.NotFound)
        {
            return false;
        }

        throw;
    }
}
```

Again, we derive the benefit that we are sure that once we receive the created `AmazonS3StorageEngine`, it has been **correctly configured** in terms of setting up all the necessary `bucket` objects.

Our tests, we can confirm, still pass.

![AmazonsS3RefactorTests](../images/2025/05/AmazonsS3RefactorTests.png)

### TLDR

**We have refactored the `AmazonS3StorageEngine` to ensure that it is initialized correctly upon object creation.**

The code is in my [GitHub](https://github.com/conradakunga/UploadFileManager/).

Happy hacking!
