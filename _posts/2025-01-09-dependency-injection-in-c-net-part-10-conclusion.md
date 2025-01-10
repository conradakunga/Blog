---
layout: post
title: Dependency Injection In C# & .NET Part 10 - Conclusion
date: 2025-01-09 04:44:05 +0300
categories:
    - C#
    - .NET
    - Architecture
    - Domain Design
---

This is Part 10 of a series on dependency injection.

- [Dependency Injection In C# & .NET Part 1 - Introduction & Basic Implementation]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation %})
- [Dependency Injection In C# & .NET Part 2 - Making Implementations Swappable]({% post_url 2025-01-01-dependency-injection-in-c-net-part-2-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 3 - Making Implementations Pluggable]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %})
- [Dependency Injection In C# & .NET Part 4 - Making Implementations Hot-Pluggable]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %})
- [Dependency Injection In C# & .NET Part 5 - Making All Implementations Available]({% post_url 2025-01-04-dependency-injection-in-c-net-part-5-making-all-services-available %})
- [Dependency Injection In C# & .NET Part 6 - Implementation Testing]({% post_url 2025-01-05-dependency-injection-in-c-net-part-6-implementation-testing %})
- [Dependency Injection In C# & .NET Part 7 - Integration Testing]({% post_url 2025-01-06-dependency-injection-in-c-net-part-7-integration-testing %})
- [Dependency Injection In C# & .NET Part 8 - Types Of Dependency Injection]({% post_url 2025-01-07-dependency-injection-in-c-net-part-8-types-of-depedency-injection %})
- [Dependency Injection In C# & .NET Part 9 - Life Cycles]({% post_url 2025-01-08-dependency-injection-in-c-net-part-9-life-cycles %})
- **Dependency Injection In C# & .NET Part 10 - Conclusion (this post)**

In our [last post]({% post_url 2025-01-08-dependency-injection-in-c-net-part-9-life-cycles %}) we looked at the various dependency injection life cycles.

Over the last 10 days, we have looked at dependency injection as a concept and its implementation on the .NET platform.

On [Day 1]({% post_url 2024-12-31-dependency-injection-in-c-net-introduction-and-basic-implementation  %}), we looked at a typical problem of instantiating a class, the `GmailAlertSender` that implements some business logic.  The major issue was the API needed to know **how** to instantiate one, what **parameters** were required, and **how to fetch them**. We then looked at how dependency injection could be used to solve the problem of **transparently instantiating and injecting** a `GmailAlertSender`. We also looked at how the .NET platform uses dependency injection to deal with the problem of settings.

On [Day 2]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %}), we looked at how we can implement logic for more than one `AlertSender`, and how we can swap the injection at **compile time** in reaction to requirements from the business.

On [Day 3]({% post_url 2025-01-02-dependency-injection-in-c-net-part-3-making-implementations-pluggable %}), we looked at how we can implement logic that by changing the configuration **settings file**, the application can change which implementation of the `AlertSender` it will use on startup, thus avoiding having to change the application code to achieve this.

On [Day 4]({% post_url 2025-01-03-dependency-injection-in-c-net-part-4-making-implementations-hot-pluggable %}), we look at how we can **dynamically** change the implementation of `AlertSender` in use by changing the settings but **without requiring a restart** of the application.

On [Day 5]({% post_url 2025-01-04-dependency-injection-in-c-net-part-5-making-all-services-available %}), we looked at how we can use dependency injection to have **all the implementations available** so that we can decide which to use depending on business logic.

On [Day 6]({% post_url 2025-01-05-dependency-injection-in-c-net-part-6-implementation-testing %}), we looked at how we can leverage dependency injection, interfaces and strong typing to **test** our implementations using **fakes**.

On [Day 7]({% post_url 2025-01-06-dependency-injection-in-c-net-part-7-integration-testing %}), we looked at how we can build end-to-end **integration tests using the power of dependency injection to control the spin-up of the API, configuration of required services, and writing assertions to test that our API is functioning correctly.

On [Day 8]({% post_url 2025-01-07-dependency-injection-in-c-net-part-8-types-of-depedency-injection %}), we looked at the **types** of dependency injection - **constructor** injection, **property** injection and **method** injection.

Finally, on [Day 9]({% post_url 2025-01-08-dependency-injection-in-c-net-part-9-life-cycles %}), we looked at the various dependency injection **life cycles** - **singleton**, **scoped** and **transient** - how they work, their pros and their cons.

**Dependency injection is an important concept that a modern software developer requires to understand and implement, regardless of programming language.**

All the code from this series is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/Mailer). *The source code builds from first principles as outlined in this series of posts with different versions of the API demonstrating the improvements.*

Happy hacking!
