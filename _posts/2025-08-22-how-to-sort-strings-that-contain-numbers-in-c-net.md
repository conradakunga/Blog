---
layout: post
title: How To Sort Strings That Contain Numbers In C# & .NET
date: 2025-08-22 17:34:54 +0300
categories:
    - Linux
    - RaspberryPI
---

Let us look at a very common problem.

Assume we have a `string` collection of numbers from 1 to 9.

And we want to **sort** this collection.

We would do it like so:

```c#
var numbers = Enumerable.Range(1, 9).Select(x => $"{x}").Order().ToList();
numbers.ForEach(Console.WriteLine);
```

This, naturally, will print the following:

```plaintext
1
2
3
4
5
6
7
8
9
```

Now imagine we add one more number to the list, 10.

```c#
var numbers = Enumerable.Range(1, 10).Select(x => $"{x}").Order().ToList();
numbers.ForEach(Console.WriteLine);
```

This will now print the following:

```
1
10
2
3
4
5
6
7
8
9
```

Now, you can't tel by looking that these are string values.

For a `string` , `1`, `10`, `100`, `1,000`, `10,000` etc. all sort before `2`.

Suppose we really wanted to sort them as numeric values.

One way would be to convert the collection to one of numbers. Like so:

```c#
var numbers = Enumerable.Range(1, 10).Select(x => $"{x}").Order().ToList();
// Convert numbers from a list of string to a list of int
var numberValues = numbers.Select(x => Convert.ToInt32(x)).Order().ToList();
numberValues.ForEach(Console.WriteLine);
```

This now prints what we expect.

```plaintext
1
2
3
4
5
6
7
8
9
10
```

Now this is technically correct, but surely there is a better way?

There is!

We can write our own Comparer by implementing the [IComparer](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.icomparer-1?view=net-9.0) interface.

```c#
public sealed class NumericStringComparer : IComparer<string>
{
  public int Compare(string left, string right)
  {
    if (left == right) return 0;
    if (left is null) return -1;
    if (right is null) return 1;

    // Try parse both as integers
    if (int.TryParse(left, out int x) && int.TryParse(right, out int y))
    {
      // Compare the numbers using the integer comparer
      return x.CompareTo(y);
    }

    // Use the default string comparison
    return string.Compare(left, right);
  }
}
```

The List class has a Sort method that allows sorting of the List in place.

So we can do this:

```c#
var numbers = Enumerable.Range(1, 10).Select(x => $"{x}").Order().ToList();
// Sort in place with the comparer
numbers.Sort(new NumericStringComparer());
numbers.ForEach(Console.WriteLine);
```

This now prints as expected.

But we can do one better.

What if the number was within text?

Suppose we have a bunch of Windows Versions that we want to sort.

```c#
string[] windowsVersons =
  [
    "Windows 2000",
    "Windows 2",
    "Windows 1",
    "Windows 98",
    "Windows 4",
    "Windows 95",
    "Windows 5",
    "Windows 7",
    "Windows 8",
    "Windows 10",
    "Windows 3"
  ];

var versions = windowsVersons.ToList();
versions.Sort(new NumericStringComparer());
versions.ForEach(Console.WriteLine);
```

This code prints the following:

```plaintext
Windows 1
Windows 10
Windows 2
Windows 2000
Windows 3
Windows 4
Windows 5
Windows 7
Windows 8
Windows 95
Windows 98
```

Our comparer does not seem to know what to do if the entire value is not a number.

Currently it is treating everything as a string, and is unable to convert each entry to a number.

There is room for improvement in our comparer.

We can extract the number, and then sort using that.

