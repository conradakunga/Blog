---
layout: post
title: Exposing Collections As Read-Only In C# & .NET
date: 2025-06-03 20:58:23 +0300
categories:
    - C#
    - .NET
---

One of the considerations you will face when writing an application is how to make sure that the **state within your class is protected**, in terms of external access and modification.

For example, this is a **problematic** design:

```c#
public class Spy
{
	public string FirstName { get; set; }
	public string Surname { get; set; }
}
```

It is problematic because a developer can do this:

```c#
var spy = new Spy { FirstName = "James", Surname = "Bond" };

spy.FirstName = "Jane";
```

This is likely not what you want.

You can address this issue as follows:

```c#
public class Spy
{
	public required string FirstName { get; init; }
	public required string Surname { get; init; }
}
```

Now you cannot change the internal state of the type.

What if the property you want to expose is a [collection](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/collections)?

You would typically start by doing something like this:

```c#
public required string FirstName { get; init; }
public required string Surname { get; init; }
public List<string> Agencies { get; } = [];
```

You can then add an `Agency` as follows:

```c#
var spy = new Spy { FirstName = "James", Surname = "Bond" };
spy.Agencies.Add("MI-6");
spy.Agencies.Add("MI-5");
```

The problem with doing it this way is that if you are exposing this to external users, **they can do anything with your collection**. Including this:

```c#
spy.Agencies.Clear();
```

Which might not be what you want.

A typical solution would be:

1. Add dedicated logic to add an `Agency` that populates an internal `Agency` collection.

2. Expose the `Agency` collection using a [read-only collection](https://learn.microsoft.com/en-us/dotnet/api/system.collections.objectmodel.readonlycollection-1?view=net-9.0).

    

```c#
public class Spy
{
	private readonly List<string> _agencies =[];
	public IEnumerable<string> Agencies => _agencies.AsReadOnly();
	
	public required string FirstName { get; init; }
	public required string Surname { get; init; }

	public void AddAgency(string agency)
	{
		if (!_agencies.Contains(agency))
		_agencies.Add(agency);
	}
}
```

Users can then do the following:

```c#
var spy = new Spy { FirstName = "James", Surname = "Bond" };

spy.AddAgency("MI-5");
spy.AddAgency("MI-6");

Console.WriteLine($"{spy.FirstName} {spy.Surname} is in  {spy.Agencies.Count()}");
```

So far, so good.

Suppose we had a property `Stations` that looked like this:

```c#
public string[] Stations = ["London", "Barbados", "Jamaica"];
```

You cannot expose this directly as it could be changed.

A client could do this:

```c#
spy.Stations[0] = "Nairobi";
```

The typical solution would be to do this:

```c#
public IEnumerable Stations => _stations.AsReadOnly();
```

This `IEnumerable` would be, just like before, a `ReadOnlyCollection` of `string`.

This collection **cannot be modified** - you cannot modify the **elements** themselves or **add** to them, or **clear** them.

Thus, your internal state cannot be interfered with from outside, unless you explicitly provide contracts to do this.

### TLDR

**When exposing collections from a type, consider using a `ReadOnlyCollection` to prevent inadvertent or deliberate manipulation of your collection.**

The code is in my GitHub.

Happy hacking!
