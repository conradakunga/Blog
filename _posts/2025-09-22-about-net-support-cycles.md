---
layout: post
title: About .NET & Support Cycles
date: 2025-09-22 16:41:52 +0300
categories:
    . NET
---

**Every year**,  there is a new release of the latest .NET SDK & runtime, incorporating a year of development, innovation and improvements.

From .NET 5, this has been in November.

The releases are designated either as **STS** (Standard Term Support) or **LTS** (Long Term Support). 

The even numbered versions are **LTS** versions, and the odd numbered versions are **LTS**.

The current situation is as follows:

| Version | Date Released     | Type | End Of Support    |
| ------- | ----------------- | ---- | ----------------- |
| .NET 8  | November 14, 2023 | LTS  | November 10, 2026 |
| .NET 9  | November 12, 2024 | STS  | November 10, 2026 |

This means that **both will be fully supported until November 2026**.

Previously, the **STS** versions had **shorter support cycles**, which created:

1. A **perception** that it was of lower quality
2. A window between versions where the **STS was not supported**

This inadvertently created a **reluctance to use STS versions in production**.

Now, the [STS support period has been increased to 24 months](https://devblogs.microsoft.com/dotnet/dotnet-sts-releases-supported-for-24-months/#comments), which means that STS and LTS versions will be fully supported in sync.

Note, however, that this policy [does not apply to some of the components of the framework](https://dotnet.microsoft.com/en-us/platform/support/policy).

### TLDR

**The support cycle for STS versions has been increased to 24 months.**

Happy hacking!
