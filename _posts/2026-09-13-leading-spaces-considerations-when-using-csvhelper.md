---
layout: post
title: Leading Spaces Considerations When Using CSVHelper
date: 2026-09-13 16:04:11 +0300
categories:
    - C#
    - .NET
    - StarLibrary
---

In the past, I have discussed my extensive use of the [CSVHelper](https://github.com/joshclose/csvhelper) library, including as recently as yesterday, where I talked about "[Changing the CSV Delimiter with CSVHelper]({% post_url 2026-09-12-changing-the-csv-delimiter-with-csvhelper %})".

In the example, the generated file was this:

| Firstname | Lastname    | DateOfBirth |
| --------- | ----------- | ----------- |
| Vergie    | Nolan       | 12/29/20    |
| Claud     | Bartell     | 3/1/91      |
| Louisa    | Frami       | 11/21/09    |
| Minerva   | Corkery     | 9/13/16     |
| Albina    | Ullrich     | 1/9/77      |
| Damaris   | Carroll     | 8/30/11     |
| Tatyana   | Grant       | 6/2/08      |
| Brook     | Halvorson   | 3/26/15     |
| Veda      | Breitenberg | 5/4/83      |
| Antonina  | Kunze       | 5/26/80     |

And the actual raw text looked like this:

```plaintext
Firstname,Lastname,DateOfBirth
Vergie,Nolan,12/29/2020
Claud,Bartell,03/01/1991
Louisa,Frami,11/21/2009
Minerva,Corkery,09/13/2016
Albina,Ullrich,01/09/1977
Damaris,Carroll,08/30/2011
Tatyana,Grant,06/02/2008
Brook,Halvorson,03/26/2015
Veda,Breitenberg,05/04/1983
Antonina,Kunze,05/26/1980
```

During one run with some sample data, I got this result:

| Firstname | Lastname    | DateOfBirth |
| --------- | ----------- | ----------- |
| Moises    | Schumm      | 2/19/15     |
| Keara     | DuBuque     | 9/4/04      |
| Susie     | Kihn        | 8/11/25     |
| Doris     | Greenholt   | 2/6/00      |
| Lora      | Kovacek     | 11/4/25     |
| Alexander | Stoltenberg | 7/3/26      |
| Marianna  | Haley       | 7/31/17     |
| Rosendo   | Zemlak      | 5/13/78     |
| Maximus   | Leffler     | 6/8/23      |
| Marshall  | Lockman     | 10/15/80    |

Which looks perfectly in order.

However, when I examined the raw text --

```plaintext
Firstname,Lastname,DateOfBirth
"Moises",Schumm,02/19/2015
"Keara",DuBuque,09/04/2004
"Susie",Kihn,08/11/2025
"Doris",Greenholt,02/06/2000
"Lora",Kovacek,11/04/2025
"Alexander",Stoltenberg,07/03/2026
"Marianna",Haley,07/31/2017
" Rosendo",Zemlak,05/13/1978
"Maximus",Leffler,06/08/2023
"Marshall",Lockman,10/15/1980

```

Notice that now there are double quotes around the `Firstname`.

The culprit was not hard to spot:

```plaintext
" Rosendo",Zemlak,05/13/1978
```

There is a **leading space** before **Rosendo**.

In such situations, the library **double quotes the field**.

In fact, **a space appearing anywhere in the data** triggers this behavior.

You will also get this behaviour if there is a **comma** in the **data**, e.g. **it is not a delimiter** in this context.

This is why you should not attempt to **manually read and write** `CSV` files. It is **hard**. You can read the details in the relevant [RFC](https://en.wikipedia.org/wiki/Request_for_Comments), [4180](https://www.rfc-editor.org/info/rfc4180/).

### TLDR

**Double spaces appearing in delimited data is a defensive mechanism to ensure the sanctity of the data in the CSV.**

Happy hacking!
