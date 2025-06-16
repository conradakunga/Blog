---
layout: post
title: Don't Parse - TryParse
date: 2025-06-15 20:26:47 +0300
categories:
    - C#
    - .NET
---

When working with data, you will inevitably need to **convert** data from one **type** to another.

For example, suppose you are building a calculator and you want to capture input from the user. You would typically do it as follows:

```c#
Console.WriteLine("Enter first number:");
var firstInput = Console.ReadLine();
Console.WriteLine("Enter second number:");
var secondInput = Console.ReadLine();

var first = int.Parse(firstInput);
var second = int.Parse(secondInput);

Console.WriteLine($"The result is: {first + second}");
```

The trouble with this code is that it **assumes that the user will enter a valid number**.

**This is not a valid assumption to make!**

You need to be proactive and catch the inevitable [exception](https://learn.microsoft.com/en-us/dotnet/api/system.exception?view=net-9.0) that may arise.

```c#
Console.WriteLine("Enter first number:");
var firstInput = Console.ReadLine();
Console.WriteLine("Enter second number:");
var secondInput = Console.ReadLine();

int first, second;
try
{
    first = int.Parse(firstInput);
}
catch (Exception e)
{
    Console.WriteLine("Invalid first number");
    return;
}

try
{
    second = int.Parse(secondInput);
}
catch (Exception e)
{
    Console.WriteLine("Invalid second number");
    return; 
}

Console.WriteLine($"The result is: {first + second}");
```

Better.

An even better technique is to take advantage of the fact that parsing inputs is an exercise that is very **likely** to have invalid inputs, and using `Exceptions` to manage control flow is [expensive](https://www.youtube.com/watch?v=2f2elFRmeLE).

Most conversion methods have a `TryParse` method designed for this purpose.

We can rewrite our code as follows:

```c#
int first, second;
Console.WriteLine("Enter first number:");
while (!int.TryParse(Console.ReadLine(), out first)) ;
Console.WriteLine("Enter second number:");
while (!int.TryParse(Console.ReadLine(), out second)) ;

Console.WriteLine($"The result is: {first + second}");
```

The magic is taking place here:

```c#
int.TryParse(Console.ReadLine(), out first)
```

This method attempts to **parse** the input and store it in the `out` variable `first`. If it **succeeds**, it will do just that and return `true`,

If it **fails**, it will return `false`.

You can check this return value to determine what happened.

We are taking advantage of this to write a loop, where we will only proceed if a valid number is keyed in.

```c#
while (!int.TryParse(Console.ReadLine(), out first)) ;
```

If we run this and enter some input, we get the following results:

```plaintext
Enter first number:
monkey
sdf
60
Enter second number:
uu
jjj
jj
70
The result is: 130
```

Most key data types have such a method:

- `Decimal` - [Decimal.TryParse](https://learn.microsoft.com/en-us/dotnet/api/system.decimal.tryparse?view=net-9.0)
- `Boolean` - [Boolean.TryParse](https://learn.microsoft.com/en-us/dotnet/api/system.boolean.tryparse?view=net-9.0)
- `Single` - [Single.TryParse](https://learn.microsoft.com/en-us/dotnet/api/system.single.tryparse?view=net-9.0)
- `Double` - [Double.TryParse](https://learn.microsoft.com/en-us/dotnet/api/system.double.tryparse?view=net-9.0)
- `DateTime` - [DateTime.TryParse](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.tryparse?view=net-9.0)

### TLDR

**Most types have a `TryParse` method that you can use to attempt conversion and verify success or otherwise before proceeding with your logic.**

The code is in my GitHub.

Happy hacking!
