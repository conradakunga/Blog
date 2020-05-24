---
id: 69
title: Controlling Creation Of .NET Core Projects
date: 2020-03-25T14:24:00+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=69
permalink: /2020/03/25/controlling-creation-of-net-core-projects/
categories:
  - .NET
---
Many of us create .NET Core projects in the following way:

  1. Create a directory
  2. Enter said directory
  3. Invoke the `dotnet` new command

Like so:

![](images/2020/03/25-May-1.png)

If you list the contents you will find that the project name is the name of the directory

![](images/2020/03/25-May-2.png)

Often, you might not want this

  1. You may not want the project to use the name of the directory
  2. You may be creating multiple projects and it is tiresome to create directories and navigate into them just to create the project

There is a solution for this: the `–o` , or `–output` parameter

This allows you to specify the name of your project and where to put it

So we can create a second project from this directory

![](images/2020/03/25-Mar-3.png)

If we list the current directory we see our new directory created

![](images/2020/03/25-Mar-4.png)

And if we check the contents of that – our new project correctly named

![](images/2020/03/25-Mar-5.png)

It will save you a couple of seconds but life is short – those seconds add up!

Happy hacking!