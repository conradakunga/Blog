---
layout: post
title: Random Sampling In F#
date: 2024-12-02 22:55:49 +0300
categories:
    - F#
---

Suppose you need to write a program to randomly sample a number of items from a list of numbers from `0-99`

The algorithm to do this would look something like this:

1. Sort the numbers by a random order into a new collection
2. Since this collection is sorted randomly, we can pick the first `count` elements as our result

The code would be as follows:

```fsharp
// We need this for the Random class
open System

// Generate a list of numbers
let numbers = [0 .. 99]

// The required items to fetch
let requiredCount = 5

// Function to sort items randomly and select the first count items
let randomSample count list =
    list 
        |> List.sortBy (fun _ -> Random.Shared.Next()) 
        |> List.truncate count

// Generate and store result
let result = randomSample requiredCount numbers

// Print result
printfn "Sample of %i items : %A" requiredCount result
```

This sould print something like this:

```plaintext
Sample of 5 items : [48; 2; 67; 91; 20]
```

Thanks ot the [FSharp.Core](https://www.nuget.org/packages/fsharp.core/) library, this code can be simplified even further by using the [randomSample](https://fsharp.github.io/fsharp-core-docs/reference/fsharp-collections-listmodule.html#randomSample) method from the available collections - `List`, `Seq` and `Array`

The newer code would look like this:

```fsharp
// We need this for the Random class
open System

// Generate a list of numbers
let numbers = [0 .. 99]

// The number of items to fetch
let requiredCount = 5

// Function to sort items randomly and select the first count items
let randomSample count list =
    list |> List.randomSample count

// Generate and store result
let result = randomSample requiredCount numbers

// Print result
printfn "Sample of %i items : %A" requiredCount result
```

This should print someting like this:

```plaintext
Sample of 5 items : [54; 15; 82; 43; 57]
```
We could of course eliminate the function altogether and directly sample like so:

```fsharp
// Generate and store result
let result = numbers |> List.randomSample requiredCount
```

But it can be argued having the logic in a separate function is more maintainable given we can always change the sampling algorithm later without modifying the main body of the code.

I tend to lean more towards clarity over brevity (and cleverness!)

Happy hacking!