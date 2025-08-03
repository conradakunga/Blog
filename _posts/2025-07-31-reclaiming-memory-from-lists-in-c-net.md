---
layout: post
title: Reclaiming Memory From Lists In C# & .NET
date: 2025-07-31 15:14:56 +0300
categories:
    - C#
    - .NET
    - Data Structures
---

In the post [Considerations When Adding Items To A List In C# & .NET]({% post_url 2025-07-29-considerations-when-adding-items-to-a-list-in-c-net %}), we discussed how the runtime **dynamically pre-allocates capacity** when you **add items** to a `List`.

We also discussed how to **pre-allocate** a `List` of a **known size** in advance.

```c#
var list = new List<int>(150);
Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
```

The question arises - what if you have the **opposite problem**?

You have created a large list with pre-allocated capacity, and then due to the conditions of your running program, y**ou no longer require that large allocated capacity**.

For this situation, you can call the [TrimExcess](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.trimexcess?view=net-9.0) method.

```c#
var list = new List<int>(150);
Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
list.TrimExcess();
Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
```

This will print the following:

```plaintext
Size is 0 and capacity is 150
Size is 0 and capacity is 0
```

This will behave slightly differently if there are some elements in the `List`.

```c#
var list = new List<int>(150);
Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
list.Add(1);
list.TrimExcess();
Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
```

This will print the following;:

```plaintext
Size is 0 and capacity is 150
Size is 1 and capacity is 1
```

Depending on your needs, it might be necessary to do this because the **runtime makes no attempt to reclaim unused capacity**.

`TrimExcess` has no effect if the list is at **more than 90% of capacity**, as the **gains** would be considered **minimal** against the **expense**.

```c#
var list = Enumerable.Range(0, 150).ToList();
for (var i = 0; i < 150; i++)
{
  list.RemoveAt(0);
  Console.WriteLine($"Size is {list.Count} and capacity is {list.Capacity}");
}
```

This prints the following:

```plaintext
Size is 149 and capacity is 150
Size is 148 and capacity is 150
Size is 147 and capacity is 150
Size is 146 and capacity is 150
Size is 145 and capacity is 150
Size is 144 and capacity is 150
Size is 143 and capacity is 150
Size is 142 and capacity is 150
Size is 141 and capacity is 150
Size is 140 and capacity is 150
Size is 139 and capacity is 150
Size is 138 and capacity is 150
Size is 137 and capacity is 150
Size is 136 and capacity is 150
Size is 135 and capacity is 150
Size is 134 and capacity is 150
Size is 133 and capacity is 150
Size is 132 and capacity is 150
Size is 131 and capacity is 150
Size is 130 and capacity is 150
Size is 129 and capacity is 150
Size is 128 and capacity is 150
Size is 127 and capacity is 150
Size is 126 and capacity is 150
Size is 125 and capacity is 150
Size is 124 and capacity is 150
Size is 123 and capacity is 150
Size is 122 and capacity is 150
Size is 121 and capacity is 150
Size is 120 and capacity is 150
Size is 119 and capacity is 150
Size is 118 and capacity is 150
Size is 117 and capacity is 150
Size is 116 and capacity is 150
Size is 115 and capacity is 150
Size is 114 and capacity is 150
Size is 113 and capacity is 150
Size is 112 and capacity is 150
Size is 111 and capacity is 150
Size is 110 and capacity is 150
Size is 109 and capacity is 150
Size is 108 and capacity is 150
Size is 107 and capacity is 150
Size is 106 and capacity is 150
Size is 105 and capacity is 150
Size is 104 and capacity is 150
Size is 103 and capacity is 150
Size is 102 and capacity is 150
Size is 101 and capacity is 150
Size is 100 and capacity is 150
Size is 99 and capacity is 150
Size is 98 and capacity is 150
Size is 97 and capacity is 150
Size is 96 and capacity is 150
Size is 95 and capacity is 150
Size is 94 and capacity is 150
Size is 93 and capacity is 150
Size is 92 and capacity is 150
Size is 91 and capacity is 150
Size is 90 and capacity is 150
Size is 89 and capacity is 150
Size is 88 and capacity is 150
Size is 87 and capacity is 150
Size is 86 and capacity is 150
Size is 85 and capacity is 150
Size is 84 and capacity is 150
Size is 83 and capacity is 150
Size is 82 and capacity is 150
Size is 81 and capacity is 150
Size is 80 and capacity is 150
Size is 79 and capacity is 150
Size is 78 and capacity is 150
Size is 77 and capacity is 150
Size is 76 and capacity is 150
Size is 75 and capacity is 150
Size is 74 and capacity is 150
Size is 73 and capacity is 150
Size is 72 and capacity is 150
Size is 71 and capacity is 150
Size is 70 and capacity is 150
Size is 69 and capacity is 150
Size is 68 and capacity is 150
Size is 67 and capacity is 150
Size is 66 and capacity is 150
Size is 65 and capacity is 150
Size is 64 and capacity is 150
Size is 63 and capacity is 150
Size is 62 and capacity is 150
Size is 61 and capacity is 150
Size is 60 and capacity is 150
Size is 59 and capacity is 150
Size is 58 and capacity is 150
Size is 57 and capacity is 150
Size is 56 and capacity is 150
Size is 55 and capacity is 150
Size is 54 and capacity is 150
Size is 53 and capacity is 150
Size is 52 and capacity is 150
Size is 51 and capacity is 150
Size is 50 and capacity is 150
Size is 49 and capacity is 150
Size is 48 and capacity is 150
Size is 47 and capacity is 150
Size is 46 and capacity is 150
Size is 45 and capacity is 150
Size is 44 and capacity is 150
Size is 43 and capacity is 150
Size is 42 and capacity is 150
Size is 41 and capacity is 150
Size is 40 and capacity is 150
Size is 39 and capacity is 150
Size is 38 and capacity is 150
Size is 37 and capacity is 150
Size is 36 and capacity is 150
Size is 35 and capacity is 150
Size is 34 and capacity is 150
Size is 33 and capacity is 150
Size is 32 and capacity is 150
Size is 31 and capacity is 150
Size is 30 and capacity is 150
Size is 29 and capacity is 150
Size is 28 and capacity is 150
Size is 27 and capacity is 150
Size is 26 and capacity is 150
Size is 25 and capacity is 150
Size is 24 and capacity is 150
Size is 23 and capacity is 150
Size is 22 and capacity is 150
Size is 21 and capacity is 150
Size is 20 and capacity is 150
Size is 19 and capacity is 150
Size is 18 and capacity is 150
Size is 17 and capacity is 150
Size is 16 and capacity is 150
Size is 15 and capacity is 150
Size is 14 and capacity is 150
Size is 13 and capacity is 150
Size is 12 and capacity is 150
Size is 11 and capacity is 150
Size is 10 and capacity is 150
Size is 9 and capacity is 150
Size is 8 and capacity is 150
Size is 7 and capacity is 150
Size is 6 and capacity is 150
Size is 5 and capacity is 150
Size is 4 and capacity is 150
Size is 3 and capacity is 150
Size is 2 and capacity is 150
Size is 1 and capacity is 150
Size is 0 and capacity is 150
```

Here, we can see that even as elements are removed from the `List`, the `Capacity` remains **constant** even as the size (`Count`) **reduces**.. This may or may not be an issue for you.

### TLDR

**It is possible to reclaim unused `List` capacity using the `TrimExcess` method.**

Happy hacking!
