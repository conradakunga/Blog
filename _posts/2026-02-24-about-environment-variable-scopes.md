---
layout: post
title: About Environment Variable Scopes
date: 2026-02-24 16:52:28 +0300
categories:
    - Operating Systems
---

The past two posts, "How To Read Environment Variables In C# & .NET" and "How To Read Environment Variables In PowerShell", have looked at how to read environment variables.

It is important to point out that environment variables are, in fact, **scoped** to three levels:

1. **Global** (machine) level - accessible to all users and all processes running on the **machine**. 
2. **User** level -  accessible by all processes initiated by the current **user**
3. **Process** level - accessible only within the **current** process.

This is important to understand when it comes to setting and reading environment variables.

A **machine-level** environment variable is the same for **all users on the machine**, and, in fact, requires administrative rights to set and modify. These are useful for things like the [PATH](https://en.wikipedia.org/wiki/PATH_(variable)).

**User-level** environment variables are local to the **current user**, meaning any processes launched by the user can access them. These are useful for things like API keys.

**Process-level** environment variables are local to the **current proces**s and are destroyed once the process terminates.

When designing your applications and needing a way to **share data** between users or processes, these considerations should be taken into account.

### TLDR

**Environment variables are scoped per *machine*, *user*, and *process*.**

Happy hacking!
