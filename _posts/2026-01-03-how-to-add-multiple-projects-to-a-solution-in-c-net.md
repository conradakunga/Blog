---
layout: post
title: How To Add Multiple Projects To A Solution In C# & .NET
date: 2026-01-03 19:37:54 +0300
categories:
    - C#
    - .NET
---

The [.NET CLI](https://learn.microsoft.com/en-us/dotnet/core/tools/), you might be surprised to learn, is so **fully featured** and **flexible** that I find it orders of magnitude **faster to use than an IDE** for creating, manipulating, and setting up .NET projects and solutions.

Suppose we want to set up a project as follows:

![projectSetup](../images/2026/01/projectSetup.png)

The first order of business is to create a **directory** to hold the **solution** and **project** files.

```bash
mkdir CancellableTests
```

This will create an **empty directory**, which we immediately switch to.

```bash
cd CancellableTests
```

![newDirectory](../images/2026/01/newDirectory.png)

From here, we create a [class library](https://learn.microsoft.com/en-us/dotnet/standard/class-libraries) project to store our logic.

```bash
dotnet new classlib -o Logic
```

![addLogic](../images/2026/01/addLogic.png)

We then want a [xUnit3](https://xunit.net/docs/getting-started/v3/whats-new) test project. Note that this is [xUnit](https://xunit.net/) version `3`, which is an overhaul of version `2`.

```bash
dotnet new xunit3 -o Tests
```

![addtests](../images/2026/01/addtests.png)

If you get an error about missing templates, install them as follows:

```bash
dotnet new install xunit.v3.templates::3.2.2
```

Next, we create a **blank solution**.

```bash
dotnet new sln
```

![newSolution](../images/2026/01/newSolution.png)

To reduce **noise** when it comes to source control, we typically want a `.gitignore` in the root directory.

```bash
dotnet new gitignore
```

![newGitignore](../images/2026/01/newGitignore.png)

The directory structure should look like this:

![cancelFileSystem](../images/2026/01/cancelFileSystem.png)

Finally, we **add our projects** to our solution.

Typically, you'd do it like this:

```bash
dotnet sln add Logic/
```

And then immediately:

```bash
dotnet sln add Tests/
```

You can do this in  a **single command**:

```bash
dotnet sln add Logic/ Tests/
```

![slnAddMultiple](../images/2026/01/slnAddMultiple.png)

You can verify all is well by **listing the projects** in the solution.

```bash
dotnet sln list
```

![cancelSolutionList](../images/2026/01/cancelSolutionList.png)

This, undoubtedly, will also work for [F#](https://fsharp.org/) and [VB.NET](https://learn.microsoft.com/en-us/dotnet/visual-basic/) projects.

### TLDR

**You can add multiple projects to a solution in a single command.**

Happy hacking!