```c#
public sealed class NaturalStringComparer : IComparer<string>
{
  public int Compare(string left, string right)
  {
    if (left == right) return 0;
    if (left is null) return -1;
    if (right is null) return 1;

    var reg = new Regex(@"\d+");

    // Find the first number in each string
    var leftMatch = reg.Match(left);
    var rightMatch = reg.Match(right);

    // Try and find numbers in both strings
    if (leftMatch.Success || rightMatch.Success)
    {
      // Numbers were found for both. Compare those
      return int.Parse(leftMatch.Captures[0].Value).CompareTo(int.Parse(rightMatch.Captures[0].Value));
    }

    // Use the default string comparison
    return string.Compare(left, right);
  }
}
```

If we use our new `NaturalStringComparer`:

```plaintext
Windows 1
Windows 2
Windows 3
Windows 4
Windows 5
Windows 7
Windows 8
Windows 10
Windows 95
Windows 98
Windows 2000
```

Looking good.

But let us throw in a spanner into the works.

I happen to now that there was Windows 3.1 and 3.11.

Let's add those to the mix.

```c#
string[] windowsVersons =
[
  "Windows 2000",
  "Windows 2",
  "Windows 1",
  "Windows 98",
  "Windows 4",
  "Windows 95",
  "Windows 5",
  "Windows 7",
  "Windows 8",
  "Windows 10",
  "Windows 3",
  "Windows 3.11",
  "Windows 3.1"
];
```

Now we get the following:

```plaintext
Windows 1
Windows 2
Windows 3
Windows 3.11
Windows 3.1
Windows 4
Windows 5
Windows 7
Windows 8
Windows 10
Windows 95
Windows 98
Windows 2000
```

Our comparer gave up parsing after the `.`

We can improve this by making it use a `decimal`, rather than an `int`.

The logic is the same - find the first decimal in each string and use that for sorting purposes.

We also need to factor in the edge case that much as decimals have the format 0.00, 0 is also a valid decimal.

This is what the following Regex does:

```plaintext
\d+(\.\d+)?
```

The code looks like this:

```c#
public sealed class UltimateStringComparer : IComparer<string>
{
  public int Compare(string left, string right)
  {
    if (left == right) return 0;
    if (left is null) return -1;
    if (right is null) return 1;

    var reg = new Regex(@"\d+(\.\d+)?");

    // Find the first number in each string
    var leftMatch = reg.Match(left);
    var rightMatch = reg.Match(right);

    if (leftMatch.Success || rightMatch.Success)
    {
      // Numbers were found for both. Compare those
      return decimal.Parse(leftMatch.Captures[0].Value).CompareTo(decimal.Parse(rightMatch.Captures[0].Value));
    }

    // Use the default string comparison
    return string.Compare(left, right);
  }
}
```

Now if we sort this, we get the following:

```plaintext
Windows 1
Windows 2
Windows 3
Windows 3.1
Windows 3.11
Windows 4
Windows 5
Windows 7
Windows 8
Windows 10
Windows 95
Windows 98
Windows 2000
```

And we're done.

Almost.

Let us add some more strings.

```c#
string[] windowsVersons =
[
  "Windows 2000",
  "Windows 2",
  "Windows 1",
  "Windows 98",
  "Windows 4",
  "Windows 95",
  "Windows 5",
  "Windows 7",
  "Windows 8",
  "Windows 10",
  "Windows 3",
  "Windows 3.11",
  "Windows 3.1",
  "DOS 1",
  "DOS 3.1",
  "DOS 3.11"
];
```

If we sort this, we get the following:

```plaintext
Windows 1
DOS 1
Windows 2
Windows 3
Windows 3.1
DOS 3.1
Windows 3.11
DOS 3.11
Windows 4
Windows 5
Windows 7
Windows 8
Windows 10
Windows 95
Windows 98
Windows 2000
```

This has been sorted by the numeric value, but has ignored the text values.

Let's make a final set of changes, including those that will improve the performance.

1. We can use a source-generated regex instead of constructing one at runtime
2. We can cache the generated regex to improve performance regardless of the number of comparisons.
3. Before we compare the numbers (if any), first compare the leading text.

Our final comparer looks like this:

