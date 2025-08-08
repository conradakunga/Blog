---
layout: post
title: Building A Simple Password Generator In C# & .NET - Part 5 - Generating Memorable Passwords
date: 2025-08-08 19:55:20 +0300
categories:
    - C#
    - .NET
    - StarLibrary
    - Spectre.Console
---

**This is Part 5 in a series in which we will build a simple password generator.**

In our last post, [Building A Simple Password Generator In C# & .NET - Part 4 - Generating Human Readable Passwords]({% post_url 2025-08-07-building-a-simple-password-generator-in-c-net-part-4-generating-human-readable-passwords %}), we looked at how to generate human-readable passwords with unambiguous characters.

In this post, we will look at how to generate **memorable passwords**.

What is a memorable password?

For this, I am taking inspiration from the excellent [1Password](https://1password.com/).

![1PasswordMemorable](../images/2025/08/1PasswordMemorable.png)

The best way to demonstrate is to generate a couple.

```plaintext
busts-smartest-truce-cylinder
dine-observer-poke-models
momma-thrill-life-slap
malibu-proverb-dotted-donovan
wrinkled-topping-wacky-uber
birdie-gall-harris-specs
blow-relish-josh-stomp
plane-woe-cahill-chun
right-inherent-likely-mailed
quantum-foreplay-meddling-ginger
```

From these, we can see a pattern for each password:

- **Four** words.
- **Hyphen** separated.
- Each word is at least `3` characters long.
- Each word is at most `8` characters long.

The capitalize option generates passwords like these:

```plaintext
TAMPERED-sailing-hosted-figure
campaign-PLANNING-huntsmen-prisons
obvious-SOLD-uhm-hilton
rufus-eleanor-THEORY-riviera
peasants-mould-west-CLIMB
```

It seems to capitalize **one** of the words in the password.

This should be enough to generate a simple implementation.

The first order of business is to find a list of words.

From [this Git archive](https://github.com/dolph/dictionary/blob/master/popular.txt), there is a list of popular English words.

We can start by :

1. **Downloading** the file.
2. **Remove** all words **shorter** than `3` characters
3. **Remove** all words **longer** than `8` characters

The following code executes the above.

```c#
var client = new HttpClient();
// Download all the words	
var allText = await client.GetStringAsync("https://raw.githubusercontent.com/dolph/dictionary/refs/heads/master/popular.txt");
// Split by newline	
var allWords = allText.Split(Environment.NewLine)
// Filter by length
.Where(t => t.Length >= 3 && t.Length <= 8);
// Get a temp file name
var file = Path.GetTempFileName();
// Write to disk	
File.WriteAllLines(file, allWords);
Console.WriteLine($"Written words to {file}");
```

