---
layout: post
title: Downloading Files With ASP.NET Core Minimal API
date: 2024-12-30 16:48:09 +0300
categories:
   - ASP.NET
   - C#
---

Just as you may need to write an [API that supports file uploading]({% post_url 2024-12-29-uploading-files-with-aspnet-core-minimal-api %}), you may also need to do the opposite -- allowing users to specify a file for download.

As with all things, this requires a bit of upfront preparation.

1. How will the user specify the file to be downloaded?
2. From where will the file specified be retrieved?
3. How do we protect the application from malicious users?
4. How do we serve the file to the user?

The code below is a working implementation of how this can be tackled.

```csharp
using System.Net.Mime;
using Microsoft.AspNetCore.StaticFiles;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// The location that uploaded files will be stored
// This ideally should be stored as a setting
const string fileStoreLocation = "/Users/rad/Projects/Temp/Conrad/Uploaded";

// Create the location, if it doesn't exist
if (!Directory.Exists(fileStoreLocation))
    Directory.CreateDirectory(fileStoreLocation);

// Allowed file extensions
string[] allowedFileExtensions = [".jpg", ".jpeg", ".png", ".gif", ".pdf", ".docx", ".xlsx"];

app.MapGet("/Download/{fileName}", (string fileName, ILogger<Program> logger) =>
    {
        var fileExtension = Path.GetExtension(fileName);
        if (!allowedFileExtensions.Contains(fileExtension))
        {
            logger.LogWarning("Download file {FileName} is a {Extension} which is blocked", fileName,
                fileExtension);
            return Results.BadRequest("Blocked file extension");
        }

        // Build the path to the download file
        var storeFileName = Path.Combine(fileStoreLocation, Path.GetFileName(fileName));

        // Check if file exists
        if (!File.Exists(storeFileName))
        {
            logger.LogWarning("File {FileName} was not found", fileName);
            return Results.NotFound($"{fileName} not found");
        }

        // Determine the content type for the extension, defaulting to "application/ octet-stream"
        if (!new FileExtensionContentTypeProvider().TryGetContentType(fileName, out var contentType))
        {
            contentType = MediaTypeNames.Application.Octet;
        }

        // Open a stream to the file
        var stream = new FileStream(storeFileName, FileMode.Open, FileAccess.Read, FileShare.Read, 4096,
            true);
        // Return file inline asynchronously in chunks directly to browser
        return Results.File(stream, contentType, enableRangeProcessing: true);
    })
    .WithName("DownloadFile");
    
app.Run();
```

The code does the following setup:

1. Sets the location where the files will be **downloaded from**. This would normally be stored and loaded from application settings.
2. **Creates** the location if it does not already exist
3. Defines an array of **allowable file extensions for download**. It is better to be explicit and specify what you allow rather than the other way - specifying what you don't allow.

Then, we configure the API to accept a [GET](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET) request to download a file, specifying the filename in the path.

A request would this look like this:

```plaintext
http://localhost:5029/Download/Invoice.pdf
```

The API then:

1. **Validates** that the extension is allowed, returning a [BadRequest (400)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400) otherwise
2. **Sanitizes the file path** and name and then combines it with the specified storage location in order to protect against a [directory traversal attack](https://owasp.org/www-community/attacks/Path_Traversal).

    This code, in particular:
    ```csharp
    Path.GetFileName(fileName)
    ```

    Converts a path specified as "`../../file.pdf"` to just `"file.pdf"`. If we did not do this, the server would attempt to serve files from **outside** the specified location.
3. **Check that the file exists**. If not, return a [NotFound (404)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404)
4. If found, we then try to **generate a content-type header string** for the file based on its name. If we can't find any, we default to  "`application/ octet-stream"`, which we specify using the constant `MediaTypeNames.Application.Octet`
5. We then create an [asynchronous stream](https://learn.microsoft.com/en-us/dotnet/api/system.io.fileoptions?view=net-9.0) from the target path that we **serve to the request** using [Results.File](https://learn.microsoft.com/en-us/dotnet/api/microsoft.aspnetcore.http.results.file?view=aspnetcore-9.0). In this implementation, the file is rendered in the browser (where possible). This is called **inline rendering.** An asynchronous stream allows buffering of chunked reads so that the entire contents of the file do not need to be read at once into memory. This can yield better performance, especially if there are many requests and the files are large.

There are times when you would want the file **NOT** to be rendered in the browser but always to download. This is done by specifying a `FileName` in the `Results.File` call. This adds the following [additional header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers)  - [Content-Disposition](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition) to the response:

```plaintext
Content-Disposition: attachment; filename*=UTF-8''file%20name.jpg
```

This header tells the browser to download the file directly.

### TLDR

**Using Minimal API you can build secure, performant APIs that allow for the download of files.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2024-12-30%20-%20Minimal%20API%20File%20Download).

Happy hacking!