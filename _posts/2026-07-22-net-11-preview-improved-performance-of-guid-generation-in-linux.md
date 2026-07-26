---
layout: post
title: .NET 11 Preview - Improved Performance of Guid Generation In Linux
date: 2026-07-22 16:03:10 +0300
categories:
    - C#
    - .NET
    - Performance
---

Yesterday's post, [How to Benchmark Performance Against Preview Versions of .NET]({% post_url 2026-07-22-how-to-benchmark-against-preview-versions-of-net %}), showed you how to compare performance of .NET libraries across pre-release .NET versions with the [BenchmarkDotNet](https://benchmarkdotnet.org/) library.

In it, we showed that here is a **performance improvement for Guid generation in .NET 11 on Linux**, up to **20%** faster.

### TLDR

**`Guid.NewGuid()` is up to 20% faster in .NET 11 on Linux.**
