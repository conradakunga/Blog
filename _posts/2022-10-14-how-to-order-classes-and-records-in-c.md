---
layout: post
title: How To Order Classes And Records In C#
date: 2022-10-14 16:50:56 +0300
categories:
    - C#
    - .NET 7
    - LINQ
---
When it comes to collections of primitive types, ordering is pretty straightforward.


```csharp
// Create a new Random with a seed
var rnd = new Random(500);

// Generate a list of numbers sorted randomly
var numbers = Enumerable.Range(1, 15).OrderBy(element => rnd.Next()).ToList();

// Print the numbers
PrintNumbers(numbers);

// Order the numbers with the old (and still supported) syntax
var ordered = numbers.OrderBy(number => number).ToList();

PrintNumbers(ordered);
```

But suppose you had a collection of complex types?

```csharp
// Create our type
record Agent(string FirstName, string Surname);

// Create a collection of Agent
var agents = new Agent[] { new Agent("James", "Bond"), new Agent("Evelyn", "Salt"), new Agent("Jason", "Bourne"), new Agent("Jane", "Bond") };
```

Now, let us try and order them:

```csharp
var orderedAgents = agents.OrderBy(agent => agent);
```

This gives us the following error:

```plaintext
Unhandled exception. System.InvalidOperationException: Failed to compare two elements in the array.
 ---> System.ArgumentException: At least one object must implement IComparable.
```

What this means is that the program is unable to tell how to arrange the `Agents` in order.

A quick solution is to tell the runtime HOW to order the agents. 

The logic here is first use the `Surname` and then the `FirstName`

```csharp
var orderedAgents = agents.OrderBy(agent => agent.Surname)
    .ThenBy(agent => agent.FirstName).ToList();
```

This works, and prints the following:

```plaintext
Agent { FirstName = James, Surname = Bond }
Agent { FirstName = Jane, Surname = Bond }   
Agent { FirstName = Jason, Surname = Bourne }
Agent { FirstName = Evelyn, Surname = Salt }
```

The problem with this approach is that every time you need to sort them, you must remember to specify in your lambda how to sort, which can get repetitive and monotonous.

