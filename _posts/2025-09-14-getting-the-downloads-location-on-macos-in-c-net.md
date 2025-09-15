---
layout: post
title: Getting The Downloads Location On macOS In C# & .NET
date: 2025-09-14 23:03:37 +0300
categories:
    - C#
    - .NET
---

Our previous post, "[Getting The Downloads Location On Windows In C# & .NET]({% post_url 2025-09-13-getting-the-downloads-location-on-windows-in-c-net %})", looked at how to reliably get the Downloads folder on Windows via the Windows API.

In this post, we look at how to tackle the same problem on macOS.

From a few references, it seems that the folder is always called `Downloads` regardless of the install language. **Localization** (how to display this to the user) is tackled **without physically changing the download location**.

The following code should work:

```c#
// Get the home location
string homeLocation = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
// Build the download path
string downloadLocation = Path.Combine(homeLocation, "Downloads");
// Check that the location exists
if (Directory.Exists(downloadLocation))
{
    Console.WriteLine($"The Downloads location is '{downloadLocation}'");
}
else
{
    Console.WriteLine("Could not find Downloads location");
}
```

This will print something like this:

```plaintext
The Downloads location is '/Users/rad/Downloads'
```

### TLDR

**You can assume that the `Downloads` folder is always going to be `/Users/{username}/Downloads`**

The code is in my GitHub.

Happy hacking!
