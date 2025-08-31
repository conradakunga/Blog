---
layout: post
title: Displaying Ordinal Words In C# & .NET
date: 2025-08-18 20:56:01 +0300
categories:
    - C#
    - .NET
    - StarLibrary
    - Humanizer
---

In the previous post, [Displaying Ordinal Numbers In C# & .NET]({% post_url 2025-08-17-displaying-ordinal-numbers-in-c-net %}), we discussed how to display [ordinal numbers](https://en.wikipedia.org/wiki/Ordinal_numeral).

These are numbers like 1<sup>st</sup>, 2<sup>nd</sup>, 3<sup>rd</sup>, 4<sup>th</sup>.

In today's post, we will look at a similar problem - how to display ordinal words.

> On the first day of Christmas ...
>
> On the second day of Christmas ...
>
> On the third day of Christmas ...
>
> On the fourth day of Christmas ...

**Ordinal words** here would refer to `first`, `second`, `third,` and `fourth`.

The solution to this is also the [Humanizer](https://github.com/Humanizr/Humanizer) library, specifically the `ToOrdinalWords()` method.

```c#
var numbers = Enumerable.Range(1, 12);
foreach (var number in numbers)
{
  Console.WriteLine($"On the {number.ToOrdinalWords()} of Christmas ...");
}
```

This will print the following:

```plaintext
On the first of Christmas ...
On the second of Christmas ...
On the third of Christmas ...
On the fourth of Christmas ...
On the fifth of Christmas ...
On the sixth of Christmas ...
On the seventh of Christmas ...
On the eighth of Christmas ...
On the ninth of Christmas ...
On the tenth of Christmas ...
On the eleventh of Christmas ...
On the twelfth of Christmas ...
```

### TLDR

**The `ToOrdinalWords()` extension in the Humanizer package allows for the display of ordinal words.**

Happy hacking!
