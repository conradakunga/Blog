---
layout: post
title: Awesome Assertions Update - Namespace Change In Version 9
date: 2025-06-25 05:44:18 +0300
categories:
    - Testing
    - FluentAssertions
---

I have for many years been a huge proponent of the excellent [FluentAssertions](https://fluentassertions.com/) library, the work of [Dennis Doomen](https://www.dennisdoomen.com/).

There have been [developments around the licensing](https://xceed.com/fluent-assertions-faq/) of that library that I [discussed here]({% post_url 2025-01-16-there-be-dragons-fluentassertions-8-new-licensing%}). I also talked about how I found those changes [objectionable]({% post_url 2025-01-22-fluent-assertions-a-pragmatic-roadmap-to-what-next %}), and looked at alternatives, finally  [settling on]({% post_url 2025-04-04-awesomeassertions-drop-in-replacement-for-fluentassertions %}) the library [AwesomeAssertions](https://www.nuget.org/profiles/AwesomeAssertions).

This is a [community driven fork](https://awesomeassertions.org/about/) was a drop in replacement, and you did not need to change your code at all. It also, very importantly, has [very good documentation](https://awesomeassertions.org/introduction), based on the original work by Dennis.

Until recently, when there was a **material** change - the **renaming** of the namespaces.

Previously, the namespace continued to be `FluentAssertions`.

As of [version 9](https://github.com/AwesomeAssertions/AwesomeAssertions/releases/tag/9.0.0), it is now `AwesomeAssertions`.

The rationale is explained [here](https://awesomeassertions.org/upgradingtov9), and this is the relevant GitHub [issue](https://github.com/AwesomeAssertions/AwesomeAssertions/issues/120).

Making this upgrade will **break your compile**, and you will need to update your code accordingly, which is a trivial, single-line change.

![AwesomeAssertionsNamespace](../images/2025/06/AwesomeAssertionsNamespace.png)

### TLDR

The latest version of `AwesomeAssertions` has a breaking change - renaming of the namespace from `FluentAssertions` to `AwesomeAssertions`.
