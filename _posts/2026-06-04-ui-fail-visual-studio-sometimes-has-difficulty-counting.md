---
layout: post
title: UI Fail - Visual Studio Sometimes Has Difficulty Counting
date: 2026-06-04 18:55:22 +0300
categories:
    - UI Fail
    - Fail
    - SQL Server
    - Visual Studio
---

Quick, what's **wrong** with this?

![VisualStudioCount](../images/2026/06/VisualStudioCount.png)

This is the [Visual Studio](https://visualstudio.microsoft.com/) [Nuget](https://nuget.org) [package manager](https://en.wikipedia.org/wiki/Package_manager), that shows you which Nuget packages have updates.

In case you haven't noticed, this is the problem:

![VisualStudioCount2](../images/2026/06/VisualStudioCount2.png)

The **count** of updated **Nuget** packages is **not congruent** with their actual display.

Having been a software developer for a very long time, my first instinct when I see things like these is to empathize with my fellows, because [writing software is hard]({% post_url 2022-01-17-coding-is-easy-any-monkey-can-do-it-software-is-very-hard %}).

There are a number of possible **explanations** for this:

1. The **count** of updates may be fetched separately** from the list, so a change may have happened as both calls were running
2. The **list** of packages requires **fetching of additional informatio**n - version number, icon, description, etc. Perhaps one of them **timed out**
3. There is a **threading issue** in the code that renders the list of packages, and it is behind the code that renders the count
4. An edge case bug, as I have never notices this problem before

Who knows?

Happy hacking!
