---
id: 31
title: Beware Of Controller Name Typos In ASP.NET Core Controllers
date: 2020-03-11T10:35:43+03:00
author: Conrad Akunga
layout: post
categories:
  - ASP.NET Core
---
The other day I spent the better part of an hour trying to figure out why a particular controller action was not being hit by a request.

![](../images/2020/03/Controller.png)

The problem, I finally realized, was this

![](../images/2020/03/Controller2.png)

Thanks to that typo the engine was unable to find the controller at all, let alone the action.

I wonder if there is any way to test for this, either at compile time or at runtime.