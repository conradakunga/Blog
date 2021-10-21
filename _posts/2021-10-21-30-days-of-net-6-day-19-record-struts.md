---
layout: post
title: 30 Days Of .NET 6 - Day 19 - Record Struts
date: 2021-10-21 10:03:40 +0300
categories:
    - .NET
    - C#
---
Today's item record struts, is a bit more elaborate to explain, but I shall do my best.

If you want to combine multiple types into a more complex type there are several ways to do this in .NET:

### Classes

This is the most common way - you declare and name a `class` and go on to declare its constituent types.

```csharp
public class Animal
{
    public string Name { get; set; }
    public byte Legs { get; set; }
}
```

Here we have declared an Animal class with two public properties that can be changed.

### Structs

A `struct` is syntactically almost identical to a `class`.

```csharp
public struct Animal
{
    public string Name { get; set; }
    public byte Legs { get; set; }
}
```

Which begs the question what is the difference between a `class` and a `struct`?

There are a whole bunch of differences but the main ones are these:

First: A `struct` is a **value** type. This essentially means if you assign an instance of a `struct` to a variable, all the properties of the `struct` are copied to this new variable. This means if you change the original `struct`, the new one is unaffected.

This is unlike a `class`, which is a **reference** type. This means if you copy an instance of a `class` to a variable, what is actually copied is a pointer/reference to the original `class`, so if you modify either, **changes will reflect on both**.

This is best explained with some code:

Here we create one class, assign it to a variable, print some properties, and then modify the original. We then print the properties again.

```csharp
var firstClass = new AnimalClass() { Name = "Dog", Legs = 4 };
var secondClass = firstClass;

Console.WriteLine($"First class name is {firstClass.Name} and legs is {firstClass.Legs}");
Console.WriteLine($"Second class name is {secondClass.Name} and legs is {secondClass.Legs}");

firstClass.Name = "Cat";

Console.WriteLine($"First class name is {firstClass.Name} and legs is {firstClass.Legs}");
Console.WriteLine($"Second class name is {secondClass.Name} and legs is {secondClass.Legs}");
```

The results look like this:

```plaintext
First class name is Dog and legs is 4
Second class name is Dog and legs is 4
First class name is Cat and legs is 4
Second class name is Cat and legs is 4
```

Of interest here is that we only changed the `firstClass` name, but in the output the second class name has changed as well to `Cat`.

If we change to a class, the code looks like this:

```csharp
var firstStruct = new AnimalStruct() { Name = "Dog", Legs = 4 };
var secondStruct = firstStruct;

Console.WriteLine($"First struct name is {firstStruct.Name} and legs is {firstStruct.Legs}");
Console.WriteLine($"Second struct name is {secondStruct.Name} and legs is {secondStruct.Legs}");

firstStruct.Name = "Cat";

Console.WriteLine($"First struct name is {firstStruct.Name} and legs is {firstStruct.Legs}");
Console.WriteLine($"Second struct name is {secondStruct.Name} and legs is {secondStruct.Legs}");
```

The output should look like this:

```plaintext
First struct name is Dog and legs is 4
Second struct name is Dog and legs is 4
First struct name is Cat and legs is 4
Second struct name is Dog and legs is 4
```

Note here that the second `struct` name remains dog, even after we change the name of the first.

Second: A `class` is allocated on the stack, and is garbage collected, while a `struct` is allocated on the heap.

You can read a good explanation of this [here](https://www.c-sharpcorner.com/article/C-Sharp-heaping-vs-stacking-in-net-part-i/)

There are some other differences, and you can read about them here:
1. [How to choose between using a struct and a class (Microsoft)](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/choosing-between-class-and-struct)
2. [Differences between a struct and a class (C-Sharp Corner)](https://www.c-sharpcorner.com/blogs/difference-between-struct-and-class-in-c-sharp)
