---
layout: post
title: Removing Items From A Priority Queue
date: 2024-12-04 04:00:00 +0300
categories:
    - C#
    - .NET 9
---

.NET 6 introduced the [PriorityQueue](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.priorityqueue-2?view=net-9.0), a data structure that is a queue that allows you to attach a **weight**, or a **priority**, to enqueued items to affect the dequeuing behaviour.

It worked like this:

```csharp
// Setup our queue of spies
var spyQueue = new PriorityQueue<string, int>();

// Populate
spyQueue.Enqueue("James Bond", 3);
spyQueue.Enqueue("Evelyn Salt", 2);
spyQueue.Enqueue("Jason Bourne", 4);
spyQueue.Enqueue("George Smiley", 1);

// Deque in order or priority
while (spyQueue.Count > 0)
{
  var spy = spyQueue.Dequeue();
  Console.WriteLine(spy);
}
```

This will print the following:

```plaintext
George Smiley
Evelyn Salt
James Bond
Jason Bourne
```

Suppose, for some reason, you wanted to remove `Jason Bourne` from the queue.

For a long time, **this was not possible**. To remove an element, you had to dequeue all the items.

Until now, in .NET 9, where a [Remove](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.priorityqueue-2.remove?view=net-9.0) method has been introduced.

You can now do the following:

```csharp
// Setup our queue of spies
var spyQueue = new PriorityQueue<string, int>();

// Populate
spyQueue.Enqueue("James Bond", 3);
spyQueue.Enqueue("Evelyn Salt", 2);
spyQueue.Enqueue("Jason Bourne", 4);
spyQueue.Enqueue("George Smiley", 1);

// Remove James Bond
var success = spyQueue.Remove("James Bond", out var removedSpy, out var removedPriority);

// Check for success
if (success)
{
  Console.WriteLine($"Successfully removed {removedSpy} from the queue, who had a priority of {removedPriority}");
}
else
{
  Console.WriteLine("Failed to remove element");
}

// Deque in order or priority
while (spyQueue.Count > 0)
{
  var spy = spyQueue.Dequeue();
  Console.WriteLine(spy);
}
```

Which will print the following:

```plaintext
Successfully removed James Bond from the queue, who had a priority of 3
George Smiley
Evelyn Salt
Jason Bourne
```

You might wonder why are we checking for the success of the removal here:

```csharp
var success = spyQueue.Remove("James Bond", out var removedSpy, out var removedPriority);
```

This is because the removal might fail - for example if you had a typo in the element that you are trying to remove, in which case the element to remove does not exist. In that scenario `success` would return `false`.

Happy hacking!