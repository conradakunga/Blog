---
layout: post
title: Enums & Enum Flags In C# & .NET For Dummies
date: 2025-02-20 23:00:16 +0300
categories:
    - C#
    - .NET
---

Suppose you were operating a burger shop. Initially, you just sold the burger - **bun** and **patty**. Then, as time progressed and you made more money, you began to improve your burger.

Initially you only offered tomato sauce.

If we were to model the toppings, we could do it like this:

```c#
public class Burger
{
    public bool TomatoSauce { get; set; }
}
```

Things progress even further and you offer something else:

```c#
public class Burger
{
    public bool TomatoSauce { get; set; }
    public bool Mayonnaise { get; set; }
}
```

You make still more improvements:

```c#
public class Burger
{
    public bool TomatoSauce { get; set; }
    public bool Mayonnaise { get; set; }
    public bool BarbecueSauce { get; set; }
    public bool Ketchup { get; set; }
}
```

At this juncture your class is starting to become unwieldy.

We could change it to use codes, like this:

```c#
public class Burger
{
    public int Condiment { get; set; }
}
```

We then give each condiment a code.

```c#
public static class CondimentCodes
{
    private const int TomatoSauce = 1;
    private const int Mayonnaise = 2;
    private const int BarbecueSauce = 3;
    private const int Ketchup = 4;
}
```

This allows us to specify a condiment like this:

```c#
var burger = new Burger
{
    Condiment = CondimentCodes.TomatoSauce
};
```

The problem becomes apparent when we output a burger to the console.

```c#
Console.WriteLine(burger.Condiment);
```

This will print the following:

```plaintext
1
```

We can solve this problem by using `strings` instead of `integer` codes.

```c#
public class Burger
{
    public string Condiment { get; set; } = "";
}

public static class CondimentCodes
{
    public const string TomatoSauce = nameof(TomatoSauce);
    public const string Mayonnaise = nameof(Mayonnaise);
    public const string BarbecueSauce = nameof(BarbecueSauce);
    public const string Ketchup = nameof(Ketchup);
}
```

We then write a small program:

```c#
var burger = new Burger
{
    Condiment = CondimentCodes.TomatoSauce
};

Console.WriteLine(burger.Condiment);
```

This prints the following:

```plaintext
TomatoSauce
```

Now, suppose a customer wants both ***Tomato Sauce*** and ***Mayonnaise***?

This technique quickly breaks down.

In addition, it has the following problems:

1. Difficult to **maintain**

2. Difficult to **read**

3. No **type safety**. Nothing stops you from doing the following:

    ```c#
    var burger = new Burger
    {
        Condiment = "They not like us!";
    };
    ```

You can solve this problem using an **enumeration**, an [Enum](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/enum).

An enum is a set of **named constants** backed by an underlying numeric type.

We define one as follows:

```c#
public enum Condiments
{
  TomatoSauce,
  Mayonnaise,
  BarbequeSauce,
  Ketchup
}
```

What happens here is that the compiler will generate numeric values for each specified value for you, starting at `0`.

In other words, behind the scenes, this takes place:

```c#
public enum Condiments
{
  TomatoSauce = 0,
  Mayonnaise = 1,
  BarbequeSauce = 2,
  Ketchup = 3,
}
```

You don't have to start from `0`. You can start from whatever value you want:

```c#
public enum Condiments
{
  TomatoSauce = 1000,
  Mayonnaise
  BarbequeSauce
  Ketchup
}
```

This is the same as:

```c#
public enum Condiments
{
  TomatoSauce = 1000,
  Mayonnaise = 1001,
  BarbequeSauce = 1002,
  Ketchup = 1003,
}
```

You can also specify the values in any order:

```c#
public enum Condiments
{
  TomatoSauce = 4,
  Mayonnaise = 3,
  BarbequeSauce = 2,
  Ketchup = 1,
}
```

And you can also skip values if you want:

```c#
public enum Condiments
{
  TomatoSauce = 10,
  Mayonnaise = 20,
  BarbequeSauce = 30,
  Ketchup = 40,
}
```

Having defined our enum, we then update our type as follows:

```c#
public class Burger
{
    public Condiments Condiment { get; set; }
}
```

Our updated program will now look like this:

```c#
var burger = new Burger
{
    Condiment = Condiments.TomatoSauce
};

Console.WriteLine(burger.Condiment);
```

Much easier to **read** and **maintain**.

It also has the additional benefit that it prints the following:

```plaintext
TomatoSauce
```

Returning to our problem - how do we specify **more than one condiment**?

