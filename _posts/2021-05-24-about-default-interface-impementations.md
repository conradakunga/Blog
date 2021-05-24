---
layout: post
title: About Default Interface Impementations
date: 2021-05-24 13:12:59 +0300
categories:
    - C#
---
Default interface implementations were introduced in [C# 8](https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-8). Essentially these are interface declarations with bodies.

Where might you use these?

Take this interface:

```csharp
interface IAnimal
{
    string Name { get; }
    void MakeSound();
}
```
  
We can implement this interface with two classes:

A `Dog`;

```csharp
public class Dog : IAnimal
{
    public string Name => "Dog";
    public void MakeSound() => Console.WriteLine("Woof");
}
```

and a `Cat`;

```csharp
public class Cat : IAnimal
{
    public string Name => "Cat";
    public void MakeSound() => Console.WriteLine("Woof");
}
```

We can then use these in a simple application:

```csharp
void Main()
{
    var dog = new Dog();
    dog.MakeSound();
    
    var cat = new Cat();
    cat.MakeSound();
}
```

The console will print as follows:

```plaintext
Woof
Meow
```

Imagine after implementing a bunch of animals, you realized your interface is missing a method. So you add it.

```csharp
interface IAnimal
{
    string Name { get; }
    void MakeSound();
    void Introduce();
}
```

If we try and build the project now, we get the following errors:

```plaintext
C:\Projects\BlogCode\DefaultInterface\Cat.cs(5,24): error CS0535: 'Cat' does not implement interface member 'IAnimal.Introduce()' [C:\Projects\BlogCode\DefaultInterface\DefaultInterface.csproj]
C:\Projects\BlogCode\DefaultInterface\Dog.cs(5,24): error CS0535: 'Dog' does not implement interface member 'IAnimal.Introduce()' [C:\Projects\BlogCode\DefaultInterface\DefaultInterface.csproj]
```

The solution to this problem is to add a default implementation to the new method. Like so:

```csharp
void Introduce() => Console.WriteLine("Hello");
```

If we try to build, this time it succeeds.

However, there are a few things to be aware of.

The new method is defined at **interface** level, and is not available to the **concrete** implementation.

This is to say you cannot do this:

```csharp
var dog = new Dog();
dog.MakeSound();
dog.Introduce(); // <-- this is not available
```

If you really want to invoke it, there are two ways:

#### 1. Cast to the interface
   
You can cast the object to the underlying interface and then invoke the method on that:

```csharp
var dog = new Dog();
dog.MakeSound();
((IAnimal)dog).Introduce();
```

#### 2. Use the interface, not the concrete type

Rather than use the concrete type to manipulate the object, use the interface instead.

```csharp
IAnimal cat = new Cat();
cat.MakeSound();
cat.Introduce();
```

If you want a custom implementation of the method, you can provide your own implementation.

```csharp
public class Mouse : IAnimal
{
    public string Name => "Mouse";
    public void MakeSound() => Console.WriteLine("Squeak");
    public void Introduce() => Console.WriteLine("Squeak! I am a mouse");
}
```

This can be invoked either as the interface:

```csharp
IAnimal mouse = new Mouse();
mouse.MakeSound();
mouse.Introduce();
```

or as the concrete type

```csharp
var mouse = new Mouse();
mouse.MakeSound();
mouse.Introduce();
```

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2021-05-24%20-%20Default%20Interface%20Implementation).

Happy hacking!