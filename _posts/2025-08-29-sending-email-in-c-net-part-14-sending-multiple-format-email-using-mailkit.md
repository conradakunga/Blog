---
layout: post
title: Sending Email In C# & .NET - Part 14 - Sending Multiple Format Email Using MailKit
date: 2025-08-29 09:42:38 +0300
categories:
    - C#
    - .NET
    - Email
    - StarLibrary
    - MailKit
---

This is part 14 of a series on sending Email

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
- **Sending Email In C# & .NET - Part 14 - Sending Multiple Format Email Using MailKit (This post)**
- [Sending Email In C# & .NET - Part 15 - Sending Calendar Invites Using MailKit]({% post_url 2025-08-30-sending-email-in-c-net-part-15-sending-calendar-invites-using-mailkit %})
- [Sending Email In C# & .NET - Part 16 - Testing SMTP Locally Using Mailpit]({% post_url 2025-08-31-sending-email-in-c-net-part-16-testing-smtp-locally-using-mailpit %})

In our last post, "[Sending Email In C# & .NET - Part 13 - Sending Email With Inline Attachments Using MailKit]({% post_url 2025-08-28-sending-email-in-c-net-part-13-sending-email-with-inline-attachments-using-mailkit  %})", we looked at how to send inline attachments using MailKit.

In this post, we will look at how to send an email with **multiple formats**.

The process is as follows:

1. Create a `MimeMessage`
2. Create one (or more) `MailboxAddress` for the recipients and add to the `To` collection of the `MimeMessage`
3. Create one `MailboxAddress` for the sender and add it to the `From` collection of the `MimeMessage`
4. Set  the `Subject` of the `MimeMessage`
5. Create a `BodyBuilder`
6. Add `LinkedResources` to the `BodyBuilder` (if any)
7. Set the `TextBody` of the the `BodyBuilder`
8. Set the `HtmlBody` of the `BodyBuilder`
9. Set the body from the `BodyBuilder`
10. Send the message using the `SmtpClient`. This is the `SmtpClient` from `MailKit`, not the one in [System.Net](https://learn.microsoft.com/en-us/dotnet/api/system.net.mail.smtpclient?view=net-9.0).

The code is as follows:

```c#
using MailKit.Net.Smtp;
using MimeKit;
using MimeKit.Utils;
using Serilog;

// Configure logging to the console
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();

// Create the email
var message = new MimeMessage();
// Add the sender
message.From.Add(new MailboxAddress("James Bond", "james@mi5.org"));
// Set the recipient
message.To.Add(new MailboxAddress("M", "m@mi5.org"));
// Set the email subject
message.Subject = "Christmas Card";

var builder = new BodyBuilder();

// Create a LinkedResource with the image
var image1 = builder.LinkedResources.Add("Bond1.jpeg");
// Generate an ID for use in linkage
image1.ContentId = MimeUtils.GenerateMessageId();

// Add the card attachment
builder.Attachments.Add("Card.txt");

// Build the html version of the message text using the IDs
var htmlBody = $"""
                <p>Dear M,<br/>
                <p>Merry Christmas From Me<br/>
                <br/
                <center>
                <img src="cid:{image1.ContentId}">
                </center>
                <p>James<br>
                """;

// Set the html body
builder.HtmlBody = htmlBody;

// Build the html version of the message text using the IDs
var body = """
           Dear M,

           Merry Christmas From Me

           James
           """;

// Set the plain text body
builder.TextBody = body;

// Set the message body 
message.Body = builder.ToMessageBody();

// Now send the email
using (var client = new SmtpClient())
{
    Log.Information("Connecting to smtp server...");
    await client.ConnectAsync("localhost", 25, false);
    // Typically, authenticate here. But we are using PaperCut 
    //await client.AuthenticateAsync("username", "password");
    await client.SendAsync(message);
    Log.Information("Sent message");
    await client.DisconnectAsync(true);
    Log.Information("Disconnected from server");
}
```

If we run this code, the resulting email will be as follows:

![MailKitMultiEmail](../images/2025/08/MailKitMultiEmail.png)

Of particular interest:

![MailKitMultiAttachments](../images/2025/08/MailKitMultiAttachments.png)

Where we are seeing:

- **Inline attachment** for the HTML body
- **File attachment** for the card

We also have the **plain text** version of the email.

![MailKitMultiText](../images/2025/08/MailKitMultiText.png)

### TLDR

The `BodyBuilder` object in `MailKit` allows for the construction of elaborate, multi-format email messages.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-08-29%20-%20MailKit%20Multi%20Format).

Happy hacking!
