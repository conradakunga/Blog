---
id: 31
title: Beware Of Controller Name Typos In ASP.NET Core Controllers
date: 2020-03-11T10:35:43+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=31
permalink: /2020/03/11/beware-of-controller-name-typos-in-asp-net-core-controllers/
categories:
  - 'C#'
tags:
  - ASP.NET Core
---
The other day I spent the better part of an hour trying to figure out why a particular controller action was not being hit by a request.

[<img width="599" height="440" title="Controller" style="display: inline; background-image: none;" alt="Controller" src="images/2020/03/Controller_thumb.png" border="0" />](images/2020/03/Controller.png)

The problem, I finally realized, was this

[<img width="599" height="440" title="Controller2" style="display: inline; background-image: none;" alt="Controller2" src="images/2020/03/Controller2_thumb.png" border="0" />](images/2020/03/Controller2.png)

Thanks to that typo the engine was unable to find the controller at all, let alone the action.

I wonder if there is any way to test for this, either at compile time or at runtime.