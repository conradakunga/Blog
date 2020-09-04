---
title: "Joining Strings - Part 1 : The + Operator"
date: 2020-05-28T11:18:53+03:00
author: Conrad Akunga
layout: post
categories:
  - .NET
  - Under The Hood
---

This is Part 1 in the series of **Joining stings**

* Joining Strings - Part 1 : The + Operator
* [Joining Strings - Part 2 : String.Concat]({% post_url 2020-06-15-joining-strings-part-2 %})
* [Joining Strings - Part 3 : StringBuilder]({% post_url 2020-06-22-joining-strings-part-3 %})
* [Joining Strings - Part 4 : String.Format]({% post_url 2020-07-01-joining-strings-part-4 %})

In the course of writing a typical application, you will generally find the need to combine a string with one or more other strings.

The first, and most obvious way to do it is to concatenate the string using the `+` operator.

Remember that a string is immutable - you cannot modify a string once you have created it. Any operations that purport to modify the string in fact create a new string! This can be a performance bottleneck especially if you are manipulating a large number of strings.

Let us take this sample code:

```csharp
var firstName = "Homer";
var surname = "Simpson";
var fullName = firstName + " " + surname;
Console.WriteLine(fullName);
```

Let us use [SharpLab.io](https://sharplab.io/) to paste our code and view the compiler generated code.

This is pretty straightforward.

![](../images/2020/05/Concatenate1.png)

Now let us assume Homer had a few more names.

```csharp
var firstName = "Homer";
var surname = "Simpson";
var title = "His Excellency";
var initial = "J";
var fullName = title + " " + firstName + " " + initial + " " + surname;
Console.WriteLine(fullName);
```

If we paste the code in [SharpLab.io](https://sharplab.io/) we see a large difference.

![](../images/2020/05/Concatenate2.png)

Here the compiler has done a couple of things:

1. Determined that there are in fact 7 strings - the names and then the spaces we are concatenating between them.
2. Created an `array` of 7 string elements.
3. Copied each of the strings to an element of the array.
4. Called `string.Concat()`, passing the array; and then assigned the new string to a variable.

You might ask - at what point does the compiler decide not to use the + operator and switch to the `string.Concat()` method?

The magic number appears to be 4 strings. Anything more will result in the second behaviour.

In other words, the compiler works very hard to optimize what was originally poorly performant code.

The compiler also has some additional optimizations.

Take this code:

```csharp
var children = "Bart" + " " + "Lisa" + " " + "Maggie";
Console.WriteLine(children);
```

Running it through [SharpLab.io](https://sharplab.io/) yields this:

![](../images/2020/05/Concatenate3.png)

Here the compiler has realized that this code can be optimized at compile time and has gone ahead to strip away the concatenation code and merged the strings directly.

In the next installment we will look at `string.Concat()`

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/28%20May%20-%20Joining%20Strings%20-%20Part%201).

Happy hacking!