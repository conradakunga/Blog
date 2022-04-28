---
layout: post
title: Adding Multiple Items To A HashSet In C#
date: 2022-04-28 22:25:49 +0300
categories:
    - C#
---
Let us take a typical object:

```csharp
public record Person(string FirstName, string Surname);
```

If we had a [List](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-6.0) of `Person` objects:

```csharp
// a list of persons
var personList = new List<Person>();
```

We can add multiple items using the [AddRange](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.addrange?view=net-6.0) method:

```csharp
personList.AddRange(new[] { new Person("James", "Bond"), new Person("Jason", "Bourne") });
```

Very straightforward.

If you have a [HashSet](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.hashset-1?view=net-6.0), however, the story is a little different. A `HashSet` does not, in fact, have an `AddRange` method.

However, the HashSet has a [UnionWith](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.hashset-1.unionwith?view=net-6.0) method that you can use for this purpose.

This method takes and [IEnumerable](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.ienumerable-1?view=net-6.0) as a parameter, and thus supports most collections.

```csharp
// a hashset of persons
var personHashSet = new HashSet<Person>();

// add multiple people
personHashSet.UnionWith(new[] { new Person("Evelyn", "Salt"), new Person("Napoleon", "Solo") });

// add people from existing collection
personHashSet.UnionWith(personList);
```

We can verify this simply:

```csharp
foreach (var person in personHashSet)
    Console.WriteLine($"{person.FirstName} {person.Surname}");
```

This will print the following:

![](../images/2022/04/HashSetPrint.png)

The code is is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2022-04-29%20-%20Adding%20Multiplte%20Items%20To%20A%20HashSet%20In%20C%23).

Happy hacking!