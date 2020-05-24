---
id: 81
title: Pinning Nuget Package Versions
date: 2020-03-28T11:20:17+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=81
permalink: /2020/03/28/pinning-nuget-package-versions/
categories:
  - Nuget
---
The [Nuget](https://www.nuget.org/) package management system has been a godsend when it comes to managing libraries and dependencies in your projects.

One of its benefits is that it can detect outdated versions of a library you have in use and prompt you to upgrade it.

Take this example where I am making use of the excellent [Gembox.Spreadsheet](https://www.gemboxsoftware.com/spreadsheet)

![](images/2020/03/28-Mar-1.png)

I can see that there is an update available.

![](images/2020/03/28-Mar-2.png)

Clearly I am several versions behind, and all I need to do is click **update** and the latest version will be downloaded and installed.

But what if I **do not** want this?

Maybe

  * There is a breaking change in their API that it am unable or unwilling to back-port
  * We have decided as an organization on a standard version
  * The new version requires a new, or a different license

So, for whatever reason, you don’t want to upgrade. Ordinarily you don’t have to do anything.

But Nuget will keep informing you that you have an update. And you may inadvertently update this library while doing an ‘update all’.

Alternatively, you may be working in a team and your colleagues may not know you want to retain this particular version.

There is, luckily, a solution for this.

Open the `packages.config`. It should look like this:

![](images/2020/03/28-Mar-3.png)

Add the attribute **“allowedVersions”** and specify the version you want to enforce. Note the square brackets! These are important.

![](images/2020/03/28-Mar-4.png)

If we go back to the package manager note that it no longer shows that there is an update.

![](images/2020/03/28-Mar-5.png)

You can read more about package pinning (including specifying minimum and maximum versions) from the [Microsoft Nuget reference](https://docs.microsoft.com/en-us/nuget/concepts/package-versioning)

Happy hacking!