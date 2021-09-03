---
layout: post
title: Fix - .NET 6 Not Being Recognized After Install
date: 2021-09-03 19:27:09 +0300
categories:
    - .NET
---
After installing the .NET 6 SDK you can confirm that it was successfully installed and recognized by running the following command:

```bash
dotnet --info
```

You should get output like this:

![](../images/2021/09/DotNetInfo.png)

Here you can see I am running preview 7.

If you scroll down a bit you should see a list of the installed SDKs and runtimes.

![](../images/2021/09/SDKsRuntimes.png)

If the info command does not report the latest SDK that you have just installed, there are two possibilities:

1. There is a `global.json` file in the current folder, or a parent folder that is [fixing the .NET version](https://docs.microsoft.com/en-us/dotnet/core/tools/global-json?tabs=netcore3x)
2. You are using a 64 bit machine but you have installed the **x86** version of the SDK instead of the **x64**.

    ![](../images/2021/09/64Bit.png)

    If you install the **x86** version (as I had) on a 64 bit machine it will not be recognized
    
    ![](../images/2021/09/32Bit.png)
    
Happy hacking!