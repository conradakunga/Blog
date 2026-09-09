---
layout: post
title: Replacing Multiple Characters In A String Using A Regex
date: 2026-08-25 18:07:03 +0300
categories:
    - C#
    - NET
    - Regex
---

A fairly common problem you will run into is requiring the replacement of a string with something else.

Take, for example, the common issue where you need to represent the name `ng'ang'a` in a SQL statement.

```sql
Update Customers set Name = 'Ng'ang'a' where ID = 1
```

You can see here that the query breaks because the parser thinks the string ends at `ng`.

You solve this problem by **escaping** the single quote, `'` with a **second**.

```sql
Update Customers set Name = 'Ng''ang''a where ID = 1
```

This is achieved in code as follows:

```c#
var sql = "Update Customers set Name = 'Ng'ang'a where ID = 1".Replace("'","''")
```

Suppose we wanted to make **multiple** such substitutions.

Typically we'd **chain** the replacements as follows:

```c#
var sql = "Update Customers set Name = 'Ng'ang'a where ID = 1"
		.Replace("'", "''")
		.Replace("\"", "\"\"")
```

Which works.

The problem with this is **as you add more substitutions, the code becomes slower and slower** as the runtime will need to generate a lot of **intermediate** `strings` for each of these replacements.

If they are very **many**, and the `string` is **large**, the performance will get **worse** and **worse**.

Take, for example, a case where I need to prefix each of these with a slash `\` for some processing.

Writing this using `string` replacement would yield the following:

```c#
string[] specialCharacters =
    ["\\", "+", "-", "!", "(", ")", "{", "}", "[", "]", "^", "\"", "~", "*", "?", ":", "/", "'"];

// Escape all special characters
foreach (var specialCharacter in specialCharacters)
    searchCriteria = searchCriteria.Replace(specialCharacter, $@"\{specialCharacter}");
```

This can be written using a [regular expressio](https://en.wikipedia.org/wiki/Regular_expression)n as follows:

```c#
var sql = "Update Customers set Name = 'Ng'ang'a where ID = 1";
sql = Regex.Replace(sql, @"[\\+\-!(){}\[\]^""~*?:/']", @"\$0");
```

Here we are doing the following:

1. We are passing our pattern as a search **expression** of alternate characters - `[\\+\-!(){}\[\]^""~*?:/']`
2. We are using the [Replace](https://learn.microsoft.com/en-us/dotnet/api/system.text.regularexpressions.regex.replace?view=net-10.0) method of the `Regex` to perform the **substitution**.

It works just as well as the former approach, and ought to perform pretty well as additional `characters` are added, or with large `strings`.

### TLDR

**Rather than using `string.Replace` in a loop, you can use the `Regex.Replace` method to replace multiple characters in a string.**

Happy hacking!
