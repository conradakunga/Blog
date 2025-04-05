---
layout: post
title: AwesomeAssertions - Drop-In Replacement For FluentAssertions
date: 2025-04-04 05:57:37 +0300
categories:
    - Testing
    - FluentAssertions
    - StarLibrary
---

I have long used the [FluentAssertions](https://fluentassertions.com/) library to make my test code easier to **read** (and **write**). Recently, the authors converted the library to a commercial license (**which is 100% in order**), but at a [price point I found objectionable]({% post_url 2025-01-22-fluent-assertions-a-pragmatic-roadmap-to-what-next %}) for teams.

Checking today, I see there has been a concession in the form of a **small business license**.

![XceedSmallBusiness](../images/2025/04/XceedSmallBusiness.png)

In the short period when alternatives like Shouldly were candidates for replacement, an even better alternative has emerged.

Thanks to the power of the community and open-source software, the code was forked into a new repository - [AwesomeAssertions](https://awesomeassertions.org). This is a **drop-in replacement** that preserves the same **namespaces** and **type names**.

Another reason I prefer this is that they have also forked and published a corresponding [analyzer](https://github.com/AwesomeAssertions/AwesomeAssertions.analyzers) that can help you write better assertions.

### TLDR

**`AwesomeAssertions` is a drop-in replacement for `FluentAssertions`.**

Happy hacking!
