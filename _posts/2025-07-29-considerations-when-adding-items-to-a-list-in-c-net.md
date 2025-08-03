---
layout: post
title: Considerations When Adding Items To A List In C# & .NET
date: 2025-07-29 14:10:20 +0300
categories:
    - C#
    - .NET
---

One of the data structures you will probably frequently use is the generic [List](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-9.0).

This allows you to store a **collection of items of whatever type** you require. As it is a [generic](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/generics) data structure, the **types** must be the **same** (or coercible).

You would typically add items like this:

```c#
var list = new List<string>();
list.Add("Hello");
```

At which point you might wonder, how many items can you add?

Your first hard limit is the value of [Int32.MaxValue](https://learn.microsoft.com/en-us/dotnet/api/system.int32.maxvalue?view=net-9.0), which corresponds to the data type of the [Count](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.count?view=net-9.0) property. This is the **number of items** in the `List`. This is a large number - 2.14 billion (`2,147,483,647`).

Your other, more practical limit, is the **size of the data structures you are storing** in the `List`. You might run into physical memory constraints **before** you even approach the 2 billion theoretical maximum.

But of interest is how the runtime behaves when it comes to **adding items**.

The fact that a `List` can contain `2,147,483,647` items does not mean it is created with this number of empty elements.

What you might not know is that when you create a `List`, the runtime creates a `List` with a very small capacity that **grows** as you **add items**.

You can interrogate this using the [Capacity](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.capacity?view=net-9.0) property. This is different from the actual **size** of the `List`, the `Count`, which reflects the **number of elements** in the list.

The following code creates a list, adds items to the list, and prints the `Count` and the `Capacity`.

```c#
var list = new List<int>();
Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
for (var i = 0; i < 150; i++)
{
  list.Add(i);
  Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
}
```

If you run this code, it will print the following:

```plaintext
Size is 0 and capacity is 0
Size is 1 and capacity is 4
Size is 2 and capacity is 4
Size is 3 and capacity is 4
Size is 4 and capacity is 4
Size is 5 and capacity is 8
Size is 6 and capacity is 8
Size is 7 and capacity is 8
Size is 8 and capacity is 8
Size is 9 and capacity is 16
Size is 10 and capacity is 16
Size is 11 and capacity is 16
Size is 12 and capacity is 16
Size is 13 and capacity is 16
Size is 14 and capacity is 16
Size is 15 and capacity is 16
Size is 16 and capacity is 16
Size is 17 and capacity is 32
Size is 18 and capacity is 32
Size is 19 and capacity is 32
Size is 20 and capacity is 32
Size is 21 and capacity is 32
Size is 22 and capacity is 32
Size is 23 and capacity is 32
Size is 24 and capacity is 32
Size is 25 and capacity is 32
Size is 26 and capacity is 32
Size is 27 and capacity is 32
Size is 28 and capacity is 32
Size is 29 and capacity is 32
Size is 30 and capacity is 32
Size is 31 and capacity is 32
Size is 32 and capacity is 32
Size is 33 and capacity is 64
Size is 34 and capacity is 64
Size is 35 and capacity is 64
Size is 36 and capacity is 64
Size is 37 and capacity is 64
Size is 38 and capacity is 64
Size is 39 and capacity is 64
Size is 40 and capacity is 64
Size is 41 and capacity is 64
Size is 42 and capacity is 64
Size is 43 and capacity is 64
Size is 44 and capacity is 64
Size is 45 and capacity is 64
Size is 46 and capacity is 64
Size is 47 and capacity is 64
Size is 48 and capacity is 64
Size is 49 and capacity is 64
Size is 50 and capacity is 64
Size is 51 and capacity is 64
Size is 52 and capacity is 64
Size is 53 and capacity is 64
Size is 54 and capacity is 64
Size is 55 and capacity is 64
Size is 56 and capacity is 64
Size is 57 and capacity is 64
Size is 58 and capacity is 64
Size is 59 and capacity is 64
Size is 60 and capacity is 64
Size is 61 and capacity is 64
Size is 62 and capacity is 64
Size is 63 and capacity is 64
Size is 64 and capacity is 64
Size is 65 and capacity is 128
Size is 66 and capacity is 128
Size is 67 and capacity is 128
Size is 68 and capacity is 128
Size is 69 and capacity is 128
Size is 70 and capacity is 128
Size is 71 and capacity is 128
Size is 72 and capacity is 128
Size is 73 and capacity is 128
Size is 74 and capacity is 128
Size is 75 and capacity is 128
Size is 76 and capacity is 128
Size is 77 and capacity is 128
Size is 78 and capacity is 128
Size is 79 and capacity is 128
Size is 80 and capacity is 128
Size is 81 and capacity is 128
Size is 82 and capacity is 128
Size is 83 and capacity is 128
Size is 84 and capacity is 128
Size is 85 and capacity is 128
Size is 86 and capacity is 128
Size is 87 and capacity is 128
Size is 88 and capacity is 128
Size is 89 and capacity is 128
Size is 90 and capacity is 128
Size is 91 and capacity is 128
Size is 92 and capacity is 128
Size is 93 and capacity is 128
Size is 94 and capacity is 128
Size is 95 and capacity is 128
Size is 96 and capacity is 128
Size is 97 and capacity is 128
Size is 98 and capacity is 128
Size is 99 and capacity is 128
Size is 100 and capacity is 128
Size is 101 and capacity is 128
Size is 102 and capacity is 128
Size is 103 and capacity is 128
Size is 104 and capacity is 128
Size is 105 and capacity is 128
Size is 106 and capacity is 128
Size is 107 and capacity is 128
Size is 108 and capacity is 128
Size is 109 and capacity is 128
Size is 110 and capacity is 128
Size is 111 and capacity is 128
Size is 112 and capacity is 128
Size is 113 and capacity is 128
Size is 114 and capacity is 128
Size is 115 and capacity is 128
Size is 116 and capacity is 128
Size is 117 and capacity is 128
Size is 118 and capacity is 128
Size is 119 and capacity is 128
Size is 120 and capacity is 128
Size is 121 and capacity is 128
Size is 122 and capacity is 128
Size is 123 and capacity is 128
Size is 124 and capacity is 128
Size is 125 and capacity is 128
Size is 126 and capacity is 128
Size is 127 and capacity is 128
Size is 128 and capacity is 128
Size is 129 and capacity is 256
Size is 130 and capacity is 256
Size is 131 and capacity is 256
Size is 132 and capacity is 256
Size is 133 and capacity is 256
Size is 134 and capacity is 256
Size is 135 and capacity is 256
Size is 136 and capacity is 256
Size is 137 and capacity is 256
Size is 138 and capacity is 256
Size is 139 and capacity is 256
Size is 140 and capacity is 256
Size is 141 and capacity is 256
Size is 142 and capacity is 256
Size is 143 and capacity is 256
Size is 144 and capacity is 256
Size is 145 and capacity is 256
Size is 146 and capacity is 256
Size is 147 and capacity is 256
Size is 148 and capacity is 256
Size is 149 and capacity is 256
Size is 150 and capacity is 256
```

From what we can see here, initially, a `Capacity` of `0` is assigned. 

Then, when we add the first element, the `Capacity` is set to 4.

From then on, the instant the `Count` gets to the `Capacity`, the `Capacity` is **doubled**.

Given that the underlying data structure of a list is an [array](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/arrays), when the `Capacity` is hit, the runtime creates a **new**, **larger** `array`, copies the values over, and then assigns the new entries to this larger `array`.

Needless to say, this is an **expensive** operation, especially for a `List` that is **growing rapidly**.

If you **know in advance** the number of the elements that will be contained, you can **pre-allocate the appropriate capacity** by calling the appropriate [constructor](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.-ctor?view=net-9.0#system-collections-generic-list-1-ctor(system-int32)), to which you pass the requested **capacity**.

```c#
var list = new List<int>(150);
Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
```

This will print the following:

```plaintext
Size is 0 and capacity is 150
```

### TLDR

**The underlying data structure for lists gets dynamically re-created once the pre-allocated capacity is reached. You can avoid this by pre-allocating the required capacity when creating the list.**

Happy hacking!
