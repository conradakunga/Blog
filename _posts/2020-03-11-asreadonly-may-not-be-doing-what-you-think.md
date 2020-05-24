---
id: 35
title: AsReadOnly() May Not Be Doing What You Think!
date: 2020-03-11T20:13:03+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=35
permalink: /2020/03/11/asreadonly-may-not-be-doing-what-you-think/
categories:
  - 'C#'
---
You have probably come across the **AsReadOnly()** extension method, and have probably made liberal use of it.

However there is a slight gotcha that may surprise you.

The documentation says as follows

> Returns a read-only [ReadOnlyCollection<T>](https://docs.microsoft.com/en-us/dotnet/api/system.collections.objectmodel.readonlycollection-1?view=netframework-4.8) wrapper for the current collection.

The devil is in the details!

Take this code:

<div class="gist-oembed" data-gist="f9677549efa980300d990125866e0e2a.json" data-ts="8">
</div>

You might be surprised to note that it prints the following

![](images/2020/03/image.png)


Yes. Changing the original list **changes the ReadOnlyCollection as well**!

Calling **AsReadOnly()** returns a wrapper to the original list. Changes to the original list will manifest in the read only collection.

This might not be a problem when crossing application boundaries (say using JSON) but it may provide some surprises if the read only collection and the original list co-exist, perhaps internally in a class.

So how do we tackle the problem of returning a collection that you do not intend to be modified?

We can look at solutions next time.