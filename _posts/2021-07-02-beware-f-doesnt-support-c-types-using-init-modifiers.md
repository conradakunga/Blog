---
layout: post
title: Beware - F# Doesn't Support C# Types Using Init Modifiers
date: 2021-07-02 12:44:46 +0300
categories:
    - F#
    - Interop
---
Our primary stack at [Innova](https://www.innova.co.ke) is .NET, that we principally historically implemented in [C#](https://docs.microsoft.com/en-us/dotnet/csharp/) (and some [Visual Basic.NET](https://docs.microsoft.com/en-us/dotnet/visual-basic/))

In some of our newest products and research, we have adopted [F#](https://fsharp.org/) as it very elegantly solves a number of problems that lend themselves well to a functional solution.

Code from either side is freely usable in the other, and we have not had any issues doing interop.

Until recently.

With some new work we're doing using .NET 5, I ran into this error:

![](../images/2021/07/InvalidProgram.png)

```plaintext
Error Message:
   System.InvalidProgramException : Common Language Runtime detected an invalid program.
```

This was from the F# side, when running some tests.

The (simplified) class itself, written in C#, was this:

```csharp
public class Lion
{
    public string Name { get; init; }
}
```

The test, written in F# was this:

```fsharp
[<Test>]
let ``Lion Is Created Correctly`` () =
    let simba = Lion(Name = "Simba")
    simba |> should not' (be null)
```

At first I thought the problem was with the interop itself. But this class behaved correctly

```csharp
public class Bear
{
    public string Name { get; set; }
}
```

The test is this:

```fsharp
[<Test>]
let ``Bear Is Created Correctly`` () =
    let yogi = Bear(Name = "Yogi")
    yogi |> should not' (be null)
```

This one run successfully.

This class, a [record](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record), also triggered the error.

```csharp
public record Tiger
{
    public string Name { get; init; }
}
```

What do the classes erroring out have in common? The `init` keyword.

The `init` keyword allows you to set a property only once, upon [initialization](https://www.thomasclaudiushuber.com/2020/08/25/c-9-0-init-only-properties/) of the class. It becomes read-only after that.

It turns out the root of the problem is the C# and F# teams had not aligned around the implementation of the `init` keyword. You can read more about the problem [here](https://github.com/fsharp/fslang-suggestions/issues/904).

The bottom line is that this can only be fixed with a change to the compiler.

To solve this problem in the interim, I rewrote the classes to have `readonly` public properties and set them in a constructor.

```csharp
public class Snake
{
    public string Name { get; }
    public Snake(string name) => Name = name;
}
```

The test in F# passes successfully.

```fsharp
[<Test>]
let ``Snake Is Created Correctly`` () =
    let steven = Snake(name = "Steven")
    steven |> should not' (be null)
```

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-07-02%20-%20FSharp%20Interop).

Happy hacking!