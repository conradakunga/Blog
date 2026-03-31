---
layout: post
title: Code Housekeeping - Part 6 - Email Address Validation - Try Not To
date: 2026-02-17 23:01:24 +0300
categories:
    - C#
    - Languages
    - CodeHouseKeeping
    - Code
    - Quality
    - Database
---

This is **Part 6** of the **CodeHousekeeping Series**.

**Code Housekeeping** refers to general rules of thumb that make code easier to **read**, **digest**, and **modify** for other developers, **yourself** included.

Today, we will look at the issue of **email address validation**.

**Every** developer, **myself included**, has tried to be clever and **attempted to validate an email address** with a regular expression.

How hard can it be?

![regex](../images/2026/02/regex.png)

A very comprehensive regex for email is [this one](https://emailregex.com/index.html):

```plaintext
(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])
```

The trouble is that even this does not catch 100% of all valid email addresses, including [many that appear to be invalid that are in fact valid](https://david-gilbertson.medium.com/the-100-correct-way-to-validate-email-addresses-7c4818f24643).

Personally, I **don't bother at all** and let the user enter whatever they want.

If the email is invalid, it will **fail to send**, and the **mail server will respond with the appropriate error**.

My logic is therefore "**did you key in anything?**"

But if **I had** to do it, I would do it this way:

```c#
using System.Net.Mail;

bool IsValid(string email)
{
    try
    {
        var addr = new MailAddress(email);
        return true;
    }
    catch
    {
        return false;
    }
}
```

Here I am using the [MailAddress](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.mailaddress?view=net-10.0) class in the [System.Net.Mail](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail?view=net-10.0) namespace to do the validation for me.

If it fails, an [exception](https://learn.microsoft.com/en-us/dotnet/api/system.exception?view=net-10.0) is thrown, which I **catch** and **discard**.

### TLDR

**Email address validation is a hard problem, and not worth the bother of doing it yourself. But if you need to, don't re-invent the wheel.**

Happy hacking!
