---
layout: post
title: Generating and Using Directory.Packages.props file
date: 2025-06-13 21:29:58 +0300
categories:
    - C#
    - .NET
---

If you have solutions with more than one project within them, you should **absolutely** be using [centralized package management](https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management).

In the last post, we discussed how to generate and use a `Directory.Build.props` file.

In this post we will look at how to address the inevitable problem where one project references version **X** of a [NuGet](https://www.nuget.org/) package and **another** references version **Y**.

You achieve this with a file named `Directory.Packages.props`.

This is a XML file that you can create yourself.

But it is simpler to **generate** it using the command line tool:

```bash
dotnet new packagesprops
```

This will generate a new file, `Directory.Packages.props`, with the following contents:

```xml
<Project>
  <PropertyGroup>
    <!-- Enable central package management, https://learn.microsoft.com/en-us/nuget/consume-packages/Central-Package-Management -->
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>
  <ItemGroup>
  </ItemGroup>
</Project>
```

This will create the file that will be used to store **the packages and corresponding versions** used throughout the solution, as well as activating [central package management](https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management).

This will change the behavior of the .NET tooling when you add a package to a solution.

For example, if we wanted to add the package [AwesomeAssertions](https://www.nuget.org/packages/AwesomeAssertions), we would do it as follows:

```bash
dotnet add package AwesomeAssertions
```

**Without** [central package management](https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management), your `.csproj` file would look like this:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net9.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="AwesomeAssertions" Version="9.0.0" />
  </ItemGroup>
</Project>
```

With [central package management](https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management) enabled, the following will happen:

1. Your `Directory.Packages.props` file will change
2. Your `.csproj` will change.

The `Directory.Packages.props` file will be updated as follows:

```xml
<Project>
  <PropertyGroup>
    <!-- Enable central package management, https://learn.microsoft.com/en-us/nuget/consume-packages/Central-Package-Management -->
    <ManagePackageVersionsCentrally>true</ManagePackageVersionsCentrally>
  </PropertyGroup>
  <ItemGroup>
    <PackageVersion Include="AwesomeAssertions" Version="9.0.0" />
  </ItemGroup>
</Project>
```

Of interest here is that this file contains the **version** number of the package.

The `.csproj` will be updated as follows:

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <IsPackable>false</IsPackable>
  </PropertyGroup>

  <ItemGroup>
    <Using Include="Xunit" />
  </ItemGroup>

  <ItemGroup>
    <PackageReference Include="AwesomeAssertions" />
  </ItemGroup>
</Project>
```

Of interest here is that the project file does **not** contain the version number of the package.

You do not have to use the `dotnet` tool to update these files - you can do so manually **if you know what you are doing**.

### TLDR

**You can generate a `Directory.Packages.props` file using the `dotnet new packagesprops` command.**
