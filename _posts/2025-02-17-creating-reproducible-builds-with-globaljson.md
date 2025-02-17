---
layout: post
title: Creating Reproducible Builds With global.json
date: 2025-02-17 07:33:52 +0300
categories:
    - .NET
---

When working independently, it is pretty easy to **avoid surprises** when you build your code. After all, your environment is the only environment. If you want to change the .NET version you are targeting, you can make that change in the relevant **project file**.

For example, if I have this .csproj file:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Newtonsoft.Json" />
  </ItemGroup>

</Project>
```

If I want to upgrade it to version **9**, I just need to update the `TargetFramework` tag as follows:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <TargetFramework>net9.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Newtonsoft.Json" />
  </ItemGroup>

</Project>
```

If I want to upgrade the version of the SDK from **8.0.309** to **8.0.406**, all I need to do is [download and install the appropriate SDK](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) I am interested in.

Now, if **two or more** of us are working on this project, **challenges** arise.

If I have version **8** of the SDK installed and pull the latest version of the code with the `TargetFramework` specifying version 9 but do not have that version installed, the application will refuse to compile. Therefore, I have two options: download and install version 9 or change the project to 8.

Very subtle problems and bugs can slip in when the project targets a particular version, say version 8, but **two different developers have different versions of the version 8 SDK** installed.

In this situation, the program will probably actually **build successfully,** but with **different SDKs** we get a **different binary**. This could present a major problem because changes between versions of the SDK usually involve bug fixes and **behavior changes**.

This means that both developers are **compiling and running different applications**, which can lead to odd scenarios such as **tests that pass on one machine may fail in others**.

The other problem is that you might want to **rebuild an older version of the application with an older version of the SDK**.

This problem can be solved by introducing a file called `global.json` at the root folder of your project or solution.

This file is a plain `json` file looks like this:

```json
{
  "sdk": {
    "version": "9.0.200",
    "rollForward": "latestPatch",
    "allowPrerelease": false
  }
}
```

You can create one manually, or use the `dotnet` command line to generate one.

The command is as follows:

```bash
dotnet new globaljson
```

You can also use

```bash
dotnet new global.json
```

There are 3 properties here:

### version

This is the version of the SDK you want to build with. 

If you generate a new one, it will be pre-populated with the latest version of the SDK.

If you want to find out the versions of the SDK installed, run the following command:

```bash
dotnet --list-sdks
```

This will print the following (this will be different on your machine!)

```plaintext
8.0.406 [/usr/local/share/dotnet/sdk]
9.0.200 [/usr/local/share/dotnet/sdk]
```

### rollForward

This takes effect if the compiler finds that the SDK version installed is **NEWER** than the one specified in the `global.json`. You can specify what to do in this case from the following options:

| Attribute     | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| disable       | The SDK version must match with the **version** specified. It will not compile otherwise. |
| latestMajor   | The compiler will use the **latest major version** that it finds, which is newer than the specified version. So, in the example above, if version **10.0.100** of the SDK is installed on your computer, that will be used. If later, **10.0.200** is installed, that will be used instead. If **11.0.100** is installed, it will be used in the next compile. |
| latestMinor   | The compiler will use the **latest minor version**. So if you install **9.1.100** that will be used. The same for **9.2.100**. But not **10.0.100**. |
| latestFeature | The compiler will use the **latest feature version**. So if you install **9.0.300**, that will be used. The same for **9.0.999**. But not for **9.1.100** |
| latestPatch   | The compiler will use the **latest patch version**. So if you install **9.0.201**, that will be used. So will **9.0.202**. All the way to **9.0.299**. Version **9.0.300**, however, will not be used. |

### allowPrerelease

This controls whether you want to allow pre-release SDK versions to be used.

With this file in the **root** of your solution/project, you can control exactly which version of the SDK is used to compile your code. This solves many problems when working in a team on the same project.

This file is also useful if you need to **retrieve the code for an old version** and **rebuild** it with the corresponding SDK version.

It is also useful if you have **multiple projects, each targeting a different SDK** on your machine, and you want to be able to work on all of them.

### TLDR

**The `global.json` file lets you control which SDK is used to build your code.**

Happy hacking!

