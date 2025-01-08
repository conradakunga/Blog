---
layout: post
title: Dependency Injection In C# & .NET Part 8 - Types Of Dependency Injection
date: 2025-01-07 22:48:13 +0300
categories:
    - C#
    - .NET
    - Architecture
    - Domain Design
---

This is Part 8 of a series on dependency injection.

- [Dependency Injection In C# & .NET Part 1 - Introduction & Basic Implementation]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation %})
- [Dependency Injection In C# & .NET Part 2 - Making Implementations Swappable]({% post_url 2025-01-01-dependency-injection-in-c-net-part-2-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 3 - Making Implementations Pluggable]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 4 - Making Implementations Hot-Pluggable]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %})
- [Dependency Injection In C# & .NET Part 5 - Making All Implementations Available]({% post_url 2025-01-04-dependency-injection-in-c-net-part-5-making-all-services-available %})
- [Dependency Injection In C# & .NET Part 6 - Implementation Testing]({% post_url 2025-01-05-dependency-injection-in-c-net-part-6-implementation-testing %})
- [Dependency Injection In C# & .NET Part 7 - Integration Testing]({% post_url 2025-01-06-dependency-injection-in-c-net-part-7-integration-testing %})
- **Dependency Injection In C# & .NET Part 8 - Types Of Dependency Injection (this post)**

 In our [last post,]({% post_url 2025-01-06-dependency-injection-in-c-net-part-7-integration-testing %}) we looked at how to leverage dependency injection for testing. In this post, we will look at the three different types of dependency injection.

### Constructor Injection

The first type is constructor injection. Here,  the dependency is passed through the constructor during object creation. This is generally the most common type, and throughout our series of posts, this is, in fact, the type we used.

Passing the dependency through the constructor has the following implications:

1. The dependency is **mandatory**
2. The dependency is typically **immutable**
2. The dependency is **immediately available** after the object has been instantiated

For example, let us say we want to create a `GeneralAlertSenderAlpha and inject an `AlertSender` through the constructor.

Our class would look like this:

```c#
public class GeneralAlertSenderAlpha
{
    private readonly IAlertSender _alertSender;

    public GeneralAlertSenderAlpha(IAlertSender alertSender)
    {
        _alertSender = alertSender;
    }

    public async Task<string> SendAlert(string title, string message)
    {
        return await _alertSender.SendAlert(new GeneralAlert(title, message));
    }
}
```

And we would instantiate it like this:

```c#
var sender = new GeneralAlertSenderAlpha(zohoAlertSender);
var result = await sender.SendAlert(genericAlert.Title, genericAlert.Message);
```

As indicated earlier:

1. You must supply an `AlertSender` during the **instantiation** of this object
2. Once you have supplied the `AlertSender`, you (generally) **cannot change it**

The benefits of this type of injection are:

1. The class is **easy to test**
2. The requirements are **explicit**
3. By reading the code, it is easy to understand **how to instantiate the class and how it works**

The main drawbacks  are:

1. When there are many types to be injected, the constructor can become very **unwieldy and verbose**
2. Additionally, when there are many injected types, the object can be **expensive to instantiate**

### Property Injection

This type of injection is also called Setter injection.

In this type, dependencies are provided via **public properties** after the object has been instantiated.

```c#
public class GeneralAlertSenderBeta
{
    public IAlertSender? AlertSender { get; set; }

    public async Task<string> SendAlert(string title, string message)
    {
        if (AlertSender is null)
            throw new Exception("AlertSender is mandatory!");
        return await AlertSender!.SendAlert(new GeneralAlert(title, message));
    }
}
```

Passing a dependency as a property has the following implications:

1. Their instantiation can be **deferred** until they are needed after the construction of the object
2. They can be **swapped out** when needed during the lifetime of the class

We can implement this as follows:

```c#
public class GeneralAlertSenderBeta
{
    public IAlertSender? AlertSender { get; set; }

    public async Task<string> SendAlert(string title, string message)
    {
        if (AlertSender is null)
            throw new Exception("AlertSender is mandatory!");
        return await AlertSender!.SendAlert(new GeneralAlert(title, message));
    }
}
```

We can then use it as follows:

```c#
// Set the sender
senderBeta.AlertSender = zohoAlertSender;
var betaResult = await senderBeta.SendAlert(genericAlert.Title, genericAlert.Message);
// Reset the sender
senderBeta.AlertSender = office365AlertSender;
betaResult = await senderBeta.SendAlert(genericAlert.Title, genericAlert.Message);

```

Benefits:

1. Object **construction is cheap**, as the dependencies are not needed upfront
2. The dependencies can be swapped out **after** object construction
3. The dependencies **do not need to be known up front**
4. Once set, the dependency can be **reused**

Drawbacks:

1. It is easy to **forget to set them before usage**, and therefore, the code must check that they are instantiated first before use
2. Testing is a bit more **complicated**

### Method Injection

The final type is known as **method injection**. Here, the dependency is passed to the **method that requires its use**.

The implications of this are as follows:

1. The dependency is injected **during its invocation**, together with any (if required) parameters
2. The object (generally) has **no access to the inner state** of the dependency.

It is implemented as follows:

```c#
public class GeneralAlertSenderCharlie
{
    public async Task<string> SendAlert(IAlertSender alertSender, string title, string message)
    {
        return await alertSender.SendAlert(new GeneralAlert(title, message));
    }
}
```

And is used as follows:

```c#
// Create the charlie result
var senderCharlie = new GeneralAlertSenderCharlie();
// Send using Zoho
var charlieResult = await senderCharlie.SendAlert(zohoAlertSender, genericAlert.Title, genericAlert.Message);
// Send using Office
charlieResult = await senderCharlie.SendAlert(office365AlertSender, genericAlert.Title, genericAlert.Message);
    
```

Benefits:

1. Objects and their dependencies are completely **decoupled**
2. **Different dependencies** can be used at the point of invocation during the lifetime of the class

Drawbacks:

1. Testing is more **complicated**
2. The fact that the dependency can be mutated elsewhere makes **behaviour difficult to predict**.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/Mailer). *The source code builds from first principles as outlined in this series of posts with different versions of the API demonstrating the improvements.*

Happy hacking!