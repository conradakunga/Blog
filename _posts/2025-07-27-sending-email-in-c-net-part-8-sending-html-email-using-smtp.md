---
layout: post
title: Sending Email In C# & .NET - Part 8 - Sending HTML Email Using SMTP
date: 2025-07-27 23:22:07 +0300
categories:
    - C#
    - .NET
    - Email
---

This is Part 8 of a series on sending email.

- [Sending Email in C# & .NET - Part 1 - Introduction]({% post_url 2025-07-17-sending-email-in-c-net-part-1-introduction %})
- [Sending Email in C# & .NET - Part 2 - Delivery]({% post_url 2025-07-18-sending-email-in-c-net-part-2-delivery %})
- [Sending Email in C# & .NET - Part 3 - Using Gmail]({% post_url 2025-07-19-sending-email-in-c-net-part-3-using-gmail %})
- [Sending Email In C# & .NET - Part 4 - Using Office 365 & MS Graph API]({% post_url 2025-07-20-sending-email-in-c-net-part-4-using-office-365-ms-graph-api %})
- [Sending Email In C# & .NET - Part 5 - Using Google Cloud API]({% post_url 2025-07-21-sending-email-in-c-net-part-5-using-google-cloud-api %})
- [Sending Email In C# & .NET - Part 6 - Testing SMTP Locally  Using PaperCut]({% post_url 2025-07-22-sending-email-in-c-net-part-6-testing-smtp-locally-using-papercut %})
- [Sending Email In C# & .NET - Part 7 - Sending Inline Images Using SMTP]({% post_url 2025-07-26-sending-email-in-c-net-part-7-sending-inline-images-using-smtp %})
- **Sending Email In C# & .NET - Part 8 - Sending HTML Email Using SMTP (This post)**
- [Sending Email In C# & .NET - Part 9 - Sending Multiple Format Email Using SMTP]({% post_url 2025-07-28-sending-email-in-c-net-part-9-sending-multiple-format-email-using-smtp %})
- [Sending Email In C# & .NET - Part 10 - Sending Plain Text Email Using MailKit]({% post_url 2025-08-25-sending-email-in-c-net-part-10-sending-plain-text-email-using-mailkit %})
- [Sending Email In C# & .NET - Part 11 - Sending HTML Email Using MailKit]({% post_url 2025-08-26-sending-email-in-c-net-part-11-sending-html-email-using-mailkit %})
- [Sending Email In C# & .NET - Part 12 - Sending Email With Attachments Using MailKit]({% post_url 2025-08-27-sending-email-in-c-net-part-12-sending-email-with-attachments-using-mailkit %}) 
- [Sending Email In C# & .NET - Part 13 - Sending Email With Inline Attachments Using MailKit]({% post_url 2025-08-28-sending-email-in-c-net-part-13-sending-email-with-inline-attachments-using-mailkit%})
- [Sending Email In C# & .NET - Part 14 - Sending Multiple Format Email Using MailKit]({% post_url 2025-08-29-sending-email-in-c-net-part-14-sending-multiple-format-email-using-mailkit %})
- [Sending Email In C# & .NET - Part 15 - Sending Calendar Invites Using MailKit]({% post_url 2025-08-30-sending-email-in-c-net-part-15-sending-calendar-invites-using-mailkit %})
- [Sending Email In C# & .NET - Part 16 - Testing SMTP Locally Using Mailpit]({% post_url 2025-08-31-sending-email-in-c-net-part-16-testing-smtp-locally-using-mailpit %})

In our last post in the series, [Sending Email In C# & .NET - Part 7 - Sending Inline Images Using SMTP]({% post_url 2025-07-26-sending-email-in-c-net-part-7-sending-inline-images-using-smtp %}), we discussed how to send email with inline images over SMTP.

In this post, we will look at **how to send an [HTML email](https://en.wikipedia.org/wiki/HTML_email)**.

There are two ways to do it:

1. Directly on the [MailMessage](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.mailmessage?view=net-9.0) object
2. Using an [AlternateView](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.alternateview?view=net-9.0).

## Direct HTML

In this scenario, we can set the [IsBodyHTML](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.mailmessage.isbodyhtml?view=net-9.0) property directly on the `MailMessage` object.

```c#
// Setup logging
Log.Logger = new LoggerConfiguration().WriteTo.Console().CreateLogger();

var mail = new MailMessage();
mail.From = new MailAddress("operations@MI5.co.uk", "M");
mail.To.Add(new MailAddress("jbond@MI5.co.uk", "James Bond"));
mail.Subject = "Happy Birthday";
mail.Body = """
            <html><body>
            Good afternoon.
            <br>
            Have a <B>happy birthday</B> today!
            <br>
            <br>
            <i>Warmest regards, M<i/>
            </body></html>
            """;

// Set the body format as HTML
mail.IsBodyHtml = true;

// Create SMTPClient
var smtpClient = new SmtpClient
{
    Host = "localhost",
    Port = 25,
    Credentials = CredentialCache.DefaultNetworkCredentials
};

// Send the email
try
{
    Log.Information("Sending email");
    smtpClient.Send(mail);
    Log.Information("Email sent");
}
catch (Exception ex)
{
    Log.Error(ex, "Error sending email");
}
```

If we send this email, we can view it in PaperCut.

![HTMLMailMessage](../images/2025/07/HTMLMailMessage.png)

You can see here that the email has been rendered as HTML.

## Alternate Views

You can also achieve the same result using an `AlternateView`, which gives you a lot more control in terms of flexibility.

```c#
var mail = new MailMessage();
mail.From = new MailAddress("operations@MI5.co.uk", "M");
mail.To.Add(new MailAddress("jbond@MI5.co.uk", "James Bond"));
mail.Subject = "Happy Birthday James";
const string html = """
                    <html><body>
                    Good afternoon.
                    <br>
                    Have a <B>happy birthday</B> today!
                    <br>
                    <br>
                    <i>Warmest regards, M<i/>
                    </body></html>
                    """;

// AlternateView for HTML
var htmlView = AlternateView.CreateAlternateViewFromString(html, null, MediaTypeNames.Text.Html);

mail.AlternateViews.Add(htmlView);
```

The sent email would be identical.

Why use this way over simply setting the `IsBodyHTML` property?

1. You want to use **multiple formats**
2. You want **inline images**
3. You want full control of the [MIME](https://en.wikipedia.org/wiki/MIME) structure.

## TLDR

**You can send HTML email either by setting the `IsBodyHTML` property of the MailMessage or by using an `AlternateView`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-07-27%20-%20HTML%20Email).

Happy hacking!
