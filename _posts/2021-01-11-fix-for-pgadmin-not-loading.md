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

Launch the registry editor [Regedit](https://support.microsoft.com/en-us/windows/how-to-open-registry-editor-in-windows-10-deab38e6-91d6-e0aa-4b7c-8878d9e07b11) and navigate to this key

`Computer\HKEY_CLASSES_ROOT\.js`

![](../images/2021/01/JavaScript.png)

If the Content Type here is `text/plaintext` or anything else, double click and change it to `text/javascript`.

![](../images/2021/01/EditKey.png)

Then shut down the server and start it again.

![](../images/2021/01/Shutdown.png)

The web console should now load correctly.

Happy hacking!

