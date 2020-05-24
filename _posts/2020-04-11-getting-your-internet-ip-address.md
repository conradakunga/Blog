---
id: 211
title: Getting Your Internet IP Address
date: 2020-04-11T16:35:47+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=211
permalink: /2020/04/11/getting-your-internet-ip-address/
categories:
  - PowerShell
---
Suppose, for whatever reason, you need to know your ISP assigned IP address.

Generally you’d launch a browser to do this, using a site like [WhatIsMyIP](https://www.whatismyip.com/)

You can get that information using this handy expression:

```powershell
(curl ipinfo.io/io).Content
```

You should get the following, outputting your IP address. This assumes you are connected to the Internet.

![](images/2020/04/IP-Address-1.png)

Curl is of course an alias for **Invoke-WebRequest**

Here we are using the excellent website [ipinfo.io](https://ipinfo.io/) that has a [dedicated web](https://ipinfo.io/ip) page that returns your IP address.

Putting the expression in brackets so that we can access the Content property makes it easier to access the relevant information. 

To get the raw response, execute the following:

```powershell
curl ipinfo.io/ip
```

You should see the folliing:

![](images/2020/04/IP-Address-2.png)

We don’t need everything here – all we need is the content, hence the simplified expression above.

Happy hacking!