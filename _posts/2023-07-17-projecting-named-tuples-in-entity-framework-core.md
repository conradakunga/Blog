---
layout: post
title: Projecting Named Tuples In Entity Framework Core
date: 2023-07-17 09:39:43 +0300
categories:
    - Entity Framework Core
    - C#
    - .NET
---

Suppose you had the following class:

```csharp
public class Bank
{
    public Guid BankID { get; set; }
    public string Code { get; set; }
    public string Name { get; set; }
}
```

And suppose you were persisting it using[ Entity Framework 7](https://learn.microsoft.com/en-us/ef/core/).

You query the database like this:

```csharp
public async Task<List<Bank>> GetList(CancellationToken cancellationToken)
{
    return await _context.Banks.ToListAsync(cancellationToken);
}
```

No suppose you wanted to get back the data as a collection of [named tuples](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/value-tuples).

You would write a method like this:

```csharp
public List<(Guid BankID, string Code)> GetDetails()
{
    return _context.Banks.Select(x => (x.BankID, x.Code)).ToList();
}
```

This, however, will not compile; and you will get the following error:

```plaintext
An expression tree cannot contain a tuple literal
```

The problem here is that Entity Framework does not support projection to named tuples, or, for that matter, any kind of tuples.

Which is surprising, because the code works perfectly for a normal collection.

```csharp
var banks = new List<Bank>();
banks.AddRange(new[] { 
    new Bank { BankID = Guid.NewGuid(), Code = "1", Name = "One" },
    new Bank { BankID = Guid.NewGuid(), Code = "2", Name = "Two" }
});

banks.Select(b => (b.BankID, b.Code));
```

Why does this work but not the EF version?

Because the collection version works against [IEnumerable](https://learn.microsoft.com/en-us/dotnet/api/system.collections.ienumerable?view=net-7.0), but the Entity Framework version works against [IQueryable](https://learn.microsoft.com/en-us/dotnet/api/system.linq.iqueryable?view=net-7.0)

However there is a way around this:

1. Project the properties you would like to return into an [anonymous type](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/anonymous-types)
1. Retrieve the collection of anonymous types
1. Perform the projection on the collection

Like so:

```csharp
public List<(Guid BankID, string Code)> GetDetails()
{
    return _context.Banks.Select(x => new { x.BankID, x.Code })
        .AsEnumerable()
        .Select(x => (x.BankID, x.Code))
        .ToList();
}
```

The reason this works is after the [AsEnumerable](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.asenumerable?view=net-7.0#system-linq-enumerable-asenumerable-1(system-collections-generic-ienumerable((-0)))) call, we are no dealing with an [IEmunerable](https://learn.microsoft.com/en-us/dotnet/api/system.collections.ienumerable?view=net-7.0) instead of an [IQueryable](https://learn.microsoft.com/en-us/dotnet/api/system.linq.iqueryable?view=net-7.0).

If you want to filter the returned data in some way, put the filter condition BEFOFE the .AsEnumerable() so that you don't unnecessarily load all the data only to filter and throw away what you don't need later.

Like so:

```csharp
return _context.Banks.Where(x=>x.Code.StartsWith("A"))
    .Select(x => new { x.BankID, x.Code })
    .AsEnumerable()
    .Select(x => (x.BankID, x.Code))
    .ToList();
```


Happy hacking!

