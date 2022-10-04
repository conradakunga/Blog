---
layout: post
title: Tip - Using LINQ To Filter A List Of Strings Containing Words In Another List
date: 2022-10-04 21:34:22 +0300
categories:
    - C#
    - LINQ
    - Tips
---
Suppose you have this list of snacks.

```plaintext
Strawberry Juice
Banana Jam
Peach Juice
Banana Pie
Strawberry Crumble
Kiwi Yoghurt
Apple Crumble
Apple Pie
Strawberry Jam
Mango Yoghurt
Apple Juice
Peach Jam
Peach Pie
Mango Cake
Kiwi Pie
Banana Crumble
Strawberry Cake
Peach Cake
Kiwi Crumble
Peach Crumble
Peach Yoghurt
Kiwi Jam
Apple Yoghurt
Banana Cake
Mango Pie
Banana Yoghurt
Apple Cake
Banana Juice
Kiwi Juice
Mango Crumble
Kiwi Cake
Apple Jam
Mango Jam
Mango Juice
Strawberry Pie
Strawberry Yoghurt
```

If you wanted to filter all snacks that are `Jam`, you would do it like this:

```csharp
var snacks = new[] { "Strawberry Juice", "Banana Jam", "Peach Juice", "Banana Pie", "Strawberry Crumble", "Kiwi Yoghurt", "Apple Crumble", "Apple Pie", "Strawberry Jam", "Mango Yoghurt", "Apple Juice", "Peach Jam", "Peach Pie", "Mango Cake", "Kiwi Pie", "Banana Crumble", "Strawberry Cake", "Peach Cake", "Kiwi Crumble", "Peach Crumble", "Peach Yoghurt", "Kiwi Jam", "Apple Yoghurt", "Banana Cake", "Mango Pie", "Banana Yoghurt", "Apple Cake", "Banana Juice", "Kiwi Juice", "Mango Crumble", "Kiwi Cake", "Apple Jam", "Mango Jam", "Mango Juice", "Strawberry Pie", "Strawberry Yoghurt" };

var jams = snacks.Where(snack => snack.Contains("Jam"));

foreach (var jam in jams)
{
    Console.WriteLine(jam);
}
```

This should print the following:

```plaintext
Banana Jam
Strawberry Jam
Peach Jam
Kiwi Jam
Apple Jam
Mango Jam
```

Suppose, however, you wanted to list any snack that had `Banana`, `Strawberry` Or `Kiwi`?

You would do it like this:

```csharp
var filter = new[] { "Banana", "Strawberry", "Kiwi" };

var filteredSnacks = snacks.Where(snack => filter.Any(filterString => snack.Contains(filterString)));

foreach (var filteredSnack in filteredSnacks)
{
    Console.WriteLine(filteredSnack);
}
```

This should print the following:

```plaintext
Strawberry Juice
Banana Jam
Banana Pie
Strawberry Crumble
Kiwi Yoghurt
Strawberry Jam
Kiwi Pie
Banana Crumble
Strawberry Cake
Kiwi Crumble
Kiwi Jam
Banana Cake
Banana Yoghurt
Banana Juice
Kiwi Juice
Kiwi Cake
Strawberry Pie
Strawberry Yoghurt
```

Here we are making use of the [Enumerable.Any](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.any?view=net-7.0) extension method, and passing it the condition to evaluate.

As `Any` and `Where` are methods of `IEnumerable`, this code will work for any collection of strings - `Array`, `List`, etc

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2022-10-04%20-%20Using%20LINQ%20To%20Filter%20A%20List%20Of%20Strings%20Containing%20Words%20In%20Another%20List).

Happy hacking!