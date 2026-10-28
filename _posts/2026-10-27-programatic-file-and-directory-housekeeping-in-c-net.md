---
layout: post
title: Programatic File And Directory HouseKeeping In C# & .NET
date: 2026-10-27 14:49:44 +0300
categories:
    - C#
    - .NET
---

In an earlier post, "[What Happens When You Do File.Delete For A Non-Existent File In C# & .NET]({% post_url 2026-10-25-what-happens-when-you-do-filedelete-for-a-non-existent-file-in-c-net %})", I mentioned working on a utility that **generated** and **processed** some files.

Towards the end there was some **housekeeping** where I needed to **delete** the generated files, as well as the **directory** that they were in.

The code was straightforward enough.

```c#
// Get the files to process
var files = Directory.GetFiles(rootFolder);

//
// Processing takes place here
//

// Delete the files
Parallel.ForEach(files, file =>
{
  File.Delete(file);
});

// Delete the folder
Directory.Delete(rootFolder);
```

At first glance, simple enough.

Until you realize **there is no reason to delete the files first, and then the folder**.

You can **delete the folder directly, and its files will go with it**.

Like so:

```c#
Directory.Delete(rootFolder);
```

And we're done.

Not so fast! [Directory.Delete](https://learn.microsoft.com/en-us/dotnet/api/system.io.directory.delete?view=net-10.0#system-io-directory-delete(system-string)) will throw an `exception` if the **directory is not empty**!

Luckily there is an overload for this:

```c#
Directory.Delete(rootfolder, true)
```

This accepts a **flag** that tells the runtime to do a **recursive deletion of the contents of the folder**.

Our code now is like so:

```c#
// Get the files to process
var files = Directory.GetFiles(rootFolder);

//
// Processing takes place here
//

// Delete the folder and it's contents
Directory.Delete(rootFolder);
```

If, however, you needed some sort of **log** or **indication of the individual deleted files activity**, you might want to use my initial approach.

### TLDR

**You can use the overload for `Directory.Delete` that recursively deletes its contents to avoid having to delete the files first.**

Happy hacking!
