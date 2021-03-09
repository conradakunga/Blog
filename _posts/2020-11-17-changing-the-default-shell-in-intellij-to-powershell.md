---
layout: post
title: Changing The Default Shell In IntelliJ To PowerShell
date: 2020-11-17 10:44:41 +0300
categories:
    - IntelliJ
---
The default shell in [IntelliJ](https://www.jetbrains.com/idea/) (and its children IDEs) is the [Windows Command Prompt](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/windows-commands).

![](../images/2020/11/WindowsCommand.png)

If, like me, you have long used [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.1) as your default shell, it gets jarring to enter commands like `ls` and have them rejected.

It is possible to change your default shell.

Launch the **settings** page, or enter `settings` into the global search.

![](../images/2020/11/SettingsSearch.png)

This should open the **settings** page.

Navigate to **Tools > Terminal**.

You should see that the default shell is indeed the Windows Command Prompt `cmd.exe`.

![](../images/2020/11/ShellSetup.png)

You can update this to `powershell.exe`. There is no need to specify the complete path, as it should already be in you global search path.

![](../images/2020/11/SettingsPowershell.png)

Restart the IDE and you should see the following.

![](../images/2020/11/UpdatedShell.png)

This should work for the rest of the IntelliJ Family of IDEs, including [Android Studio](https://developer.android.com/studio)

Happy hacking!