A better way is to implement an [IComparer](https://learn.microsoft.com/en-us/dotnet/api/system.collections.icomparer?view=net-6.0).

This is a function that tells the runtime exactly how to handle sorting of the type.

Here is a simple one for our case:

```csharp
public class AgentComparer : IComparer<Agent>
{
    public int Compare(Agent a1, Agent a2)
    {
        var sCompare = a1.Surname.CompareTo(a2.Surname);
        if (sCompare == 0) // surnames match. Compare first names
            return a1.FirstName.CompareTo(a2.FirstName);
        else
            return sCompare;
    }
}
```

The generic `IComparer` interface has one function, [Compare](https://learn.microsoft.com/en-us/dotnet/api/system.collections.icomparer.compare?view=net-6.0). Within this function we use the knowledge that ultimately names are [strings](https://learn.microsoft.com/en-us/dotnet/api/system.string?view=net-7.0), and `strings` already know how to compare themselves using the [CompareTo](https://learn.microsoft.com/en-us/dotnet/api/system.string.compareto?view=net-6.0) method.

The logic here is if two elements, `a1` and `a2` are **EQUAL**, `CompareTo` returns a 0. Otherwise it returns -1 if `a1` is **LESS** or 1 if it is **GREATER**.

We can then wire this into the code for ordering like this:

```csharp
// Order using the comparer
var newlyOrderedAgents = agents.OrderBy(agent => agent, new AgentComparer()).ToList();

PrintCollection(newlyOrderedAgents);
```
This should print the following:

```plaintext
Agent { FirstName = James, Surname = Bond }
Agent { FirstName = Jane, Surname = Bond }
Agent { FirstName = Jason, Surname = Bourne }
Agent { FirstName = Evelyn, Surname = Salt }
```

We can even use the new syntax in .NET 7 that avoids lambdas altogether:

```csharp
// Order using the comparer (new syntax)
var moreNewlyOrderedAgents = agents.Order(new AgentComparer()).ToList();
```

The beauty of this approach is that reversal works as you'd expect, and we do not need to write any special code to support reversed sorting.

```csharp
// reverse sorting
PrintCollection(agents.OrderDescending(new AgentComparer()).ToList());
```

This should print the following:

```plaintext
Agent { FirstName = Evelyn, Surname = Salt }
Agent { FirstName = Jason, Surname = Bourne }
Agent { FirstName = Jane, Surname = Bond }
Agent { FirstName = James, Surname = Bond }
```

Another benefit if doing it this way is you can change how ordering works once without changing all your code.

You can decide, for instance, to sort first on `FirstName` then `Surname` and then change your `Comparer` accordingly.

You can even make the `Comparer` more flexible like this:

```csharp
/// <summary>
/// This comparer allows specification of how to sort
/// </summary>
class AgentAdvancedComparer : IComparer<Agent>
{
    private readonly Comparison _comparison;
    /// <summary>
    /// Constructor
    /// </summary>
    /// <param name="comparison">Enum of how the sorting is to be done</param>
    public AgentAdvancedComparer(Comparison comparison)
    {
        _comparison = comparison;
    }
    public int Compare(Agent a1, Agent a2)
    {
        switch (_comparison)
        {
            case Comparison.FirstNameThenSurname:
                var fCompare = a1.FirstName.CompareTo(a2.FirstName);
                if (fCompare == 0) // first names match. Compare surnames
                    return a1.Surname.CompareTo(a2.Surname);
                else
                    return fCompare; ;
            default:
                var sCompare = a1.Surname.CompareTo(a2.Surname);
                if (sCompare == 0) // surnames match. Compare first names
                    return a1.FirstName.CompareTo(a2.FirstName);
                else
                    return sCompare;
        }
    }
}
```

Then you can use it like this:

```csharp
// Advanced comparer, surname first
PrintCollection(agents.Order(new AgentAdvancedComparer(Comparison.SurnameThenFirstName)).ToList());
```

This should print the following:

```plaintext
Agent { FirstName = James, Surname = Bond }
Agent { FirstName = Jane, Surname = Bond }
Agent { FirstName = Jason, Surname = Bourne }
Agent { FirstName = Evelyn, Surname = Salt }
```

And then change the behaviour like this:

```csharp
// Advanced comparer, first name first
PrintCollection(agents.Order(new AgentAdvancedComparer(Comparison.FirstNameThenSurname)).ToList());
```

This should print the following:

```csharp
Agent { FirstName = Evelyn, Surname = Salt }
Agent { FirstName = James, Surname = Bond }
Agent { FirstName = Jane, Surname = Bond }
Agent { FirstName = Jason, Surname = Bourne }
```

Improved as this is, we can still do one better.

It can get tiresome specifying the `Comparer` each time we want to perform sort operations.

A better alternative is to make the class itself sort aware. This we do by implementing the [IComparable](https://learn.microsoft.com/en-us/dotnet/api/system.icomparable?view=net-6.0) interface.

This has a single method, [CompareTo()](https://learn.microsoft.com/en-us/dotnet/api/system.icomparable.compareto?view=net-6.0)

We update our record to look like this, leveraging the code from our `Comparer` earlier:

```csharp
record Agent : IComparer<Agent>, IComparable<Agent>
{
    public string FirstName { get; }
    public string Surname { get; }
    public Agent(string firstName, string surname)
    {
        Surname = surname;
        FirstName = firstName;
    }
    public int Compare(Agent a1, Agent a2)
    {
        var sCompare = a1.Surname.CompareTo(a2.Surname);
        if (sCompare == 0) // surnames match. Compare first names
            return a1.FirstName.CompareTo(a2.FirstName);
        else
            return sCompare;
    }
    public int CompareTo(Agent other)
    {
        return this.Compare(this, other);
    }
}
```

We can then simplify our calling code like this:

```csharp
// Order
var newlyOrderedAgents = agents.OrderBy(agent => agent).ToList();

PrintCollection(newlyOrderedAgents);

// Order (new syntax)
var moreNewlyOrderedAgents = agents.Order().ToList();

PrintCollection(moreNewlyOrderedAgents);

// reverse sorting
PrintCollection(agents.OrderDescending().ToList());
```

Notice we do not deal anywhere with `Comparers` now - the runtime now natively knows how to sort `Agent` objects. This is a much cleaner approach, and users of your types do not even need to know the magic of how sorting works.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2022-10-14%20-%20How%20To%20Order%20Classes%20And%20Records%20In%20C%23).

Happy hacking!