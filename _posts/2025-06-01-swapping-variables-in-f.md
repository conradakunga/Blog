---
layout: post
title: Swapping Variables in F#
date: 2025-06-01 15:34:32 +0300
categories:
    - F#
    - .NET
---

In the previous post, [Swapping Variables In C# With ValueTuples]({% post_url 2025-05-31-swapping-variables-in-c-with-valuetuples %}), we saw how to swap variables in C#.

F# has some considerations when it comes to this problem, the most significant one being that values are [immutable by default](https://www.compositional-it.com/news-blog/immutable-data-structures-in-f/).

The traditional solution using a **temporary value** would look like this:

```F#
let mutable a = 10
let mutable b = 30

let temp = a
a <- b
b <- temp

printfn "a = %d, b = %d" a b
```

Note our values, `a` and b, are **mutable** here.

The solution using a [tuple](https://fsharpforfunandprofit.com/posts/tuples/) also works:

```F#
let mutable a = 10
let mutable b = 30

a, b <- b, a

printfn "a = %d, b = %d" a b
```

### TLDR

**F# also allows the use of tuples to swap values.**

Happy hacking!