```c#
public sealed partial class MagnificentStringComparer : IComparer<string?>
{
  private static readonly Regex DecimalRegex = MatchDecimalRegex();
  private static readonly Regex LeadingStringRegex = MatchLeadingStringRegex();

  public int Compare(string? left, string? right)
  {
    if (left == right) return 0;
    if (left is null) return -1;
    if (right is null) return 1;

    // First, try grab both leading strings
    var leftStringMatch = LeadingStringRegex.Match(left);
    var rightStringMatch = LeadingStringRegex.Match(right);

    // if both matches didn't succeed, use the normal string comparison
    if (!leftStringMatch.Success && !rightStringMatch.Success)
        return string.Compare(left, right, StringComparison.OrdinalIgnoreCase);

    // if only one match succeeded, use normal string comparison
    if (leftStringMatch.Success != rightStringMatch.Success)
        return string.Compare(left, right, StringComparison.OrdinalIgnoreCase);

    // Here, both matches succeeded. Compare the captured leading strings
    var comparison = string.Compare(leftStringMatch.Groups[1].Value, rightStringMatch.Groups[1].Value,
        StringComparison.OrdinalIgnoreCase);

    // If the leading strings are different, don't bother going any further
    if (comparison != 0) return comparison;

    // If both leading strings are the same, now compare the numbers

    // Find the first number in each string
    var leftDecimalMatch = DecimalRegex.Match(left);
    var rightDecimalMatch = DecimalRegex.Match(right);

    if (leftDecimalMatch.Success && rightDecimalMatch.Success)
    {
        // Numbers were found for both. Compare those
        return decimal.Parse(leftDecimalMatch.Value).CompareTo(decimal.Parse(rightDecimalMatch.Value));
    }

    // Use the default string comparison
    return string.Compare(left, right, StringComparison.OrdinalIgnoreCase);
  }

  [GeneratedRegex(@"\d+(\.\d+)?", RegexOptions.Compiled)]
  private static partial Regex MatchDecimalRegex();


  [GeneratedRegex(@"^(\w+)\s*\d", RegexOptions.Compiled)]
  private static partial Regex MatchLeadingStringRegex();
  }
```

As usual, we have some tests to verify our logic.

```c#
public class StringComparerTests
{
    [Theory]
    [InlineData("Dos", "Dos", 0)]
    [InlineData("Dos", "DOS", 0)]
    [InlineData("Dos", "Windows", -19)]
    [InlineData("Windows 2", "Windows 10", -1)]
    [InlineData("Windows 1", "Windows 10", -1)]
    public void StringValueSortCorrectly(string left, string right, int expected)
    {
        var comparer = new MagnificentStringComparer();
        comparer.Compare(left, right).Should().Be(expected);
    }

    [Fact]
    public void Sorting_Functions_Correctly()
    {
        string[] raw =
        [
            "Windows 2000",
            "Windows 2",
            "Windows 1",
            "Windows 98",
            "Windows 4",
            "Windows 95",
            "Windows 5",
            "Windows 7",
            "Windows 8",
            "Windows 10",
            "Windows 3",
            "Windows 3.11",
            "Windows 3.1",
            "DOS 1",
            "DOS 3.1",
            "DOS 3.11",
            "DOS"
        ];

        string[] final =
        [
            "DOS",
            "DOS 1",
            "DOS 3.1",
            "DOS 3.11",
            "Windows 1",
            "Windows 2",
            "Windows 3",
            "Windows 3.1",
            "Windows 3.11",
            "Windows 4",
            "Windows 5",
            "Windows 7",
            "Windows 8",
            "Windows 10",
            "Windows 95",
            "Windows 98",
            "Windows 2000",
        ];

        var sortedStrings = raw.ToList();
        sortedStrings.Sort(new MagnificentStringComparer());
        sortedStrings.Should().Equal(final);
    }
}
```

### TLDR

**We have written a `Comparer` that allows us to sort strings that optionally contain numbers.**

The code is in my GitHub.

Happy hacking!
