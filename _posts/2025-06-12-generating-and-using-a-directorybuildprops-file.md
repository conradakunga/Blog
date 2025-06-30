---
layout: post
title: Generating and Using a Directory.Build.props file
date: 2025-06-12 14:38:43 +0300
categories:
    - C#
    - .NET
---

If you have solutions with more than one project within them, you should **absolutely** be using [centralized package management](https://learn.microsoft.com/en-us/nuget/consume-packages/central-package-management).

This will help you avoid the inevitable problem where one project references version **X** of a [NuGet](https://www.nuget.org/) package and another references version **Y**.

It also helps with the problem where one project is a **.NET 9** project and the other is a .**NET 10 project**.

To solve the latter problem, you will need a file named `Directory.Build.props` in the root of your solution.

This is an XML file that you can create **manually**.

From .NET 8, you can **generate** it as follows:

```bash
dotnet new dotnet new buildprops
```

This will generate a file with the following contents:

```xml
<Project>
  <!-- See https://aka.ms/dotnet/msbuild/customize for more details on customizing your build -->
  <PropertyGroup>


  </PropertyGroup>
</Project>
```

You can customize it as follows:

```xml
<Project>
  <PropertyGroup>
    <Authors>Conrad Akunga,James Bond</Authors>
    <Description>Product Description</Description>
    <Company>Your Company Name Here</Company>
    <LangVersion>14.0</LangVersion>
    <TreatWarningsAsErrors>True</TreatWarningsAsErrors>
    <ImplicitUsings>true</ImplicitUsings>
    <Nullable>enable</Nullable>
    <NoWarn>CS8981;NU1902;NU1903;NU1904;S101;CA1822;S2325;S125</NoWarn>
    <TargetFramework>net9.0</TargetFramework>
  </PropertyGroup>
</Project>
```

There are a couple of key tags specified here:

#### Authors

If an **individual** project, a list of the authors involved. For a **company** project, it is probably simpler to specify the **company** name there.

#### Description

The description of the project

#### Company

Your company name, if any. Or your name if an individual

#### LangVersion

The applicable C# version. You can get a listing [here](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/configure-language-version). It is probably best to specify an actual version rather than `latest` or `preview`.

#### TreatWarningsAsErrors

Discourages **bad behaviour from developers**. By default, warnings do not stop compilation. This tag forces the compiler to return compiler errors even for warnings.  The bad behavior is that the developer will typically make a mental note to resolve the problem. **Then they never do.**

#### ImplicitUsings

Whether or not to enable [ImplicitUsings](https://medium.com/@KeyurRamoliya/c-implicit-usings-0c3bfd730922) for projects

#### Nullable

Whether or not to allow support for [nullable reference types](https://learn.microsoft.com/en-us/dotnet/csharp/tutorials/nullable-reference-types).

#### NoWarn

Used in conjunction with the `TreatWarningsAsErrors` setting. There are occasional warnings that you do not want treated as errors. Provide the error codes as a semicolon-delimited list.

#### TargetFramework

The [target .NET framework](https://versionsof.net/). This is different from `LangVersion` because the `TargetFramework` and `LangVersion` evolve independently. However, you need to research carefully if the language you want to use has corresponding support in the target framework.

### TLDR

**You can generate a `Directory.Build.props` file using the `dotnet new buildprops` command.**

Happy hacking!
