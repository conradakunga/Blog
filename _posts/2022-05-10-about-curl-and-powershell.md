---
layout: post
title: About curl And PowerShell
date: 2022-05-10 09:17:28 +0300
categories:
    - C#
    - .NET
---
In a previous blog post I had talked about how `curl` in Powershell was an alias for the [Invoke-WebRequest](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.2) cmdlet.

This was a well intentioned move, leveraging the muscle memory of experienced users.

The problem is that [curl](https://curl.se/) the tool is a [very comprehensive tool](https://curl.se/docs/manpage.html), and an immediate problem that people with Linux experience ran into was that `invoke-webrequest` does not recognize the bewildering array of parameters and sub-commands that `curl` supports.

This led to a situation where scripts would surprise users, especially experienced users.

Microsoft made a change from Windows build 1804, where they made the following changes in PowerShell
1. Removed the `curl` alias
2. Packaged with Windows the native curl executable

You can verify this if you are running a recent build by running the following command in your console:

```bash
curl --version
```

You should get back a response like this:

```plaintext
curl 7.79.1 (Windows) libcurl/7.79.1 Schannel
Release-Date: 2021-09-22
Protocols: dict file ftp ftps http https imap imaps pop3 pop3s smtp smtps telnet tftp
Features: AsynchDNS HSTS IPv6 Kerberos Largefile NTLM SPNEGO SSL SSPI UnixSockets
```

You can even check where it is installed:

```bash
where.exe curl.exe
```

You should get back a result like this:

```plaintext
C:\Windows\System32\curl.exe
```

You can now comfortably use curl in your Powershell scripts with the full features it supports, or if you wish, directly use `invoke-webrequest`.

This change was made to both Powershell and Powershell Core.

Happy hacking!