---
layout: post
title: Why Doesn't PowerShell Use < and > For Less Than & Greater Than?
date: 2025-10-04 12:43:43 +0300
categories:
    - PowerShell
---

I was recently reviewing some [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.5) code with a mentee.

The code itself looked something like this:

```powershell
$legalAge = 18

$studentAge = 17

if ($studentAge -lt $legalAge)
{
    Write-Host "This student is under age"
}
else
{
    write-host "This student is legal"
}

```

She asked:

> Almost all programming languages use `<` for less than.
>
> Why doesn't PowerShell? It would be much easier to read and understand.

An excellent question.

However, one needs to understand the [history and rationale](https://en.wikipedia.org/wiki/PowerShell) behind `PowerShell's` origin.

`PowerShell` isn't a programming language in its traditional sense, but is more of a [shell](https://en.wikipedia.org/wiki/Shell_(computing)) scripting language.

And in most shells, `<` and `>` are used for [input  & output redirection](https://www.geeksforgeeks.org/linux-unix/input-output-redirection-in-linux/). That means those symbols are **very well understood**, and to reuse them for logic checks would introduce a lot of **chaos** and **friction**.

It was therefore prudent to introduce **new operators** to avoid this problem, in this case `-lt` meaning less than.

The other operators are as follows:

| Operator | Meaning                        |
|----------|--------------------------------|
| `-eq`    | Equal to                       |
| `-ne`    | Not equal to                   |
| `-gt`    | Greater than                   |
| `-ge`    | Greater than or equal to       |
| `-lt`    | Less than                      |
| `-le`    | Less than or equal to          |
| `-like`  | Wildcard string comparison     |
| `-notlike` | Wildcard string not like     |
| `-match` | Regex match                    |
| `-notmatch` | Regex not match             |
| `-contains` | Collection contains value   |
| `-notcontains` | Collection does not contain |
| `-in`    | Value in collection            |
| `-notin` | Value not in collection        |
| `-replace` | Regex replace                |

### TLDR

**PowerShell does not use `<` and `>` for comparison, as those are already used for input & output redirection.**

Happy hacking!
