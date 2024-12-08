---
layout: post
title: Improved Collection Shuffling In F#
date: 2024-11-29 20:02:34 +0300
categories:
    - F#
---

Suppose you needed to shuffle the numbers 0 to 9 in [F#](https://fsharp.org), perhaps for a game or a data science exercise.

A simple way to do it would be as follows:

```fsharp
// We need this for the Random class
open System

// Generate a list of numbers
let numbers = [ 0 .. 9 ]

// Wite a function that shuffles a passed list and returns a new one
let shuffle list =
    list |> List.sortBy (fun _ -> Random.Shared.Next())

// Shuffle the numbers
let shuffledNumbers = shuffle numbers
printfn "Shuffled: %A" shuffledNumbers
```

If you run this code a couple of times, you should see the following

```plaintext
Shuffled: [3; 1; 0; 9; 2; 8; 6; 7; 4; 5]
Shuffled: [4; 5; 1; 7; 6; 0; 2; 3; 8; 9]
Shuffled: [0; 1; 2; 3; 4; 6; 5; 7; 9; 8]
Shuffled: [0; 1; 3; 2; 7; 4; 5; 6; 9; 8]
Shuffled: [1; 0; 2; 3; 5; 4; 7; 6; 8; 9]
```

There have been some improvements in F# that improves this.

Support for shuffling has directly been added to the various collections - `List`, `Seq` and `Array`

You can now rewrite the code like this:

```fsharp
let otherShuffledNumbers = numbers |> List.randomShuffle
printfn "Other Shuffled: %A" shuffledNumbers
```

To enjoy this goodness, you need to install the [FSharp.Core](https://www.nuget.org/packages/fsharp.core/) nuget package to your program

`Arrays` have the additional bonus that the original array can be mutated and shuffled in place

```fsharp
// Create the array
let numbersArray = [0 .. 9] |> List.toArray
printfn "Original Array: %A" numbersArray

// Shuffle in place
numbersArray |> Array.randomShuffleInPlace
printfn "Original Array: %A" numbersArray
```

This prints the following:

```plaintext
Original Array: [|0; 1; 2; 3; 4; 5; 6; 7; 8; 9|]
Original Array: [|5; 9; 3; 4; 1; 6; 0; 7; 2; 8|]
```

The code is in my [Github](https://github.com/conradakunga/BlogCode/blob/master/FSharpShuffling.fsx).

Happy hacking!