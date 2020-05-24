---
id: 53
title: 'Fun With Tuples In C# 7 &amp; Above'
date: 2020-03-21T16:38:59+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=53
permalink: /2020/03/21/fun-with-tuples-in-c-7-above/
categories:
  - 'C#'
---
Tuples, or to use their correct name, **ValueTuples**, were introduced in C#.

To cut a long story short tuples are a construct that break the convention that methods return a single value. (Void, by the way, is also considered one of these single value)

But what if you want to return more than one value? There are 3 techniques

  1. Create a class packaging your objects
  2. Use out parameters
  3. Return a tuple object (not a **ValueTuple**) but a special object with properties Item1, Item2, Item3 …

And now you can return an actual **ValueTuple**

So assuming we have a class like this:

[<img style="display: inline; background-image: none;" title="21 Mar 2019 - Tuple 1" src="images/2020/03/21-Mar-2019-Tuple-1_thumb.png" alt="21 Mar 2019 - Tuple 1" width="755" height="439" border="0" />](images/2020/03/21-Mar-2019-Tuple-1.png)

And we wanted to return only the make and the model in a method.

We could do it like this

[<img style="display: inline; background-image: none;" title="21 Mar 2019 - Tuple 2" src="images/2020/03/21-Mar-2019-Tuple-2_thumb.png" alt="21 Mar 2019 - Tuple 2" width="777" height="517" border="0" />](images/2020/03/21-Mar-2019-Tuple-2.png)

Which can then be used like this

[<img style="display: inline; background-image: none;" title="21 Mar 2019 - Tuple 3" src="images/2020/03/21-Mar-2019-Tuple-3_thumb.png" alt="21 Mar 2019 - Tuple 3" width="943" height="238" border="0" />](images/2020/03/21-Mar-2019-Tuple-3.png)

The details object being returned is a **ValueTuple**, with two strongly typed properties – Make and Model.

Essentially, two objects packaged in a tuple are being returned by the call to **_GetMakeAndModel_**()

You can make use of tuples as well in constructors.

Here again is the code for the Motorcycle

[<img style="display: inline; background-image: none;" title="21 Mar 2019 - Tuple 1" src="images/2020/03/21-Mar-2019-Tuple-1_thumb-1.png" alt="21 Mar 2019 - Tuple 1" width="755" height="439" border="0" />](images/2020/03/21-Mar-2019-Tuple-1-1.png)

Let’s create a new class for cars, and this time use tuples to construct the object.

[<img style="display: inline; background-image: none;" title="21 Mar 2019 - Tuple 4" src="images/2020/03/21-Mar-2019-Tuple-4_thumb.png" alt="21 Mar 2019 - Tuple 4" width="695" height="348" border="0" />](images/2020/03/21-Mar-2019-Tuple-4.png)

In our constructor we have made use of tuples by creating one with the four public properties in the class and simply copying the values once from the right (the parameters) to the left (the **_readonly_** properties). In this way we copy the parameters directly to the properties in one assignment rather than four different assignments. _(They are **readonly** properties because they have no **set**; but they can be written to by the constructor)_

You can access the full code from my [Github](https://github.com/conradakunga/BlogCode/tree/master/21%20March%202020%20-%20Tuples%20In%20Constructors)

Happy hacking!