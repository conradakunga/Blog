---
layout: post
title: Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 22 - Refactoring Azure Storage Engine For Initialization
date: 2025-05-29 08:49:30 +0300
categories:
    - .NET
    - C#
    - OpenSource
    - Design
    - Azure	
---

This is Part 22 of a series on Designing, Building & Packaging A Scalable, Testable .NET Open Source Component.

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
- **Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 22 - Refactoring For Proper Initialization (This Post)**

In our [previous post]({% post_url 2025-05-26-designing-building-packaging-a-scalable-testable-net-open-source-component-part-21-testing-amazon-s3-storage-locally %}) in the series, we looked at how to test [Amazon Storage](https://aws.amazon.com/) locally.

In this post, we will look at an issue we tackled in the previous post around async methods and how to **initialize** the `AzureStorageEngine` correctly.

### Azure

In the AzureStorageEngine, the constructor looks like this:

```c#
public AzureBlobStorageEngine(int timeoutInMinutes, string accountName, string accountKey, string azureLocation,
    string dataContainerName, string metadataContainerName)
{
    _accountName = accountName;
    _accountKey = accountKey;
    _azureLocation = azureLocation;
    _dataContainerName = dataContainerName;
    _metadataContainerName = metadataContainerName;
    TimeoutInMinutes = timeoutInMinutes;

    // Create a service client
    var blobServiceClient = new BlobServiceClient(
        new Uri($"{azureLocation}/{accountName}/"),
        new StorageSharedKeyCredential(accountName, accountKey));

    // Get our container clients
    _dataContainerClient = blobServiceClient.GetBlobContainerClient(dataContainerName);
    _metadataContainerClient = blobServiceClient.GetBlobContainerClient(metadataContainerName);
}
```

We then have an `Initialize` method that looks like this:

```c#
public async Task InitializeAsync(string accountName, string accountKey, string azureLocation,
    string dataContainerName, string metadataContainerName, CancellationToken cancellationToken = default)
{
    // Create a service client
    var blobServiceClient = new BlobServiceClient(
        new Uri($"{azureLocation}/{accountName}/"),
        new StorageSharedKeyCredential(accountName, accountKey));

    // Get our container clients
    var dataContainerClient = blobServiceClient.GetBlobContainerClient(dataContainerName);
    var metadataContainerClient = blobServiceClient.GetBlobContainerClient(metadataContainerName);

    // Ensure they exist
    if (!await dataContainerClient.ExistsAsync(cancellationToken))
        await dataContainerClient.CreateIfNotExistsAsync(cancellationToken: cancellationToken);
    if (!await metadataContainerClient.ExistsAsync(cancellationToken))
        await metadataContainerClient.CreateIfNotExistsAsync(cancellationToken: cancellationToken);
}
```

In an ideal world, we would have this code in the constructor.

However, [as we have seen]({% post_url 2025-05-28-calling-async-methods-in-constructors %}), this is not possible because there are several invocations of asynchronous methods, making `InitializeAsync` itself `async`.

There are three possible solutions to this problem:

1. The object that uses the `AzureBlobStorageEngine` must remember to initialize it. This is not a good solution, as any solution that requires someone to remember to do something is doomed.
2. Call `InitializeAsync` in every method, which is what we have currently done.
3. Rewrite the code to have the **initialization** part of its construction, which is what we will do.

The first step is to make the constructor private.

```c#
private AzureBlobStorageEngine(int timeoutInMinutes, string accountName, string accountKey, string azureLocation,
    string dataContainerName, string metadataContainerName)
{
    TimeoutInMinutes = timeoutInMinutes;

    // Create a service client
    var blobServiceClient = new BlobServiceClient(
        new Uri($"{azureLocation}/{accountName}/"),
        new StorageSharedKeyCredential(accountName, accountKey));

    // Get our container clients
    _dataContainerClient = blobServiceClient.GetBlobContainerClient(dataContainerName);
    _metadataContainerClient = blobServiceClient.GetBlobContainerClient(metadataContainerName);
}
```

Next, we make the `InitializeAsync` static and refactor it to construct and return an `AzureBlobStorageEngine` object. We also need to pass it all the parameters required to call the constructor.

```c#
public static async Task<AzureBlobStorageEngine> InitializeAsync(int timeoutInMinutes, string accountName,
        string accountKey,
        string azureLocation,
        string dataContainerName, string metadataContainerName, CancellationToken cancellationToken = default)
    {
        var engine = new AzureBlobStorageEngine(timeoutInMinutes, accountName, accountKey, azureLocation,
            dataContainerName, metadataContainerName);

        // Create a service client
        var blobServiceClient = new BlobServiceClient(
            new Uri($"{azureLocation}/{accountName}/"),
            new StorageSharedKeyCredential(accountName, accountKey));

        // Get our container clients
        var dataContainerClient = blobServiceClient.GetBlobContainerClient(dataContainerName);
        var metadataContainerClient = blobServiceClient.GetBlobContainerClient(metadataContainerName);

        // Ensure they exist
        if (!await dataContainerClient.ExistsAsync(cancellationToken))
            await dataContainerClient.CreateIfNotExistsAsync(cancellationToken: cancellationToken);
        if (!await metadataContainerClient.ExistsAsync(cancellationToken))
            await metadataContainerClient.CreateIfNotExistsAsync(cancellationToken: cancellationToken);

        return engine;
    }
```

You might have noticed that there is some element of **repetition** here, mostly around creating and initializing a separate `BlobServiceClient` to do some of the work.

I could have avoided this by exposing the internal client as a property, but I **deliberately chose not to do so, as I want the state within the object to be completely internal**.

Finally, I can refactor the methods that are currently like this:

```c#
/// <inheritdoc />
public async Task<FileMetadata> StoreFileAsync(FileMetadata metaData, Stream data,
    CancellationToken cancellationToken = default)
{
    // Get the clients
    var dataClient = _dataContainerClient.GetBlobClient(metaData.FileId.ToString());
    var metadataClient = _metadataContainerClient.GetBlobClient(metaData.FileId.ToString());

    // Upload data in parallel
    await Task.WhenAll(
        metadataClient.UploadAsync(new MemoryStream(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(metaData))),
            cancellationToken),
        dataClient.UploadAsync(data, cancellationToken));

    data.Position = 0;

    return metaData;
}

/// <inheritdoc />
public async Task<FileMetadata> GetMetadataAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the client
    var metadataClient = _metadataContainerClient.GetBlobClient(fileId.ToString());

    if (!await metadataClient.ExistsAsync(cancellationToken))
    {
        throw new FileNotFoundException($"File {fileId} not found");
    }

    // Retrieve the metadata
    var result = await metadataClient.DownloadContentAsync(cancellationToken: cancellationToken);
    if (result != null && result.HasValue)
    {
        return JsonSerializer.Deserialize<FileMetadata>(result.Value.Content.ToString())!;
    }

    throw new FileNotFoundException($"File {fileId} not found");
}

/// <inheritdoc />
public async Task<Stream> GetFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the client
    var dataClient = _dataContainerClient.GetBlobClient(fileId.ToString());

    if (!await FileExistsAsync(fileId, cancellationToken))
    {
        throw new FileNotFoundException($"File {fileId} not found");
    }

    // Download the blob as a stream
    var response = await dataClient.DownloadStreamingAsync(cancellationToken: cancellationToken);

    // Download into a memory stream
    await using (var stream = response.Value.Content)
    {
        var memoryStream = new MemoryStream();
        // Copy to memory stream
        await stream.CopyToAsync(memoryStream, cancellationToken);
        // Reset position
        memoryStream.Position = 0;
        return memoryStream;
    }
}

/// <inheritdoc />
public async Task DeleteFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the clients
    var dataClient = _dataContainerClient.GetBlobClient(fileId.ToString());
    var metadataClient = _metadataContainerClient.GetBlobClient(fileId.ToString());

    if (!await FileExistsAsync(fileId, cancellationToken))
    {
        throw new FileNotFoundException($"File {fileId} not found");
    }

    // Delete in parallel
    await Task.WhenAll(
        metadataClient.DeleteAsync(cancellationToken: cancellationToken),
        dataClient.DeleteAsync(cancellationToken: cancellationToken));
}

/// <inheritdoc />
public async Task<bool> FileExistsAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the client
    var dataClient = _dataContainerClient.GetBlobClient(fileId.ToString());
    // Check for existence
    return await dataClient.ExistsAsync(cancellationToken);
}
```

All the calls to `InitializeAsync` can be removed, since we can be sure that if the object has been created successfully, all the relevant state, including the `Clients`.

The code now looks like this:

```c#
/// <inheritdoc />
public async Task<FileMetadata> StoreFileAsync(FileMetadata metaData, Stream data,
    CancellationToken cancellationToken = default)
{
    // Get the clients
    var dataClient = _dataContainerClient.GetBlobClient(metaData.FileId.ToString());
    var metadataClient = _metadataContainerClient.GetBlobClient(metaData.FileId.ToString());

    // Upload data in parallel
    await Task.WhenAll(
        metadataClient.UploadAsync(new MemoryStream(Encoding.UTF8.GetBytes(JsonSerializer.Serialize(metaData))),
            cancellationToken),
        dataClient.UploadAsync(data, cancellationToken));

    data.Position = 0;

    return metaData;
}

/// <inheritdoc />
public async Task<FileMetadata> GetMetadataAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the client
    var metadataClient = _metadataContainerClient.GetBlobClient(fileId.ToString());

    if (!await metadataClient.ExistsAsync(cancellationToken))
    {
        throw new FileNotFoundException($"File {fileId} not found");
    }

    // Retrieve the metadata
    var result = await metadataClient.DownloadContentAsync(cancellationToken: cancellationToken);
    if (result != null && result.HasValue)
    {
        return JsonSerializer.Deserialize<FileMetadata>(result.Value.Content.ToString())!;
    }

    throw new FileNotFoundException($"File {fileId} not found");
}

/// <inheritdoc />
public async Task<Stream> GetFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the client
    var dataClient = _dataContainerClient.GetBlobClient(fileId.ToString());

    if (!await FileExistsAsync(fileId, cancellationToken))
    {
        throw new FileNotFoundException($"File {fileId} not found");
    }

    // Download the blob as a stream
    var response = await dataClient.DownloadStreamingAsync(cancellationToken: cancellationToken);

    // Download into a memory stream
    await using (var stream = response.Value.Content)
    {
        var memoryStream = new MemoryStream();
        // Copy to memory stream
        await stream.CopyToAsync(memoryStream, cancellationToken);
        // Reset position
        memoryStream.Position = 0;
        return memoryStream;
    }
}

/// <inheritdoc />
public async Task DeleteFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the clients
    var dataClient = _dataContainerClient.GetBlobClient(fileId.ToString());
    var metadataClient = _metadataContainerClient.GetBlobClient(fileId.ToString());

    if (!await FileExistsAsync(fileId, cancellationToken))
    {
        throw new FileNotFoundException($"File {fileId} not found");
    }

    // Delete in parallel
    await Task.WhenAll(
        metadataClient.DeleteAsync(cancellationToken: cancellationToken),
        dataClient.DeleteAsync(cancellationToken: cancellationToken));
}

/// <inheritdoc />
public async Task<bool> FileExistsAsync(Guid fileId, CancellationToken cancellationToken = default)
{
    // Get the client
    var dataClient = _dataContainerClient.GetBlobClient(fileId.ToString());
    // Check for existence
    return await dataClient.ExistsAsync(cancellationToken);
}
```

Much cleaner.

Our tests, of course, still pass.

![AzureBlobTestsRefactor](../images/2025/05/AzureBlobTestsRefactor.png)

### TLDR

**We have refactored the `AzureBlobStorageEngine` to ensure that it is initialized correctly upon object creation.**

The code is in my [GitHub](https://github.com/conradakunga/UploadFileManager/).

Happy hacking!
