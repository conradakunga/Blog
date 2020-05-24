---
id: 16
title: Copy SSH Key In Windows 10
date: 2020-03-09T22:38:39+03:00
author: Conrad Akunga
layout: post
guid: https://www.conradakunga.com/blog/?p=16
permalink: /2020/03/09/copy-ssh-key-in-windows-10/
categories:
  - PowerShell
tags:
  - Linux
  - Powershell
---
Did you know that Windows 10 has a proper SSH client, and has had one for a while?

You can generate your keys using `ssh-keygen`

The problem, as you will soon discover, is there is no `ssh-copy-id` command.

The good news is that you can fix this problem in your Powershell profile

Open your profile using the following command.

`notepad++ $profile`

I'm using Notepad++ (because I have installed it, and use it as my go-to text editor) but you can use any editor there, even plain old Notepad

Usually, it will be blank.

Paste the following code

```powershell
function ssh-copy-id([string]$userAtMachine, [string]$port = 22) 
{   
    # Get the generated public key
    $key = "$ENV:USERPROFILE" + "/.ssh/id_rsa.pub"
    # Verify that it exists
    if (!(Test-Path "$key")) {
        # Alert user
        Write-Error "ERROR: '$key' does not exist!"            
    }
    else {	
        # Copy the public key across
        & cat "$key" | ssh $userAtMachine -p $port "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys || exit 1"      
    }
}
```


Save the file, close the active Powershell session and re-launch it again. You should find that the `ssh-copy-id` is recognized as a known command.

You can then use it to copy your ID to another ssh terminal

`ssh-copy-id yourname@machine`

If ssh is running on a non-default port (i.e. not 22) specify the port as follows

```powershell
ssh-copy-id yourname@machine -p 222
```

Happy Hacking!