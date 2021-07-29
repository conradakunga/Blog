---
layout: post
title: Sending Teams Messages Using PowerShell
date: 2021-07-29 14:29:53 +0300
categories:
    - Teams
    - PowerShell
---
First, read [this previous post](https://www.conradakunga.com/blog/posting-messages-to-microsoft-teams-with-code/) that gives a primer on how to interact with Teams.

The way to send a message using Powershell is like this:

```powershell
Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body '{"text":"Hello World!"}' -Uri <YOUR WEBHOOK URL>
```

The challenge is your message body is almost always a complex string, and using string interpolation to construct it is a nightmare.

The solution to this is to take advantage of the fact that the message body is actually JSON.

This means you can construct the payload first, and then invoke the URI.

This allows you to perform your string manipulations first, then pass a simple object to the webhook.

```powershell
$tag = "1.0.8"

$databaseBackupPath = "Dropbox"

$webhook = "https://INSERT YOUR WEBHOOK HERE"

$message = "Notification: Generated database backup of $tag to $databaseBackupPath"


$json = @"
{
    "Text": "$message",
}
"@

Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $json -Uri $webhook
```

You should get a success returned.

![](../images/2021/07/PowershellTeams.png)

Happy hacking!

