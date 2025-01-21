---
layout: post
title: Using A LINQ Pipeline To Solve Problems
date: 2025-01-20 23:35:27 +0300
categories:
    - C#
    - .NET
    - LINQ
---

I recently encountered a very simple problem: Given a string, I needed to get **each letter's occurrence and its corresponding count** and then **print them from the most frequently occurring to the least**.

A quick way to resolve this would be to use a [dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-9.0). Like this:

```c#
var input = "1. - Bananarama is a rather grand pop group!!!";
// Create a dictionary to store the data
var letterFrequencies = new Dictionary<char, int>();
// Loop through each character in the string
foreach (char c in input)
{
  // Check if it is a character
  if (char.IsLetter(c))
  {
    // Check if character is a dictionary key
    if (letterFrequencies.ContainsKey(c))
    {
      // It is. Increment the count
      letterFrequencies[c]++;
    }
    else
    {
      // Set the initial count
      letterFrequencies[c] = 1;
    }
  }
}

```

We can simplify it further by **removing non-characters at the source**:

```c#
var input = "1. - Bananarama is a rather grand pop group!!!";
// Create a dictionary to store the data
var letterFrequencies = new Dictionary<char, int>();
// Loop through each character in the string
foreach (char c in input.Where(i => Char.IsLetter(i)))
{
  // Check if character is a dictionary key
  if (letterFrequencies.ContainsKey(c))
  {
    // It is. Increment the count
    letterFrequencies[c]++;
  }
  else
  {
    // Set the initial count
    letterFrequencies[c] = 1;
  }
}
```

We can then simplify this even further by using the [GetValueOrDefault]() method of the dictionary

```c#
var input = "1. - Bananarama is a rather grand pop group!!!";
// Create a dictionary to store the data
var letterFrequencies = new Dictionary<char, int>();
foreach (char c in input.Where(i => Char.IsLetter(i)))
{
  letterFrequencies[c] = letterFrequencies.GetValueOrDefault(c, 0) + 1;
}
```

This is better, but we have only tackled half the problem—we still need to output **each letter by frequency, from the most frequent to the least** frequent.

We can solve this problem using a [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) pipeline.

```c#
// Filter only characaters
var result = input.Where(s => Char.IsLetter(s))
// Group by the characeter
.GroupBy(x => x)
// Project into an anonymous type { char Letter, int Count }
.Select(x => new { Letter = x.Key, Count = x.Count() })
// Order by the count
.OrderByDescending(x => x.Count)
// Return the results as an array
.ToArray();
```

Finally, we can output our results.

```c#
// Loop and print
foreach (var item in result)
  Console.WriteLine($"Letter - {item.Letter}; Count - {item.Count}");
```

This should print the following:

```plaintext
Letter - a; Count - 8
Letter - r; Count - 5
Letter - n; Count - 3
Letter - p; Count - 3
Letter - g; Count - 2
Letter - o; Count - 2
Letter - B; Count - 1
Letter - m; Count - 1
Letter - i; Count - 1
Letter - s; Count - 1
Letter - t; Count - 1
Letter - h; Count - 1
Letter - e; Count - 1
Letter - d; Count - 1
Letter - u; Count - 1
```




### TLDR

**LINQ pipelines can very elegantly solve a number of algorithmic problems.**

Happy hacking!
