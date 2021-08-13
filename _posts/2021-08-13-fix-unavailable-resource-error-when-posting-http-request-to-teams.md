---
layout: post
title: Fix - Unavailable Resource Error When Posting HTTP Request To Teams
date: 2021-08-13 15:31:21 +0300
categories:
    - Teams
---
I have done two posts on automating posting messages to teams.

The first is a [general overview](https://www.conradakunga.com/blog/posting-messages-to-microsoft-teams-with-code/) and the second is using [Powershell](https://www.conradakunga.com/blog/sending-teams-messages-using-powershell/).

In the course of posting a message via the HTTP end point, you should get a response as follows:

```plaintext
1
```

However there are times you may get this response

```plaintext
The resource you are looking for is unavailable
```

If you get this error, **the problem is your end point**.

Either you have a typo in the URL or you have not updated the channel URL.

How you check for the latter is by looking at the URL

If it starts with

```plaintext
https://office
```

Then it is out of date and you need to update it. [Follow the instructions here](https://www.conradakunga.com/blog/posting-messages-to-microsoft-teams-with-code/) to access the existing webhook. If it is out of date, there will be a button to update it.

Happy hacking!