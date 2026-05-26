---
layout: post
title: Configuring Teams Webhooks for Channels
date: 2026-05-26 13:43:35 +0300
categories:
    - Microsoft 365
    - Office 365
    - Teams
---

In a previous post, some 6 years ago, "[Posting Messages To Microsoft Teams With Code]({% post_url 2020-11-04-posting-messages-to-microsoft-teams-with-code %})", we looked at how to configure a [Microsoft Teams](https://www.microsoft.com/en-us/microsoft-teams/group-chat-software) channel to receive and process [webhooks](https://en.wikipedia.org/wiki/Webhook), typically for **posting messages** from third-party applications or a script.

Unsurprisingly, things are very **different** now, and [some features have been deprecated](https://devblogs.microsoft.com/microsoft365dev/retirement-of-office-365-connectors-within-microsoft-teams/).

This is the **current** way to achieve the same as of the time of writing this post.

First, **identify the team** you would like to receive the webhook for, then click the **ellipsis** to open the **menu**.

![teamsMenu](../images/2026/05/teamsMenu.png)

The new menu item is named **Workflows**. (It was **Connectors** before)

![teamsWorfkflowMenu](../images/2026/05/teamsWorfkflowMenu.png)

This will take you to a screen where you can choose from a list of **available workflows**.

![workflowsMenu](../images/2026/05/workflowsMenu.png)

Rather than scroll, we can **search** for what we want:

![workflowsSearch](../images/2026/05/workflowsSearch.png)

We want the last item, "**Send webhook alerts to a channel**".

Next, we get taken to a screen to **choose the channel.**

![channelConfig](../images/2026/05/channelConfig.png)

Once you save, you are taken to the **final** screen.

![workflowComplete](../images/2026/05/workflowComplete.png)

From here, we can access our **webhook** link.

![webhookLink](../images/2026/05/webhookLink.png)

**Copy** this for subsequent use.

In our next post, we will look at **how to post a message to a Teams Channel from cod**e.

Happy hacking!
