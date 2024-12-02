---
layout: post
title: Choosing From A Collection In F#
date: 2024-12-01 20:58:15 +0300
categories:
    - F#
---

Suppose you were writing a program to simulate the throwing of two dice. The minimum result you can have is 2 `1 + 1` and the maximum result you can have is 12 `6 + 6`.

The following code is how you'd typically do this:

```fsharp
// We need this for the Random type
open System

// Generate a list of the results
let diceResults = [2..12]

// Write a functon to return a random entry
let tossDice list = 
  let index = Random.Shared.Next(0, List.length list)
  list.[index]

// Execute and store the result
let result = tossDice diceResults

// Print the result
printfn "Dice result: %i" result
```

In F#, this can be simplified even further with the addition of [randomChoice](https://fsharp.github.io/fsharp-core-docs/reference/fsharp-collections-listmodule.html#randomChoice) to `Lists`, as well as `Sequences` and `Arrays` as part of the [FSharp.Core](https://fsharp.github.io/fsharp-core-docs/) package.

The code can be simplified as follows:

```fsharp
// Generate a list of the results
let diceResults = [2..12]

// Execute and store the result
let result = List.randomChoice diceResults

// Print the result
printfn "Dice result: %i" result
```

Happy hacking!
