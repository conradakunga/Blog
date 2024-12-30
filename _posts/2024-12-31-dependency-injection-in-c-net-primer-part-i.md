---
layout: post
title: Dependency Injection In C# & .NET Primer - Part I
date: 2024-12-31 15:27:56 +0300
categories:
    - C#
    - Domain Design
---

Suppose we are building a simple API that allows us to store files on behalf of users and allows them to download the files they have stored.

Let us think that through and build a **fully functional** component responsible for this.

The component, `FileStore`, will do the following:

1. Upload
    1. Accept a file from the user
    2. Save it to disk
    3. Return some sort of identifier to the user
2. Download
    1. Accept an identifier from the user
    2. Locate the file on disk
    3. Return the file to the user as a stream if it exists
    4. Throw an exception if it doesn't
3. Exists
    1. Accept an identifier from the user
    2. Check if the file exists
    3. Return `true` or `false`
4. Delete
    1. Accept an identifier from the user
    2. Delete the file if it exists
    3. Throw an exception if it doesn't
5. Get Metadata
    1. Accept an identifier from the user
    2. Return metadata if it exists
    3. Throw an exception if it doesn't

Additiional considerations are as follows:

1. The component will maintain Metadata consisting of the `FileName`, `UploadDate`, and the generated `Identifier` for each upload. The essential metadata is the name of the file, that is used for setting the content type and file name for download.
2. Metadata will be stored in a Metadata folder, with a simple strucutre - the FileName will be the generated identifier and the content will be the serialized JSON of the MetaData
3. Each stored file will be segregated by `UserID`  so as to prevent leakage by a dictionary attack. The upstream application will be respnsible for enforcing that the `UserID` is secured.
4. Duplicate uploads are allowed, but each will get assigned a new Identifier.

Our initial design, as all designs should be, is very simple.

The code is as follows:


```csharp
public sealed class DiskFileStore
{
    private readonly string _fileStorePath;
    private readonly string _userID;

    public DiskFileStore(string fileStorePath, string userID)
    {
        ArgumentException.ThrowIfNullOrEmpty(fileStorePath);
        ArgumentException.ThrowIfNullOrEmpty(userID);
        _fileStorePath = fileStorePath;
        _userID = userID;
    }

    public async Task<Guid> Upload(Stream fileStream, CancellationToken token)
    {
        // Generate a new identifier
        var id = Guid.CreateVersion7();
        // Check if per-user directory exists, create if not
        var fileStoreUserDirectory = Path.Combine(_fileStorePath, _userID);
        if (!Directory.Exists(fileStoreUserDirectory))
            Directory.CreateDirectory(fileStoreUserDirectory);

        token.ThrowIfCancellationRequested();

        // Build file path. Past here, we cannot cancel
        var fileStorePath = Path.Combine(fileStoreUserDirectory, id.ToString());
        await using (var stream = new FileStream(fileStorePath, FileMode.Create))
            await fileStream.CopyToAsync(stream, CancellationToken.None);

        return id;
    }

    public async Task<bool> Exists(Guid id)
    {
        var fileStorePath = Path.Combine(_fileStorePath, _userID, id.ToString());
        return await Task.FromResult(File.Exists(fileStorePath));
    }

    public Task Delete(Guid id)
    {
        var fileStorePath = Path.Combine(_fileStorePath, _userID, id.ToString());
        if (!File.Exists(fileStorePath))
            throw new FileNotFoundException();

        File.Delete(fileStorePath);
        return Task.CompletedTask;
    }

    public async Task<Stream> Download(Guid id, CancellationToken token)
    {
        // Build expected path of the file
        var filePath = Path.Combine(_fileStorePath, _userID, id.ToString());

        if (!File.Exists(filePath))
            throw new FileNotFoundException("File not found", filePath);

        token.ThrowIfCancellationRequested();

        // Return an async Stream
        return await Task.FromResult(new FileStream(filePath, FileMode.Open, FileAccess.Read, FileShare.Read, 4096,
            true));
    }
}
```

We then create a simple Web API that utilizes the component. For brevity I have ommited error handling.

```csharp
using System.Net.Mime;
using API;
using FileStore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<DiskFileStoreSettings>(builder.Configuration.GetSection(nameof(DiskFileStoreSettings)));

var app = builder.Build();

app.UseHttpsRedirection();

app.MapMethods("v1/Exists/{id:Guid}", ["Head"],
    async (Guid id, [FromHeader] string userID, IOptions<DiskFileStoreSettings> settings) =>
    {
        var store = new DiskFileStore(settings.Value.Path, userID);
        if (await store.Exists(id))
        {
            return Results.Ok();
        }

        return Results.NotFound();
    });

app.MapDelete("v1/Delete/{id:Guid}",
    async (Guid id, [FromHeader] string userID, IOptions<DiskFileStoreSettings> settings) =>
    {
        var store = new DiskFileStore(settings.Value.Path, userID);
        if (await store.Exists(id))
        {
            await store.Delete(id);
            return Results.Ok();
        }

        return Results.NotFound();
    });

app.MapPost("v1/Upload/",
    async (IFormFile file, [FromHeader] string userID, CancellationToken token,
        IOptions<DiskFileStoreSettings> settings) =>
    {
        if (file.Length == 0)
            return Results.BadRequest();

        var store = new DiskFileStore(settings.Value.Path, userID);
        await store.Upload(file.OpenReadStream(), token);
        return Results.Ok();
    });

app.MapGet("v1/Download/{id:Guid}",
    async (Guid id, [FromHeader] string userID, CancellationToken token,
        IOptions<DiskFileStoreSettings> settings) =>
    {
        var store = new DiskFileStore(settings.Value.Path, userID);
        if (!await store.Exists(id))
            return Results.NotFound();

        return Results.File(await store.Download(id, token), MediaTypeNames.Application.Octet);
    });

app.Run();
```

The settings for the path to the file storage location are in the `appsettings.config`, like this:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "DiskFileStoreSettings": {
    "Path": "/Users/rad/Projects/Temp"
  }
}
```