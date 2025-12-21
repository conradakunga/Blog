---
layout: post
title: Security Benefits of Path.Combine & DirectoryInfo in C# & .NET
date: 2025-12-18 19:34:47 +0300
categories:
    - C#
    - .NET
---

When working with applications that handle and/or manipulate files, you will often find yourself having to **construct a file or directory path** with multiple parts.

Take, for example, this scenario:

1. Your application **manipulates** files.
2. The file path is built from a `root`, a `base` path, and a `child` path.

The code would look something like this:

```c#
// Define root location
const string root = "/Users/rad/Projects/blog/";

// Set upload path
var uploadPath = root + "uploads/logo.jpg";

Console.WriteLine(uploadPath);
```

If we run this code, it will print the following:

```plaintext
/Users/rad/Projects/blog/uploads/logo.jpg
```

Which seems innocent enough.

Now, assume the user (or a bug!) allows for **manipulation of the upload path**.

The path would be specified as follows:

```c#
// Define root location
const string root = "/Users/rad/Projects/blog/";

// Set upload path
var uploadPath = root + "uploads/" + "../../../../logo.jpg";

Console.WriteLine(uploadPath);
```

This will print the following:

```plaintext
/Users/rad/Projects/blog/../../../../logo.jpg
```

Which looks ... **untidy**.

But **what does this location actually resolve to**?

We can write code to **evaluate** that for us, using the [DirectoryInfo](https://learn.microsoft.com/en-us/dotnet/api/system.io.directoryinfo?view=net-10.0) class:

```c#
Console.WriteLine(new DirectoryInfo(uploadPath).FullName);
```

This will print the following:

```plaintext
/logo.jpg
```

This means that the file location is now in the `root`.

In this manner, we have `escaped` the `blog` folder and are now in the `root`.

Depending on your security setup, this can have **severe implications**. If your application can **write to the root** folder, what **damage** can you cause?

This problem can be mitigated as follows:

1. Use the [Path.Combine](https://learn.microsoft.com/en-us/dotnet/api/system.io.path.combine?view=net-10.0) API
2. **Validate** the newly constructed path.

## Path.Combine

The benefits of `Path.Combine` are as follows:

1. You can combine any number of segments into a new path.
2. It is aware of the operating system separators - Unix, Linux & macOS use `/` while Windows uses `\` 
3. You don't need to worry about separators leading and trailing segments within the child paths.

The code will look like this:

```c#
// Define root location
const string root = "/Users/rad/Projects/blog";

// Set upload path
var illegalUploadPath = Path.Combine(root, "uploads", "../../../../logo.jpg");
var legalUploadPath = Path.Combine(root, "uploads", "logo.jpg");
```

## Validate Path

The next step is to validate the paths by **checking that the base corresponds to what we have generated**.

Let us update our code to print the generated paths:

```c#
// Define root location
const string root = "/Users/rad/Projects/blog";

// Set upload path
var illegalUploadPath = Path.Combine(root, "uploads", "../../../../logo.jpg");
var legalUploadPath = Path.Combine(root, "uploads", "logo.jpg");

Console.WriteLine(illegalUploadPath);
Console.WriteLine(legalUploadPath);
```

This will print the following:

```plaintext
/Users/rad/Projects/blog/uploads/../../../../logo.jpg
/Users/rad/Projects/blog/uploads/logo.jpg
```

We can see here that the illegal path contains **directory navigation** elements - `../`.

We can validate this using the `DirectoryInfo` class to resolve the name, and then checking the path from that.

```c#
// Resolve the paths
var legalInfo = new DirectoryInfo(legalUploadPath);
var illegalInfo = new DirectoryInfo(illegalUploadPath);

// Verify the parent
if (legalInfo.Parent.Parent.FullName == root)
	Console.WriteLine($"'{legalInfo}' is a valid path");
if (illegalInfo.Parent.Parent.FullName != root)
	Console.WriteLine($"ERROR: '{legalInfo}' is an invalid valid path");
```

We are calling `Parent.Parent` twice because the **parent** of `/Users/rad/Projects/blog/uploads/logo.jpg` is `/Users/rad/Projects/blog/uploads/`, and we are interested in the **parent** of this, `/Users/rad/Projects/blog`.

Validation here is comparing that value with the original **root**, `/Users/rad/Projects/blog`

We can see that the `legalInfo` successfully validates, but `illegalInfo` does not.

We can then throw an [exception](https://learn.microsoft.com/en-us/dotnet/api/system.exception?view=net-10.0) or **otherwise respond** to an attempt to manipulate the paths to access an **invalid location**.

### TLDR

**`Path.Combine()` and `DirectoryInfo` can be used together to validate user path inputs to ensure attempts to escape a designated location are thwarted.**

The code is in my GitHub.

Happy hacking!
