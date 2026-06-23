---
layout: post
title: Setting OAUTH Authentication & Authorization At Folder Level In Yaak
date: 2026-06-23 22:44:21 +0300
categories:
    - Yaak
---

I am a recent and happy convert to the API & endpoint testing tool [Yaak,](https://yaak.app/) which has now **replaced** my previous go-to, [Insomnia](https://insomnia.rest/).

As I've mentioned before, both tools were written by the same gentleman, **Greg**. You can read the story [here](https://yaak.app/blog/yet-another-api-client).

In a previous post, "[Automatically Fetching an Identity Server Token with Yaak]({% post_url 2025-12-26-automatically-fetching-an-identity-server-token-with-yaak %})", we looked at how to set up **Yaak** to **automatically fetch** identity server [tokens](https://oauth.net/2/access-tokens/).

However, in that post, we set it up at the **endpoint level**, and it can be very **repetitive**, not to mention **inflexible**, to set that up **repeatedly per endpoint.**

A better approach is to set it up at the **folder** level.

First, create a **folder** that will host your endpoints.

![yaakFolder](../images/2026/06/yaakFolder.png)

Next, right-click the folder to get the context menu.

![yaakFolderMenu](../images/2026/06/yaakFolderMenu.png)

Next, click **Settings**:

![folderSettings](../images/2026/06/folderSettings.png)

Navigate to the **Bearer** menu:

![yaakBearer](../images/2026/06/yaakBearer.png)

Here we provide two things:

1. The **token name** you set up, as [outlined in this post]({% post_url 2025-12-26-automatically-fetching-an-identity-server-token-with-yaak %}).
2. The [prefix](https://medium.com/@kapilkokcha.k/why-do-we-use-bearer-in-api-authentication-9a80db016dbe) `Bearer`

And we're done.

By default, new endpoints will **automatically inherit** this, as indicated by the icon and **explicit message**.

However, if you want to, you can **override** this by clicking on the heading.

![yaakOverride](../images/2026/06/yaakOverride.png)

### TLDR

**You can set identity server authentication and authorization at the folder level, and all endpoints in that folder will inherit this.**

Happy hacking!
