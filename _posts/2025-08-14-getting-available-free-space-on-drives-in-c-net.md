---
layout: post
title: Getting Available Free Space On Drives In C# & .NET
date: 2025-08-14 11:39:30 +0300
categories:
    - C#
    - .NET
---

If you need to find out **how much disk space is available** on a particular drive, the place to look is in the [DriveInfo](https://learn.microsoft.com/en-us/dotnet/api/system.io.driveinfo?view=net-9.0) class.

You can write code like this to tell you what you need to know:

```c#
void Main()
{
  // Get all the drives in the system
  var allDrives = DriveInfo.GetDrives();

  foreach (var drive in allDrives)
  {
    // Output name
    Console.WriteLine("Drive {0}", drive.Name);
    // Output drive type
    Console.WriteLine("\tType: {0}", drive.DriveType);
    // Check if drive is ready (to cater for removeable drives)
    if (drive.IsReady)
    {
      // Output label
      Console.WriteLine("\tLabel: {0}", drive.VolumeLabel);
      // Output format
      Console.WriteLine("\tFile System: {0}", drive.DriveFormat);
      // Output free space
      Console.WriteLine("\tAvailable Space: \t\t{0:#,0} bytes", drive.AvailableFreeSpace);
      // Output total size
      Console.WriteLine("\tTotal Size :\t\t\t{0:#,0} bytes ", drive.TotalSize);
    }
  }
}
```

The property to check here is [AvailabeFreeSpace](https://learn.microsoft.com/en-us/dotnet/api/system.io.driveinfo.availablefreespace?view=net-9.0)

On my machine, MacBook Pro running macOS 14, it returns the following:

```plaintext
Drive /
    Type: Fixed
    Label: /
    File System: apfs
    Available Space:         76,199,739,392 bytes
    Total Size :            994,662,584,320 bytes 
Drive /dev
    Type: Ram
    Label: /dev
    File System: devfs
    Available Space:         0 bytes
    Total Size :            204,288 bytes 
Drive /System/Volumes/VM
    Type: Fixed
    Label: /System/Volumes/VM
    File System: apfs
    Available Space:         76,199,739,392 bytes
    Total Size :            994,662,584,320 bytes 
Drive /System/Volumes/Preboot
    Type: Fixed
    Label: /System/Volumes/Preboot
    File System: apfs
    Available Space:         76,199,739,392 bytes
    Total Size :            994,662,584,320 bytes 
Drive /System/Volumes/Update
    Type: Fixed
    Label: /System/Volumes/Update
    File System: apfs
    Available Space:         76,199,739,392 bytes
    Total Size :            994,662,584,320 bytes 
Drive /System/Volumes/xarts
    Type: Fixed
    Label: /System/Volumes/xarts
    File System: apfs
    Available Space:         504,692,736 bytes
    Total Size :            524,288,000 bytes 
Drive /System/Volumes/iSCPreboot
    Type: Fixed
    Label: /System/Volumes/iSCPreboot
    File System: apfs
    Available Space:         504,692,736 bytes
    Total Size :            524,288,000 bytes 
Drive /System/Volumes/Hardware
    Type: Fixed
    Label: /System/Volumes/Hardware
    File System: apfs
    Available Space:         504,692,736 bytes
    Total Size :            524,288,000 bytes 
Drive /System/Volumes/Data
    Type: Fixed
    Label: /System/Volumes/Data
    File System: apfs
    Available Space:         76,199,739,392 bytes
    Total Size :            994,662,584,320 bytes 
Drive /System/Volumes/Data/home
    Type: Network
    Label: /System/Volumes/Data/home
    File System: autofs
    Available Space:         0 bytes
    Total Size :            0 bytes 
Drive /private/var/folders/q8/cdslzt2s6p1djnhp_y3ksc280000gn/X/4E6D7E7B-0CA5-51C6-96B7-5184E139C6F7
    Type: Unknown
    Label: /private/var/folders/q8/cdslzt2s6p1djnhp_y3ksc280000gn/X/4E6D7E7B-0CA5-51C6-96B7-5184E139C6F7
    File System: nullfs
    Available Space:         77,716,463,616 bytes
    Total Size :            994,662,584,320 bytes 
Drive /Users/rad/OrbStack
    Type: Network
    Label: /Users/rad/OrbStack
    File System: nfs
    Available Space:         72,555,085,824 bytes
    Total Size :            104,875,864,064 bytes 
Drive /Users/rad/Library/Parallels/Windows Disks/{bb803e4d-ca2b-4ce2-a092-47b37b09cef6}/[C] Windows 11.hidden
    Type: Network
    Label: /Users/rad/Library/Parallels/Windows Disks/{bb803e4d-ca2b-4ce2-a092-47b37b09cef6}/[C] Windows 11.hidden
    File System: smbfs
    Available Space:         75,699,970,048 bytes
    Total Size :            273,435,062,272 bytes 
```

A couple of things of interest:

- The concept of a **Drive** goes beyond just physical disks
- The [DriveTypes](https://learn.microsoft.com/en-us/dotnet/api/system.io.driveinfo.drivetype?view=net-9.0) map to [one of the following](https://learn.microsoft.com/en-us/dotnet/api/system.io.drivetype?view=net-9.0)
- You should **check if the drive is ready** before attempting to access it - some drives, such as removable drives might throw exceptions if you try to access them before they are ready.

Note that if you run this code repeatedly your **results about free space might change depending on what else the operating system is doing**.

### TLDR

**Use the `AvailableFreeSpace` property of the `DriveInfo` object to determine the available free space on your machine.**

Happy hacking!
