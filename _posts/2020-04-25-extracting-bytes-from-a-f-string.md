---
id: 249
title: 'Extracting Bytes From A F# String'
date: 2020-04-25T05:10:52+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=249
permalink: /2020/04/25/extracting-bytes-from-a-f-string/
categories:
  - 'F#'
  - Tips
---
Suppose you need to extract the byte values of a string from F#



An obvious way is to use the Encoding class from System.Text



Like so:



[<img width="731" height="125" title="Bytes 1" style="display: inline; background-image: none;" alt="Bytes 1" src="images/2020/04/Bytes-1_thumb.png" border="0" />](images/2020/04/Bytes-1.png)



An even quicker way to to it natively is as follows:



[<img width="712" height="51" title="Bytes 2" style="display: inline; background-image: none;" alt="Bytes 2" src="images/2020/04/Bytes-2_thumb.png" border="0" />](images/2020/04/Bytes-2.png)



Note the **B** at the end



The code is in my [github](https://github.com/conradakunga/BlogCode/tree/master/25%20April%20-%20F%23%20Bytes)



Happy hacking!