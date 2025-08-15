---
layout: post
title: Class That Stores Multiple Named, Typed Generic Lists - Improvement
date: 2025-08-13 10:51:45 +0300
categories:
---

In our last post, [Class That Stores Multiple Named, Typed Generic Lists]({% post_url 2025-08-12-class-that-stores-multiple-named-typed-generic-lists %}), we built a component that stores a collection of named, generic [List](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-9.0) objects.

It worked well until I ran into a potential challenge.

The underlying data structure is a [Dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-9.0), and the [Remove](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.remove?view=net-9.0) method **does nothing if you pass it a key that does not exist**. 

Or, to be more accurate, it returns `false` if it was **unable to remove** the keyed element.

I would prefer if there was **no doubt** that something has gone wrong, because chances are, if I am removing something with a provided key, I expect it to be there.

The solution to this is to **throw an exception** if the key is not found.

```c#
/// <summary>
/// Remove a list from the store
/// </summary>
/// <param name="name"></param>
/// <exception cref="ArgumentException"></exception>
/// <exception cref="KeyNotFoundException"></exception>
public void Remove(string name)
{
    if (string.IsNullOrWhiteSpace(name))
    {
        throw new ArgumentException("Name cannot be null or empty.", nameof(name));
    }

    // Check if the key exists
    if (!_dictLists.ContainsKey(name))
        throw new KeyNotFoundException($"No list found with the name '{name}'.");

    _dictLists.Remove(name);
}
```

Naturally, a test to verify the same:

```c#
[Fact]
public void Store_Throws_Exception_When_Removing_NonExistent_Item()
{
    var store = new GenericListStore();
    var ex = Record.Exception(() => store.Remove("strings"));
    ex.Should().BeOfType<KeyNotFoundException>();
}
```

### TLDR

**We have improved the `Remove` method to throw an `Exception` if the name of the `List` to remove is not found.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/GenericListStore).

Happy hacking!
