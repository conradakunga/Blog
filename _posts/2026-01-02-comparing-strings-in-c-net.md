---
layout: post
title: Comparing Strings In C# & .NET
date: 2026-01-02 22:32:27 +0300
categories:
    - C#
    - .NET
---

Comparing [strings](https://en.wikipedia.org/wiki/String_(computer_science)), at face value, seems **straightforward**.

Are these `strings` equal?

1. `Conrad`
2. `conrad`

For all intents and purposes, **yes**.

What about these?

1. `conradakunga@gmail.com`
2. `ConradAkunga@gmail.com`

These, too, can be argued to be the **same**.

What about these?

1. `oO234`
2. `OO234`

Tricky.

If I told you these were **serial numbers**, you would say **no**.

If I told you they were **model numbers** for a car or a bike, you would say **yes**.

The point I am making here is that string equality has **context**.

For example, in **Linux** and **Unix**, file names are [case-insensitive](https://en.wikipedia.org/wiki/Case_sensitivity).

That means the following are all different files:

1. `file.txt`
2. `File.txt`
3. `FILE.txt`
4. `FiLE.tXt`

On Windows, however, this is not the case, as files are **not case-sensitive**.

In our code, we generally need to resolve such issues to do with **case**, where a user has a problem where the case is immaterial.

For example, suppose we have a list of names.

```c#
string[] names = ["Brenda", "Latisha", "Linda", "Felicia", "Dawn",
                  "LeShaun", "Ines", "Alicia", "Teresa", "Monica", 
                  "Sharon", "Nicki", "Lisa", "Veronica", "Karen", 
                  "Vicky", "Cookie", "Tonya", "Diane", "Lori", 
                  "Carla", "Marina", "Selena", "Katrina", "Sabrina", 
                  "Kim", "LaToya", "Tina", "Shelley", "Bridget", 
                  "Cathy", "Rasheeda", "Kelly", "Nicole", "Angel",
                  "Juanita", "Stacy", "Tracie", "Rohna", "Ronda", 
                  "Donna", "Yolanda", "Tawana", "Wanda" ];
```

We want to check if it contains a particular name.

```c#
var name = "Tina";
if (names.Contains(name))
  Console.WriteLine($"{name} exists!");
else
  Console.WriteLine($"{name} doesn't exist!");
```

This, unsurprisingly, prints the following:

```plaintext
Tina exists!
```

If we changed it slightly:

```c#
var name = "tina";
if (names.Contains(name))
  Console.WriteLine($"{name} exists!");
else
  Console.WriteLine($"{name} doesn't exist!");
```

This prints the following:

```plaintext
tina doesn't exist!
```

Here comes the question of **context**,

For this situation, `Tina` is the same as `tina`.

How do we solve this in our code?

A popular solution is to **harmonize the case** of all the letters before comparison, like so:

```c#
var name = "tina";
if (names.Any(n => n.ToUpper() == name.ToUpper()))
  Console.WriteLine($"{name} exists!");
else
  Console.WriteLine($"{name} doesn't exist!");
```

In this case, we are **converting all the letters in the words** to [uppercase](https://www.merriam-webster.com/dictionary/uppercase) to make the comparison.

This prints the result we expect.

```plaintext
tina exists!
```

We can also use [lowercase](https://www.merriam-webster.com/dictionary/lowercase).

```c#
var name = "tina";
if (names.Any(n => n.ToLower() == name.ToLower()))
  Console.WriteLine($"{name} exists!");
else
  Console.WriteLine($"{name} doesn't exist!");
```

There are several **problems** with this approach.

1. Calling [ToUpper](https://learn.microsoft.com/en-us/dotnet/api/system.string.toupper?view=net-10.0) or [ToLower](https://learn.microsoft.com/en-us/dotnet/api/system.string.tolower?view=net-10.0) on all the `strings` creates a new string. If you have a large list of worlds to search, this can impact your **memory usage**.
2. Secondly, and **most importantly**, this solution potentially can [**give you the wrong answer**](https://mattryall.net/blog/the-infamous-turkish-locale-bug#:~:text=In%20the%20Turkish%20alphabet%20there,and%20lowercases%20in%20their%20code.).

> In the Turkish alphabet, there are two letters for ‘i’, dotless and dotted. The problem is that the dotless ‘i’ in lowercase becomes the dotless in uppercase. At first glance, this wouldn’t appear to be a problem; however, the problem lies in what programmers do with upper- and lowercases in their code.

You can try to be **clever** and call the equivalent methods for an [invariant culture](https://stackoverflow.com/questions/2423377/what-is-the-invariant-culture), [ToUpperInvariant](https://learn.microsoft.com/en-us/dotnet/api/system.string.toupperinvariant?view=net-10.0) and [ToLowerInvariant](https://learn.microsoft.com/en-us/dotnet/api/system.string.tolowerinvariant?view=net-10.0)

A better and clearer solution is to use the [string.Equals](https://learn.microsoft.com/en-us/dotnet/api/system.string.equals?view=net-10.0#system-string-equals(system-string-system-stringcomparison)) with the appropriate overload.

```c#
var name = "tina";
if (names.Any(n => string.Equals(n, name, StringComparison.InvariantCultureIgnoreCase)))
  Console.WriteLine($"{name} exists!");
else
  Console.WriteLine($"{name} doesn't exist!");
```

The third parameter, [StringComparison](https://learn.microsoft.com/en-us/dotnet/api/system.stringcomparison?view=net-10.0), is an enum with the following values:

| Name                       | Value | Description                                                  |
| :------------------------- | :---- | :----------------------------------------------------------- |
| CurrentCulture             | 0     | Compare strings using culture-sensitive sort rules and the current culture. |
| CurrentCultureIgnoreCase   | 1     | Compare strings using culture-sensitive sort rules, the current culture, and ignoring the case of the strings being compared. |
| InvariantCulture           | 2     | Compare strings using culture-sensitive sort rules and the invariant culture. |
| InvariantCultureIgnoreCase | 3     | Compare strings using culture-sensitive sort rules, the invariant culture, and ignoring the case of the strings being compared. |
| Ordinal                    | 4     | Compare strings using ordinal (binary) sort rules.           |
| OrdinalIgnoreCase          | 5     | Compare strings using ordinal (binary) sort rules and ignoring the case of the strings being compared. |

This means you can clearly articulate **how** you want the **comparison** to proceed.

### TLDR

**`String` comparison is a very context-sensitive operation, and you need to be clear about how you want to go about it without falling prey to different interpretations of what 'equality' is**

Happy hacking!
