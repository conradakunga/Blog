---
layout: post
title: Sending Email In C# & .NET - Part 1 - Introduction 
date: 2025-07-17 04:55:20 +0300
categories:
    - C#
    - .NET
    - Email
---

This is Part 1 of a series on sending email.

- **Sending Email in C# & .NET  - Part 1 - Introduction (this post)**
- [Sending Email in C# & .NET - Part 2 - Delivery]({% post_url 2025-07-18-sending-email-in-c-net-part-2-delivery %})
- [Sending Email in C# & .NET - Part 3 - Using Gmail]({% post_url 2025-07-19-sending-email-in-c-net-part-3-using-gmail %})
- [Sending Email In C# & .NET. - Part 4 - Using Office 365 & MS Graph API]({% post_url 2025-07-20-sending-email-in-c-net-part-4-using-office-365-ms-graph-api %})

One of the things you will inevitably end up doing in the course of your software development career is **sending email**.

As [Jamie Zawinski](https://www.jwz.org/) (allegedly) once said:

> Software expands until it can send email

Email, needless to say, is a very complex concept and is spread across the following RFCs:

- [RFC 5322](https://datatracker.ietf.org/doc/html/rfc5321) - Format of email messages, including the structure of headers and the body.
- [RFC 6531](https://datatracker.ietf.org/doc/html/rfc6531) - Extension to RFC 5321, allowing for internationalized email addresses.
- [RFC 6532](https://datatracker.ietf.org/doc/html/rfc6532) - Internationalized email headers.
- [RFC 7208](https://datatracker.ietf.org/doc/html/rfc7208) - Sender Policy Framework (SPF) for authorizing the use of domains in email
- [RFC 4021](https://datatracker.ietf.org/doc/html/rfc4021): - Registration of mail and MIME header fields.

In this series, we will address the challenge of **reliably sending email**.

In .NET, a quick way to get started is to use the [MailMessage](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.mailmessage?view=net-9.0) object from the [System.Net.Mail](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail?view=net-9.0) namespace.

Note that this is **NOT** the [MailMessage](https://learn.microsoft.com/en-us/dotnet/api/system.web.mail.mailmessage?view=netframework-4.8.1) class that is in [System.Web.Mail](https://learn.microsoft.com/en-us/dotnet/api/system.web.mail?view=netframework-4.8.1)

## Sending A Plain Text Email

The following example will create a basic email message, from you `your-email@gmail.com` to a recipient, `recipient@example.com`

```c#
var mail = new MailMessage
{
  From = new MailAddress("your-email@gmail.com"),
  Subject = "Test Email",
  Body = "This is a test email sent from .NET"
};

mail.To.Add("recipient@example.com");
```

By default, this message will be in **plain text**.

## Sending an HTML Email

If you want to send a [HTML email](https://en.wikipedia.org/wiki/HTML_email), set the content as follows:

```c#
var mail = new MailMessage
{
    From = new MailAddress("your-email@gmail.com"),
    Subject = "Test Email",
    Body = "<b>This is a test email<b> sent from .NET",
    IsBodyHtml = true
};

mail.To.Add("recipient@example.com");
```

## Sending Email To Multiple Recipients

You can also send an email to **multiple recipients**, which is to say multiple addressees in the TO: field, a collection of `MailAddress` objects.

```c#
var mail = new MailMessage
{
  From = new MailAddress("your-email@gmail.com"),
  Subject = "Test Email",
  Body = "This is a test email",
};

mail.To.Add("recipient@example.com");
mail.To.Add("secondrecipient@example.com");

```

## CCing Email Recipients

You can also add recipients to the `CC` collection.

```c#
mail = new MailMessage
{
  From = new MailAddress("your-email@gmail.com"),
  Subject = "Test Email",
  Body = "This is a test email",
};

mail.To.Add("recipient@example.com");
mail.CC.Add("secondrecipient@example.com");
```

## BCCing Email Recipients

The `MailMessage` also has a `BCC` collection where you can add `BCC` addresses.

```c#
var mail = new MailMessage
{
  From = new MailAddress("your-email@gmail.com"),
  Subject = "Test Email",
  Body = "This is a test email",
};

mail.To.Add("recipient@example.com");
mail.CC.Add("secondrecipient@example.com");
mail.Bcc.Add("thirdrecipient@example.com");
```

## Attaching Files From the File System

The `MailMessage` class also supports **attaching files** from the file system.

```c#
mail = new MailMessage
{
  From = new MailAddress("your-email@gmail.com"),
  Subject = "Test Email",
  Body = "This is a test email",
};

mail.Attachments.Add(new Attachment("/Users/rad/Downloads/Digital Kenya.pdf"));

mail.To.Add("recipient@example.com");
mail.CC.Add("secondrecipient@example.com");
mail.Bcc.Add("thirdrecipient@example.com");
```

## Attaching Files From Streams

Sometimes, the attachments you want to add are not located in the file system. Perhaps they are from **blob storage**, or from a **database**, or some sort of **streaming service**.

In which case, we attach them like this:

```c#
// Fetch the stream from whichever source
using (var stream = File.OpenRead("/Users/rad/Downloads/Digital Kenya.pdf"))
{

  mail = new MailMessage
  {
    From = new MailAddress("your-email@gmail.com"),
    Subject = "Test Email",
    Body = "This is a test email",
  };

  mail.Attachments.Add(new Attachment(stream, "Digital Kenya.pdf"));

  mail.To.Add("recipient@example.com");
  mail.CC.Add("secondrecipient@example.com");
  mail.Bcc.Add("thirdrecipient@example.com");
}
```

## Using Alternate Views

As mentioned earlier, email can be sent either as HTML or as plain text.

The challenge arises when recipients are **unable** or **unwilling** to consume the email in the **sent format**. For example, thanks to spam and tracking, most people **disable HTML email** altogether.

In this case, the solution is to send an email with both views, so that the downstream consumer can decide which one they want to view. This is to say, the email contains **BOTH** plain text and HTML.

```c#
var mail = new MailMessage
{
  From = new MailAddress("your-email@gmail.com"),
  Subject = "Test Email"
};

// Define plain text
var plainText = "This is a test email";
var plainView = AlternateView.CreateAlternateViewFromString(plainText, null, MediaTypeNames.Text.Plain);

// Define HTML
var html = "<b>This is a test email<b> sent from .NET";
var htmlView = AlternateView.CreateAlternateViewFromString(html, null, MediaTypeNames.Text.Html);

// Attach views
mail.AlternateViews.Add(plainView);
mail.AlternateViews.Add(htmlView);

mail.To.Add("recipient@example.com");
mail.CC.Add("secondrecipient@example.com");
mail.Bcc.Add("thirdrecipient@example.com");
```

The code this far is simply to create the `MailMessage`.

The next step is actually **sending the messages**.

This will be covered in the [next post]({%post_url 2025-07-18-sending-email-in-c-net-part-2-delivery %}).

### TLDR

**The `System.Net.Mail` class provides functionality for creating and sending email messages.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-07-15%20-%20Sending%20Email).

Happy hacking!
