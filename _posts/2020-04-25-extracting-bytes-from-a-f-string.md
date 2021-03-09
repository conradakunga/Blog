---
id: 249
title: 'Extracting Bytes From A F# String'
date: 2020-04-25T05:10:52+03:00
author: Conrad Akunga
layout: post
categories:
  - 'F#'
  - Tips
---
Suppose you need to extract the byte values of a string in F#

An obvious way is to use the `Encoding` class from `System.Text`

Like so:
```fsharp
open System.Text

let bytes = Encoding.Default.GetBytes("This Is My String")

printfn "%A" bytes
```

An even quicker way to to it natively is as follows:

```fsharp
printfn "%A" "This Is My String"B
```

Note the **B** at the end

![](../images/2020/04/Bytes-2.png)

The code is in my [github](https://github.com/conradakunga/BlogCode/tree/master/2020-04-25%20-%20F%23%20Bytes)


Happy hacking!