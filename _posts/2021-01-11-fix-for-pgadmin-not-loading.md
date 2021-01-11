---
layout: post
title: Fix For pgAdmin Not Loading
date: 2021-01-11 21:03:45 +0300
categories: 
    - PostgreSQL
---
Are you attempting to open the pgAdmin web console and it appears to be loading endlessly?

Are you seeing the following screen?

![](../images/2021/01/pgAdmin.png)

The problem is the registry association of .js files is broken.

Open this key

`Computer\HKEY_CLASSES_ROOT\.js`

![](../images/2021/01/JavaScript.png)

If the Content Type here is `text/plaintext` or anything else, double click and change it to `text/javascript`.

![](../images/2021/01/EditKey.png)

Then shut down the server and start it again.

![](../images/2021/01/Shutdown.png)

The web console should now load correctly.

Happy hacking!

