---
layout: post
title: Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 1 - Introduction
date: 2025-04-17 19:04:25 +0300
categories:
    - .NET
    - C#
    - OpenSource
    - Design
---

This is Part 1 of a series on Designing, Building & Packaging A Scalable, Testable .NET Open Source Component.

- **Building & Packaging A Scalable, Testable .NET Open Source Component - Part 1 - Introduction (This Post)**
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 2 - Basic Requirements]({% post_url 2025-04-18-designing-building-packaging-a-scalable-testable-net-open-source-component-part-2-basic-requirements %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 3 - Project Setup]({% post_url 2025-04-19-designing-building-packaging-a-scalable-testable-net-open-source-component-part-3-project-setup %})
- [Designing, Building & Packaging A Scalable, Testable .NET Open Source Component - Part 4 - Types & Contracts]({% post_url 2025-04-20-designing-building-packaging-a-scalable-testable-net-open-source-component-part-4-types-contracts %})

I am working on a pet project that requires the **uploading and storage of files before processing** them. As I was doing so I realized that this is a problem **I keep having**, and chances are **somebody else is too**.

So this is an excellent opportunity to stitch together a lot of the things we have been discussing over the last 6 months.

We will therefore walk though the following:

- Articulating our **requirements**
- Preparing a **design**
- **Building** the component
- **Testing** the component
- **Packaging** the component
- **Deploying** the component
- Iterration
- **Documentation**

This is something I will build in public, with the source code available to anyone interested in [GitHub](https://github.com/). I will do my best to document everything for clarity, as this is an opportunity to not only teach, but learn myself.

Topics I expect to cover in the course of this series are:

- Testing
    - Unit testing
    - Mocking
    - Integration testing
- Classes & Types
    - Interfaces
    - Records & classes
    - Enums
- I/O
    - File Streams
    - Memory Streams
    - Bytes & byte arrays
    - Compression
- Dependency injection
- Database access & storage
    - SQL Server
    - PostgreSQL
- File system access & storage
- Cloud (Blob) storage and access
    - Azure
    - Amazon
- Documentation
    - OpenAI
    - MarkDown
    - XML Documentation
- Continuous Integration
- Logging

As usual, I will **assume no prior knowledge** (other than basic programming experience - how to write a class, and how to compile your code.)

**This should be fun!**

### TLDR

**I am going to publicly build a very simple open source component to manage uploaded files.**

Happy hacking!