We can use some boolean logic-[bit flags](https://developer.mozilla.org/en-US/docs/Glossary/Bitwise_flags) to address this.

We can redefine our enum as follows (note the values - they are all powers of `2`)

```c#
public enum Condiments
{
  TomatoSauce = 1,
  Mayonnaise = 2,
  BarbequeSauce = 4,
  Ketchup = 8,
}
```

You don't need to compute the values for yourself - you can achieve the same result using [bit shifting](https://www.interviewcake.com/concept/java/bit-shift).

```c#
public enum Condiments
{
  TomatoSauce = 1 << 0,
  Mayonnaise = 1 << 1,
  BarbequeSauce = 1 << 2,
  Ketchup = 1 << 3,
}
```

This technique is very convenient when the enums have many values.

To specify that a burger has **BOTH** ***tomato sauce*** and ***mayonnaise***, we do the following:

```c#
var burger = new Burger
{
    Condiment = Condiments.TomatoSauce | Condiments.Mayonnaise
};

Console.WriteLine(burger.Condiment);
```

If we print this, we get the following result:

```plaintext
3
```

What does `3` here mean?

Remember the definition of our `enum`:

```c#
public enum Condiments
{
  TomatoSauce = 1,
  Mayonnaise = 2,
  BarbequeSauce = 4,
  Ketchup = 8,
}
```

There is only one way to get `3` - by **combining** (adding) `1` (**TomatoSauce**) and 2 (**Mayonnaise**)

Isn't this the same problem we started with?

Not quite.

We can interrogate the `enum` to determine what its constituents are using the [HasFlag](https://learn.microsoft.com/en-us/dotnet/api/system.enum.hasflag?view=net-9.0) method.

```c#
if (burger.Condiment.HasFlag(Condiment.TomatoSauce))
    Console.WriteLine("This burger has tomato sauce");
else
    Console.WriteLine("This burger does not have tomato sauce");

if (burger.Condiment.HasFlag(Condiment.Mayonnaise))
    Console.WriteLine("This burger has mayonnaise");
else
    Console.WriteLine("This burger does not have mayonnaise");

if (burger.Condiment.HasFlag(Condiment.BarbequeSauce))
    Console.WriteLine("This burger has barbeque sauce");
else
    Console.WriteLine("This burger does not have barbeque sauce");

if (burger.Condiment.HasFlag(Condiment.Ketchup))
    Console.WriteLine("This burger has ketchup");
else
    Console.WriteLine("This burger does not have ketchup");
```

This will print the following:

```plaintext
This burger has tomato sauce
This burger has mayonnaise
This burger does not have barbeque sauce
This burger does not have ketchup
```

We can also introduce some flexibility.

***Ketchup*** and ***tomato sauce*** have **tomatoes** as constituents. Our ***barbecue sauce*** and ***mayonnaise*** have **egg**.

We can allow customers to specify whether they want all the egg condiments or all the tomato condiments.

We update our `enum` as follows:

```c#
public enum Condiments
{
  TomatoSauce = 1,
  Mayonnaise = 2,
  BarbequeSauce = 4,
  Ketchup = 8,
  EggCondiments = Mayonnaise | BarbequeSauce,
  TomatoCondiments = TomatoSauce | Ketchup,
}
```

Customers can now order a burger with tomato condiments as follows:

```c#
var burger = new Burger
{
    Condiment = Condiments.TomatoCondiments
};
```

If we re-run the interrogation code, we get the following result:

```plaintext
This burger has tomato sauce
This burger does not have mayonnaise
This burger does not have barbeque sauce
This burger has ketchup
```

We can even update our enum to allow specification of everything.

```c#
public enum Condiments
{
  TomatoSauce = 1,
  Mayonnaise = 2,
  BarbequeSauce = 4,
  Ketchup = 8,
  EggCondiments = Mayonnaise | BarbequeSauce,
  TomatoCondiments = TomatoSauce | Ketchup,
  Everything = EggCondiments | TomatoCondiments
}
```

We then update our program

```c#
var burger = new Burger
{
    Condiment = Condiments.Everything
};
```

If we re-run our logic check:

```plaintext
This burger has tomato sauce
This burger has mayonnaise
This burger has barbeque sauce
This burger has ketchup
```

What about a customer who doesn't want any condiments?

We can update our enum to capture this by adding an entry with a value of 0.

```c#
public enum Condiments
{
  None = 0,
  TomatoSauce = 1,
  Mayonnaise = 2,
  BarbequeSauce = 4,
  Ketchup = 8,
  EggCondiments = Mayonnaise | BarbequeSauce,
  TomatoCondiments = TomatoSauce | Ketchup,
  Everything = EggCondiments | TomatoCondiments
}
```

We can then update our program:

```c#
var burger = new Burger
{
    Condiment = Condiments.None
};
```

The logic checks will print the following:

```plaintext
This burger does not have tomato sauce
This burger does not have mayonnaise
This burger does not have barbeque sauce
This burger does not have ketchup
```

When using an enum in this fashion, it is a good habit to decorate the `enum` with the `[Flags]` attribute.

```c#
[Flags]
public enum Condiments
{
  None = 0,
  TomatoSauce = 1,
  Mayonnaise = 2,
  BarbequeSauce = 4,
  Ketchup = 8,
  EggCondiments = Mayonnaise | BarbequeSauce,
  TomatoCondiments = TomatoSauce | Ketchup,
  Everything = EggCondiments | TomatoCondiments
}
```

This signals to the reader the **intent** of the enum.

A couple of additional things:

1. Putting `[Flags]` on your enum **does not generate for you the values**! You must still define them yourself.

2. The compiler will allow you to shoot yourself in the foot by supplying duplicate values. This will happily compile:

    ```c#
    public enum Condiments
    {
    	TomatoSauce = 1,
    	Mayonnaise = 1,
    	BarbequeSauce = 1,
    	Ketchup = 1,
    }
    ```

3. You can directly assign **any integer value to a member expecting an `enum`**. However, it is trivial to validate the values before setting them.

    ```c#
    if (!Enum.IsDefined(typeof(Condiments), 1000))
    {
        Console.WriteLine("The value is invalid");
    }
    ```

### TLDR

**`Enums` allow for the design of fields and properties that can capture discrete or combined values into a single member of a type.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-20%20-%20Enums).

Happy hacking!
