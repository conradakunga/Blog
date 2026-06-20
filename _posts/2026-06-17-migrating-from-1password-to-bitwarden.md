---
layout: post
title: Migrating From 1Password To Bitwarden
date: 2026-06-17 11:51:35 +0300
categories:
    - Passwords
    - Tools
    - 1Password	
    - Bitwarden
---

For more than a decade, I have been a happy user of [1Password](https://1password.com/) for managing my myriad of **passwords**, **account numbers**, **credit and debit cards**, and [OTP](https://en.wikipedia.org/wiki/One-time_password) tokens. It has mostly done what it says on the tin, pretty well.

I, like others, griped when they switched to a [SAAS](https://www.salesforce.com/eu/saas/) model, but being in the industry myself, I totally understood their position, and continued to be a customer.

Recently, I got this in my inbox.

![1PasswordRenew](../images/2026/06/1PasswordRenew.png)

This is a clean `33.44%` increase.

Ouch.

It then triggered the memory that I have for some time been mulling moving all my teams away from the mishmash of **secured worksheets and documents** and **assorted apps** for storing things like **passwords**, **IP addresses**, **usernames**, **server names**, etc.

This is a good time as any to look at a solution for **teams**.

The pricing doesn't look all that favorable, as my team is just north of `50` users.

![1passwordteams](../images/2026/06/1passwordteams.png)

Of all the alternatives, one has always stood out - [Bitwarden](https://bitwarden.com/).

Why?

1. [Battle hardened](https://www.pcmag.com/reviews/bitwarden)
2. [Open source](https://github.com/bitwarden)
3. Free compatible server version, [VaultWarden](https://github.com/dani-garcia/vaultwarden) (you naturally have to meet all the hosting costs)
4. Very pocket-friendly

![bitwardenPro](../images/2026/06/bitwardenPro.png)

Note that you can get **Bitwarden** for **absolutely free**, but the integrated [authenticator](https://bitwarden.com/products/authenticator/) alone is worth the price.

![authenticator](../images/2026/06/authenticator.png)

If you really want to use **Bitwarden** for free, you can. But you will need to get the **authenticator** separately as a **standalone application**.

I therefore decided to pull the trigger and **migrate**.

The process is pretty simple.

## Download and install the software

You can access the software [here](https://bitwarden.com/download/) for your operating system of choice.

![bitwardenSoftware](../images/2026/06/bitwardenSoftware.png)

Once installed, it will look something like this on launch:

![bitwardenLaunch](../images/2026/06/bitwardenLaunch.png)

## Install plugins for your browser

There are plugins for all the **popular browsers**.

![bitwardenBrowser](../images/2026/06/bitwardenBrowser.png)

Once installed, you can access it via the **toolbar**.

![bitwardenToolbar](../images/2026/06/bitwardenToolbar.png)

From there, you can log in to your account:

![bitwardenBrowserLogin](../images/2026/06/bitwardenBrowserLogin.png)

## Export Your 1Password Data

The next order of business is to **export** your **1Password** data.

**Log in** to the application and go to the **File** Menu:

![1PasswordFileMenu](../images/2026/06/1PasswordFileMenu.png)

Then enter your password and choose an export format. You probably should stick to [1PUX](https://support.1password.com/1pux-format/).

![1PasswordExport](../images/2026/06/1PasswordExport.png)

Remember, your export file is **unencrypted**!

## Import Your 1Password Data Into Bitwarden

From **Bitwarden** the process is the **opposite**.

Access the **File** menu:

![bitwardenFile](../images/2026/06/bitwardenFile.png)

And click **Import**.

![bitwardenFileImpirt](../images/2026/06/bitwardenFileImpirt.png)

This **might take some time if you have many items stored**, so let it run as long as needed.

Once completed, you should see everything in **Bitwarden**.

![bitwardenSuccess](../images/2026/06/bitwardenSuccess.png)

One caveat is that the import works flawlessly only if the **corresponding functionality is in place**.

For instance, **1Password** can store **software keys and licenses**.

![1PasswordSoftwareLicenses](../images/2026/06/1PasswordSoftwareLicenses.png)

**Bitwarden does not seem to have this**, so all the keys and other information were just dumped in the **root**.

![bitwardenSoftwareValut](../images/2026/06/bitwardenSoftwareValut.png)

Once you are done importing your data, **DELETE the 1PUX export!**

## Tweak Your Settings

Next, we **change some settings** to make the software more usable, as some of the defaults range between **baffling** and **annoying**.

The settings are accessible from the **Bitwarden** menu:

![bitwardenDesktopSettings](../images/2026/06/bitwardenDesktopSettings.png)

In particular, you might want to enable these settings:

![settings1](../images/2026/06/settings1.png)

And this:

![settings2](../images/2026/06/settings2.png)

You also need to tweak your **browser plugin settings**.

The settings are available here:

![bitwardenBrowserSettings](../images/2026/06/bitwardenBrowserSettings.png)

Turn this on:

![bitwardenBiometrics](../images/2026/06/bitwardenBiometrics.png)

Next, configure your **browser** to **integrate** with **Bitwarden**.

From the **browser extension**, go to **settings**:

![bitwardenSettings](../images/2026/06/bitwardenSettings.png)

Then go to Autofill, and turn this on to set **Bitwarden** as your **default password manager.**

![bitwardenSettingsAutofill](../images/2026/06/bitwardenSettingsAutofill.png)

To verify this worked, go to your browser's **Autofill** settings.

In [Chrome,](https://www.google.com/chrome/) it is here:

![chromeAutofill](../images/2026/06/chromeAutofill.png)

You should see **Bitwarden** registered for **Enhanced Autofill**.

**Bitwarden** is also available on your favourite phone AppStore - [Apple](https://www.apple.com/app-store/) or [Google](https://play.google.com/store/apps). Install it.

For **iOS**, go to **Settings** > **AutoFill & Passwords**

Turn this **ON**

![AutoFill](../images/2026/06/AutoFill.png)

**And you should now be up and running.**

## Cancel 1Password Subscription

The last step is to actually cancel the **1Password** subscription. If you don't, the next cycle will bill you, and your term will be **renewed**.

Log in to your customer profile and go to the **Billing** tab.

At the bottom is an option to **Cancel Subscription**.

![cancel1Password](../images/2026/06/cancel1Password.png)

You will be asked for feedback on why you are canceling.

![1PasswordCancelConfirm](../images/2026/06/1PasswordCancelConfirm.png)

You will then get a confirmation.

![1PasswordCancelComplete](../images/2026/06/1PasswordCancelComplete.png)

**And we're done!**

You could, at this point, also uninstall all the software, but I have chosen to **leave the application** itself and **disable the extensions**.

You might have canceled the subscription, but you still have **read access to your passwords**, so it's **harmless to keep it around**. Also, you can **re-activate the subscription at any time**.

## Parting Shot

**The software is pretty fully featured and functional, and so far, so good.**

However, to be honest, and not to take anything away from the hard-working team at **Bitwarden**, **1Password** is **head and shoulders more polished** in terms of design, UI, and UX.

But in terms of features and functionality, they are **pretty evenly matched**.

Happy hacking!
