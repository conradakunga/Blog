---
layout: post
title: Sending Email In C# & .NET - Part 16 - Testing SMTP Locally Using Mailpit
date: 2025-08-31 00:00:01 +0300
categories:
    - C#
    - .NET
    - Email
---

This is part 16 of a series on sending Email

- [Sending Email in C# & .NET - Part 1 - Introduction]({% post_url 2025-07-17-sending-email-in-c-net-part-1-introduction %})
- [Sending Email in C# & .NET - Part 2 - Delivery]({% post_url 2025-07-18-sending-email-in-c-net-part-2-delivery %})
- [Sending Email in C# & .NET - Part 3 - Using Gmail]({% post_url 2025-07-19-sending-email-in-c-net-part-3-using-gmail %})
- [Sending Email In C# & .NET - Part 4 - Using Office 365 & MS Graph API]({% post_url 2025-07-20-sending-email-in-c-net-part-4-using-office-365-ms-graph-api %})
- [Sending Email In C# & .NET - Part 5 - Using Google Cloud API]({% post_url 2025-07-21-sending-email-in-c-net-part-5-using-google-cloud-api %})
- [Sending Email In C# & .NET - Part 6 - Testing SMTP Locally  Using PaperCut]({% post_url 2025-07-22-sending-email-in-c-net-part-6-testing-smtp-locally-using-papercut %})
- [Sending Email In C# & .NET - Part 7 - Sending Inline Images Using SMTP]({% post_url 2025-07-26-sending-email-in-c-net-part-7-sending-inline-images-using-smtp %})
- [Sending Email In C# & .NET - Part 8 - Sending HTML Email Using SMTP]({% post_url 2025-07-27-sending-email-in-c-net-part-8-sending-html-email-using-smtp %})
- [Sending Email In C# & .NET - Part 9 - Sending Multiple Format Email Using SMTP]({% post_url 2025-07-28-sending-email-in-c-net-part-9-sending-multiple-format-email-using-smtp %})
- [Sending Email In C# & .NET - Part 10 - Sending Plain Text Email Using MailKit]({% post_url 2025-08-25-sending-email-in-c-net-part-10-sending-plain-text-email-using-mailkit %})
- [Sending Email In C# & .NET - Part 11 - Sending HTML Email Using MailKit]({% post_url 2025-08-26-sending-email-in-c-net-part-11-sending-html-email-using-mailkit %})
- [Sending Email In C# & .NET - Part 12 - Sending Email With Attachments Using MailKit]({% post_url 2025-08-27-sending-email-in-c-net-part-12-sending-email-with-attachments-using-mailkit %}) 
- [Sending Email In C# & .NET - Part 13 - Sending Email With Inline Attachments Using MailKit]({% post_url 2025-08-28-sending-email-in-c-net-part-13-sending-email-with-inline-attachments-using-mailkit %})
- [Sending Email In C# & .NET - Part 14 - Sending Multiple Format Email Using MailKit]({ post_url 2025-08-29-sending-email-in-c-net-part-14-sending-multiple-format-email-using-mailkit })
- [Sending Email In C# & .NET - Part 15 - Sending Calendar Invites Using MailKit]({% post_url 2025-08-30-sending-email-in-c-net-part-15-sending-calendar-invites-using-mailkit %})
- **Sending Email In C# & .NET - Part 16 - Testing SMTP Locally Using Mailpit (This post)**

In a past post in this series, "[Sending Email In C# & .NET - Part 6 - Testing SMTP Locally Using PaperCut]({% post_url 2025-07-22-sending-email-in-c-net-part-6-testing-smtp-locally-using-papercut %})", we discussed how to use [PaperCut](https://github.com/ChangemakerStudios/Papercut-SMTP) as a local SMTP server to make it easier to test sending and visualizing sent email.

By this, I mean the ability for your application to send **real emails**, but to have something **intercept** them and allow you to **view and inspect them**, without risking the actual delivery of the email.

I have used this tool for many years, and it has proven to be very useful.

I have recently come across a tool that, I feel, is even better - [Mailpit](https://mailpit.axllent.org/).

It works in exactly the same way, except that it uses **different default ports**. Which, naturally, you can change.

You can [install](https://mailpit.axllent.org/docs/install/) it on your development environment (or anywhere, really), or you can use it as a Docker](https://www.docker.com/) container.

Without hesitation, I recommend the latter.

```bash
docker run -d --name mailpit -p 25:1025 -p 8080:8025 axllent/mailpit
```

Here, the container will use port `25` as the SMTP port and `8080` as the port for the mail client, which is what I used to use for **PaperCut**.

Everything should work seamlessly.

Why am I switching to this over **PaperCut** for testing email sending? A number of reasons.

1. Ability to **persist** email (useful for multi-session development and debugging)
2. Email is **searchable**
3. The [Docker](https://www.docker.com/) image is only **39.5 MB**, as opposed to PaperCut's **269 MB** (Though in the larger scheme of things, does the size really matter for a one-off download?)

Note: I am making comparisons here against the **PaperCut** **web UI**, not the **desktop application**.

In addition to this, there are a number of **UI improvements**

## Message Notifications

When email is delivered, you get a **notification** (browser-generated)

![MailpitNotification](../images/2025/08/MailpitNotification.png)

## Cleaner, Polished Interface

The interface is cleaner and a lot more polished than the web email client for PaperCut.

![MailpitInbox](../images/2025/08/MailpitInbox.png)

## Search Functionality

You can **search** your delivered email.

![MailpitSearch](../images/2025/08/MailpitSearch.png)

## Attachments Indicator

When viewing your inbox, there is an indicator for an email with **attachments**.

![MailpitAttachment](../images/2025/08/MailpitAttachment.png)

## Delete All Emails

You can **delete all** your email with one click.

![MailpitDeleteAll](../images/2025/08/MailpitDeleteAll.png)

## HTML Source Viewer

You can view the **HTML source** of the generated email

![MailpitHtmlSource](../images/2025/08/MailpitHtmlSource.png)

## HTML Check

Building on the ability to view source, Mailpit can also verify the **compatibility** of the HTML against modern viewers.

![MailpitHtmlCheck](../images/2025/08/MailpitHtmlCheck.png)

## Headers Viewer

There is a clean viewer for all the email **headers**.

![MailpitHeaders](../images/2025/08/MailpitHeaders.png)

## Raw Message Viewer

You can also view the entirety of the email in its **raw source** format.

![MailpitRaw](../images/2025/08/MailpitRaw.png)

## Link Check

Mailpit has functionality to allow you to **verify any URL links** within the email.

![MailpitCheckButton](../images/2025/08/MailpitCheckButton.png)

Clicking the button will verify the links.

![MailpitCheckResults](../images/2025/08/MailpitCheckResults.png)

You can also configure Mailpit to **auto-check** all links on opened emails. Naturally there are some security and web traffic implications to turning this on.

![MailpitAutocheck](../images/2025/08/MailpitAutocheck.png)

## Inline Image Counter

Mailpit has a counter that shows the **number of any inline images**.

![MailpitInlibe](../images/2025/08/MailpitInlibe.png)

## Attachments Counter

Mailpit has a counter that shows the number of any **attachments**.

![MailpitAttachment](../images/2025/08/MailpitAttachment.png)

## Device Viewer

You can also visualize how your email will **appear in different devices**.

### Computer

![MailpitDesktop](../images/2025/08/MailpitDesktop.png)

### Tablet

![MailpitTablet](../images/2025/08/MailpitTablet.png)

### Phone

![MailpitPhone](../images/2025/08/MailpitPhone.png)

## Download Any Aspect Of The Email

You can **download** any aspect of the email.

![MailpitDownload](../images/2025/08/MailpitDownload.png)

## Mark As Unread

You can **mark email as unread**.

![MailpitUnread](../images/2025/08/MailpitUnread.png)

**PaperCut** served me well, but time to move on to a more capable replacement.

**Fare thee well, PaperCut.**

Happy hacking!
