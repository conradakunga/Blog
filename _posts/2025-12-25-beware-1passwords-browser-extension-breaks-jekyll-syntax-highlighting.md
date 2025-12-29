---
layout: post
title: BEWARE - 1Password's Browser Extension Breaks Jekyll Syntax Highlighting
date: 2025-12-25 14:22:16 +0300
categories:
    - Jekyll
    - Chrome	
    - Edge
    - Firefox
---

Recently, I opened one of my [recent blog posts]({% post_url 2025-12-24-overriding-endpoint-authorization-when-using-a-single-aspnet-carter-module-in-c-net %}) and noticed something curious - the **syntax highlighting for code samples was gone**.

![nosyntaxone](../images/2025/12/nosyntaxone.png)

Perhaps it was an isolated incident. I tried [another post]({% post_url 2025-12-23-overriding-endpoint-authorization-when-using-multiple-aspnet-carter-modules-in-c-net %}):

![nosyntaxtwo](../images/2025/12/nosyntaxtwo.png)

Same problem.

Strange.

I tried with a different **browser**, [Firefox](https://www.firefox.com/).

![syntaxfirefox](../images/2025/12/syntaxfirefox.png)

Works ok.

Tried with yet another browser, [Microsoft Edge](https://www.microsoft.com/en-us/edge).

![nosyntaxedge](../images/2025/12/nosyntaxedge.png)

What do these three scenarious have in common?

- **Edge** and **Chrome** are based on the [Chromium](https://www.chromium.org/Home/) engine.
- **Firefox** has its own rendering engine.

It could also be that the problem was [Jekyll](https://jekyllrb.com/) itself, but I dismissed that because I have been using the same version of **Jekyll** for quite some time, and I know for a fact that at some point it worked well.

I looked even closer at the browsers.

Turns out the other thing they had in common was that **Edge** and **Chrome** both had the [1Password](https://1password.com/) [browser extension](https://1password.com/downloads/browser-extension) installed and turned on, but Firefox didn't.

When I **disabled** the extension in **Chrome**:

![chrome1password](../images/2025/12/chrome1password.png)

The page rendered correctly:

![correctrender](../images/2025/12/correctrender.png)

The same when I **disabled** the extension for **Edge**:

![edge1password](../images/2025/12/edge1password.png)

The page also loaded correctly:

![edgeok](../images/2025/12/edgeok.png)

I was curious what would happen if I installed and **enabled** the extension on **Firefox**:

![firefox1Password](../images/2025/12/firefox1Password.png)

The page formatting broke:

![firefoxbroken](../images/2025/12/firefoxbroken.png)

But when I turned it off:

![firefoxoff](../images/2025/12/firefoxoff.png)

All was well.

![firefoxok](../images/2025/12/firefoxok.png)

The versions tested were as follows:

| Browser | Version        | 1Password Version |
| ------- | -------------- | ----------------- |
| Firefox | 146.0.1        | 8.11.23.2         |
| Edge    | 143.0.3650.96  | 8.11.2            |
| Chrome  | 143.0.7499.170 | 8.11.22.27        |

### TLDR

**The 1Password extension breaks Jekyll's syntax highlighting.**

Happy hacking!
