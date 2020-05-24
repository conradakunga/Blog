---
id: 287
title: Using Curl In PowerShell
date: 2020-05-19T19:50:49+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=287
permalink: /2020/05/19/using-curl-in-powershell/
categories:
  - PowerShell
  - Uncategorized
---
A useful tool to have in your toolbelt is an ability to make web requests and retrieve responses from the command line.

There are many tools that can do this for you, my favourite being these two:

  1. [httpie](https://httpie.org/)
  2. [curl](https://curl.haxx.se/)

It is the second that I want to turn my attention to.

Curl is a very popular utility that comes installed in many Linux distributions.

If you use tools like Swagger, it generates examples in curl format

[<img style="display: inline; background-image: none;" title="image" src="images/2020/05/image_thumb-2.png" alt="image" width="1299" height="181" border="0" />](images/2020/05/image-2.png)

If you are developing on Windows, curl is something you will need to install.

On my machine I use the [chocolatey](https://chocolatey.org/) package manager

You can install it using

> choco install curl

Once it installed and you have reloaded the shell you might do the following

> curl google.com

A response will come back as follows

[<img style="display: inline; background-image: none;" title="image" src="images/2020/05/image_thumb-3.png" alt="image" width="1413" height="678" border="0" />](images/2020/05/image-3.png)

You might say to yourself “mission accomplished”

You would be **wrong**.

What has in fact happened here is that curl has **not run at all**!

What has in fact run is the PowerShell cmdlet **Invoke-WebRequest**.

Why? Because out of the box PowerShell has a pre-configured alias for this – **curl**

You can verify this as follows

> get-alias curl

You should see the following

[<img style="display: inline; background-image: none;" title="image" src="images/2020/05/image_thumb-4.png" alt="image" width="1058" height="151" border="0" />](images/2020/05/image-4.png)

So the question is how do we run curl the application?

There are two ways to do it.

The first is to leave PowerShell in no doubt you are referring to an application by providing the extension exe

> curl.exe google.com

[<img style="display: inline; background-image: none;" title="image" src="images/2020/05/image_thumb-5.png" alt="image" width="978" height="181" border="0" />](images/2020/05/image-5.png)

You can see the results are very different because curl has (in my opinion) the sensible default of not providing the headers

This technique works but is very tiresome because you have to keep remembering to provide the extension.

The other (more sensible) solution is to **remove** the curl alias.

You can do this from your profile. Using your favourite text editor, open your profile.

Today we will use Visual Studio Code

In a PowerShell prompt type the following:

> code $profile

Scroll to the bottom (if your profile already has entries and add this line)

> Remove-Item Alias:\curl

[<img style="display: inline; background-image: none;" title="image" src="images/2020/05/image_thumb-6.png" alt="image" width="872" height="98" border="0" />](images/2020/05/image-6.png)

Save the file and then reload the shell – or close and open it again.

Now try and run curl (without the extension)

[<img style="display: inline; background-image: none;" title="image" src="images/2020/05/image_thumb-7.png" alt="image" width="970" height="175" border="0" />](images/2020/05/image-7.png)

This second approach makes this change persistent across PowerShell sessions.

If you just want it temporarily you can run **Remove-Item** in the current session and it will be reset the next time you start the shell.

You can access the code on my [Github](https://github.com/conradakunga/BlogCode/tree/master/19%20May%20-%20Using%20Curl%20in%20PowerShell).

Happy hacking!