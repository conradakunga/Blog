---
layout: post
title: Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 5 - Component Implementation
date: 2025-04-21 19:45:04 +0300
categories:
    - .NET
    - C#
    - OpenSource
    - Design
---

This is Part 5 of a series on Designing, Building & Packaging A Scalable, Testable .NET Open Source Component.

- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 1 - Introduction]({% post_url 2025-04-17-designing-building-packaging-a-scalable-testable-net-open-source-component-part-1-introduction %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 2 - Basic Requirements]({% post_url 2025-04-18-designing-building-packaging-a-scalable-testable-net-open-source-component-part-2-basic-requirements %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 3 - Project Setup]({% post_url 2025-04-19-designing-building-packaging-a-scalable-testable-net-open-source-component-part-3-project-setup %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 4 - Types & Contracts]({% post_url 2025-04-20-designing-building-packaging-a-scalable-testable-net-open-source-component-part-4-types-contracts %})
- **Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 5 - Component Implementation (This Post)**
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 6 - Mocking & Behaviour Tests]({% post_url 2025-04-22-designing-building-packaging-a-scalable-testable-net-open-source-component-part-6-mocking-behaviour-tests %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 7 - Sequence Verification With Moq]({% post_url 2025-04-23-designing-building-packaging-a-scalable-testable-net-open-source-component-part-7-sequence-verification-with-moq %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 8 - Compressor Implementation]({% post_url 2025-04-24-designing-building-packaging-a-scalable-testable-net-open-source-component-part-8-compressor-implementation %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 9 - Encryptor Implementation]({% post_url 2025-04-25-designing-building-packaging-a-scalable-testable-net-open-source-component-part-9-encryptor-implementation %})

In our [last post]({% post_url 2025-04-20-designing-building-packaging-a-scalable-testable-net-open-source-component-part-4-types-contracts %}), we set up the contracts and types we will use.

In this post, we will start **implementing** our component.

We previously discussed how the component would have **services injected** to perform the actual work.

We shall have injected these via [constructor injection]({% post_url 2025-01-07-dependency-injection-in-c-net-part-8-types-of-depedency-injection %}), which we have discussed earlier.

The initial skeleton will look like this:

```c#
namespace UploadFileManager;

public sealed class UploadFileManager : IUploadFileManager
{
    private readonly IFileCompressor _fileCompressor;
    private readonly IFileEncryptor _fileEncryptor;
    private readonly IFilePersistor _filePersistor;
    private readonly TimeProvider _timeProvider;

    public UploadFileManager(IFilePersistor filePersistor, IFileEncryptor fileEncryptor, IFileCompressor fileCompressor,
        TimeProvider timeProvider)
    {
      // Check that the injected services are valid
      ArgumentNullException.ThrowIfNull(filePersistor);
      ArgumentNullException.ThrowIfNull(fileEncryptor);
      ArgumentNullException.ThrowIfNull(fileCompressor);
      ArgumentNullException.ThrowIfNull(timeProvider);

      _filePersistor = filePersistor;
      _fileEncryptor = fileEncryptor;
      _fileCompressor = fileCompressor;
      _timeProvider = timeProvider;
    }

    /// <summary>
    /// Upload the file
    /// </summary>
    /// <param name="fileName"></param>
    /// <param name="extension"></param>
    /// <param name="data"></param>
    /// <param name="cancellationToken"></param>
    /// <returns></returns>
    /// <exception cref="NotImplementedException"></exception>
    public Task<FileMetadata> UploadFileAsync(string fileName, string extension, Stream data,
        CancellationToken cancellationToken = default)
    {
        throw new NotImplementedException();
    }

    /// <summary>
    /// Fetch the file metadata
    /// </summary>
    /// <param name="fileId"></param>
    /// <param name="cancellationToken"></param>
    /// <returns></returns>
    /// <exception cref="NotImplementedException"></exception>
    public Task<FileMetadata> FetchMetadataAsync(Guid fileId, CancellationToken cancellationToken = default)
    {
        throw new NotImplementedException();
    }

    /// <summary>
    /// Get the file
    /// </summary>
    /// <param name="fileId"></param>
    /// <param name="cancellationToken"></param>
    /// <returns></returns>
    /// <exception cref="NotImplementedException"></exception>
    public Task<Stream> DownloadFileAsync(Guid fileId, CancellationToken cancellationToken = default)
    {
        throw new NotImplementedException();
    }

    /// <summary>
    ///  Delete the file
    /// </summary>
    /// <param name="fileId"></param>
    /// <param name="cancellationToken"></param>
    /// <returns></returns>
    /// <exception cref="NotImplementedException"></exception>
    public Task<Stream> DeleteFileAsync(Guid fileId, CancellationToken cancellationToken = default)
    {
        throw new NotImplementedException();
    }

    /// <summary>
    /// Check if the file exists by ID
    /// </summary>
    /// <param name="fileId"></param>
    /// <param name="cancellationToken"></param>
    /// <returns></returns>
    /// <exception cref="NotImplementedException"></exception>
    public Task<bool> FileExistsAsync(Guid fileId, CancellationToken cancellationToken = default)
    {
        throw new NotImplementedException();
    }
}
```

Note that there aren't any **concrete implementations** of the services; we are just injecting the interfaces. Note also that we haven't written any **implementations** for the methods.

We shall proceed to **stitch together the injected services** to do the actual work.

First, we implement the `UploadFileAsync` method.

```c#
/// <summary>
/// Upload the file
/// </summary>
/// <param name="fileName"></param>
/// <param name="extension"></param>
/// <param name="data"></param>
/// <param name="cancellationToken"></param>
/// <returns></returns>
public async Task<FileMetadata> UploadFileAsync(string fileName, string extension, Stream data,
    CancellationToken cancellationToken = default)
{
    //Verify the passed in parameters are not null
    ArgumentException.ThrowIfNullOrWhiteSpace(fileName);
    ArgumentException.ThrowIfNullOrWhiteSpace(extension);
    ArgumentNullException.ThrowIfNull(data);

    // Verify the fileName has valid characters
    var invalidCharacters = Path.GetInvalidFileNameChars();
    if (invalidCharacters.Any(fileName.Contains))
        throw new ArgumentException($"The file name '{fileName}' contains invalid characters");

    // Verify the extension has valid characters
    if (invalidCharacters.Any(extension.Contains))
        throw new ArgumentException($"The extension '{extension}' contains invalid characters");

    // Validate the regex for the extension
    if (!Regex.IsMatch(extension, @"^\.\w+$"))
        throw new ArgumentException($"The extension {extension}' does not conform to the expected format: .xxx");

    //
    // Now carry out the work
    //

    // Compress the data
    var compressed = _fileCompressor.Compress(data);
    // Encrypt the data
    var encrypted = _fileEncryptor.Encrypt(compressed);

    // Build the metadata
    var fileID = Guid.CreateVersion7();
    byte[] hash;

    // Get a SHA256 hash of the original contents
    using (var sha = SHA256.Create())
        hash = await sha.ComputeHashAsync(data, cancellationToken);

    // Construct the metadata object
    var metadata = new FileMetadata
    {
        FileId = fileID,
        Name = fileName,
        Extension = extension,
        DateUploaded = _timeProvider.GetLocalNow().DateTime,
        OriginalSize = data.Length,
        PersistedSize = encrypted.Length,
        CompressionAlgorithm = _fileCompressor.CompressionAlgorithm,
        EncryptionAlgorithm = _fileEncryptor.EncryptionAlgorithm,
        Hash = hash
    };

    // Persist the file data
    await _filePersistor.StoreFileAsync(fileName, extension, encrypted, cancellationToken);
    return metadata;
}
```

A couple of things here:

1. For clarity, we have modified the `FileMetadata` type and renamed `CompressedSize` to `PersistedSize`.
2. We are using the [CreateVersion7](https://learn.microsoft.com/en-us/dotnet/api/system.guid.createversion7?view=net-9.0) of the [Guid](https://learn.microsoft.com/en-us/dotnet/api/system.guid?view=net-9.0) to generate sequential `Guids`, to reduce complications of storage if a database store is used.
3. We are injecting a [TimeProvider](https://learn.microsoft.com/en-us/dotnet/api/system.timeprovider?view=net-9.0) to make date-based testing easier.

Next, we will implement the `FetchMetadataAsync` method:

```c#
/// <summary>
/// Get the file metadata
/// </summary>
/// <param name="fileId"></param>
/// <param name="cancellationToken"></param>
/// <returns></returns>
public async Task<FileMetadata> FetchMetadataAsync(Guid fileId, CancellationToken cancellationToken = default)
{
  // Verify that the file exists first
  if (await _filePersistor.FileExistsAsync(fileId, cancellationToken))
      return await _filePersistor.GetMetadataAsync(fileId, cancellationToken);

  throw new FileNotFoundException($"The file '{fileId}' was not found");
}
```

Next, the `DownloadFileAsync` method:

```c#
/// <summary>
/// Get the file by ID
/// </summary>
/// <param name="fileId"></param>
/// <param name="cancellationToken"></param>
/// <returns></returns>
public async Task<Stream> DownloadFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
  // Verify that the file exists first
  if (await _filePersistor.FileExistsAsync(fileId, cancellationToken))
  {
      // Get the persisted file contents
      var persistedData = await _filePersistor.GetFileAsync(fileId, cancellationToken);
      // Decrypt the data
      var decryptedData = _fileEncryptor.Decrypt(persistedData);
      // Decompress the decrypted ata
      var uncompressedData = _fileCompressor.DeCompress(decryptedData);
      return uncompressedData;
  }

  throw new FileNotFoundException($"The file '{fileId}' was not found");
}
```

Next, the `DeleteFileAsync` method:

```c#
/// <summary>
/// Delete the file by ID
/// </summary>
/// <param name="fileId"></param>
/// <param name="cancellationToken"></param>
public async Task DeleteFileAsync(Guid fileId, CancellationToken cancellationToken = default)
{
  // Verify that the file exists first
  if (await _filePersistor.FileExistsAsync(fileId, cancellationToken))
      await _filePersistor.DeleteFileAsync(fileId, cancellationToken);

  throw new FileNotFoundException($"The file '{fileId}' was not found");
}
```

At this point, our implementation is complete, insofar as we are using **contracts** internally and no **concrete** types. We shall implement those later.

In our [next post]({% post_url 2025-04-22-designing-building-packaging-a-scalable-testable-net-open-source-component-part-6-mocking-behaviour-tests %}), we will see how to **test our component design and contracts**, even though we haven't implemented any of its services.

### TLDR

**This post implemented the functionality of the `UploadFileManager` component**

The code is in my [GitHub](https://github.com/conradakunga/UploadFileManager).

Happy hacking!
