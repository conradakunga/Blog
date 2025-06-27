---
layout: post
title: Correctly Formatting Code Samples in Jekyll
date: 2025-06-28 00:00:21 +0300
categories:
    - Jekyll
---

I was recently reviewing a post I'd written previously, "[Tip - Quickly Upgrade Docker Containers]({% post_url 2025-03-09-tip-quickly-upgrade-docker-containers %})," when I noticed something.

Some code samples are being **displayed incorrectly**.

![wrongOne](../images/2025/06/wrongOne.png)

and

![wrongTwo](../images/2025/06/wrongTwo.png)

Which was strange.

As a reminder, I am using [Jekyll]({% post_url 2020-05-25-goodbye-wordpress %}) to write and manage this blog.

Because the source code is definitely **correct**.

![sourceOne](../images/2025/06/sourceOne.png)

and

![sourceTwo](../images/2025/06/sourceTwo.png)

The problem is the **double curly braces**, which [Jekyll](https://jekyllrb.com/) interprets as interpolation markers.

`Jekyll` actually warns you about this when you build the site.

![jekyllWarn](../images/2025/06/jekyllWarn.png)

The solution to this is to wrap your code in two tags: `raw` and `endraw`. Like this:

![correctOne](../images/2025/06/correctOne.png)

and

![correctTwo](../images/2025/06/correctTwo.png)

The site will now render correctly.

![finalOne](../images/2025/06/finalOne.png)

and

![finalTwo](../images/2025/06/finalTwo.png)

You can view the updated post [here]({% post_url 2025-03-09-tip-quickly-upgrade-docker-containers %})
