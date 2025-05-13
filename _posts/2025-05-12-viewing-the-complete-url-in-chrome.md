---
layout: post
title: Viewing the Complete URL in Chrome
date: 2025-05-12 10:32:04 +0300
categories:
    - UI
    - UX
---

In a [previous post]({% post_url 2020-09-04-chrome-ui-surprises %}), I talked about the surprise that [Google Chrome](https://www.google.com/chrome/) has when you view, copy, and paste a URL.

To recap, the issue is this:

Generally,  the URL in the URL bar will look like this:

![DefaultURL](../images/2025/05/DefaultURL.png)

If, however, you **copy and paste** that URL, it will appear like this:

```plaintext
https://www.conradakunga.com/blog/
```

Which is a **surprise** - what you copied is not what you pasted.

It turns out that it is possible to change this default behavior.

In the View menu, there is a setting `Always Show Full URLs`

![URLBarSetting](../images/2025/05/URLBarSetting.png)

At which point, the URL bar changes:

![NewURL](../images/2025/05/NewURL.png)

Now, I'm not sure if this has always been there, but it's nice to know!

Happy hacking!
