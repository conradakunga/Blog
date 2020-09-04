---
layout: post
title: "Joining Strings - Part 4 : String.Format"
date: 2020-07-01 16:10:43 +0300
layout: post
categories:
  - .NET
  - Under The Hood
---
This is Part 4 in the series of **Joining stings**

* [Joining Strings - Part 1 : The + Operator]({% post_url 2020-05-28-joining-strings-part-1 %})
* [Joining Strings - Part 2 : String.Concat]({% post_url 2020-06-15-joining-strings-part-2 %})
* [Joining Strings - Part 3 : StringBuilder](% post_url 2020-06-22-joining-strings-part-3 %)
* Joining Strings - Part 4 : String.Format

The fourth way to join strings is using the [String.Format](https://docs.microsoft.com/en-us/dotnet/api/system.string.format?view=netcore-3.1) method.


At it's core, `String.Format` operates by inserting numbered placeholders into a string and its parameters as arguments to the call
