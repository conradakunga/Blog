---
layout: post
title: Creating & Managing Environments In Yaak
date: 2025-12-27 12:35:46 +0300
categories:
    - Tools
    - Yaak
---

The previous post, "[Automatically Fetching an Identity Server Token with Yaak]({% post_url 2025-12-26-automatically-fetching-an-identity-server-token-with-yaak %})", looked at how to set up [Yaak](https://yaak.app/) to **fetch and store tokens** issued by an identity server to secure endpoints using **request chaining**.

**NOTE: For this post, I am using a Yaak beta version, Version `2025.10.0-beta.8 (2025.10.0-beta.8)`**

In that technique, the token was stored in a **global variable**, given that you need a valid identity server token **regardless of circumstances**.

Sometimes you would like some **fine-grained control** over the variables.

Consider a situation where you have a third-party API that offers a **test environment** and a **live environment**, each differentiated by an API key.

We need, therefore, to tell **Yaak** in some way when to use the **test** and when to use the **live** key.

In our approach, **we will use this key in a HTTP header** so that the back-end service can retrieve and utilize it.

This is done as follows:

First, click on the **environment** section:

![environmentsetup](../images/2025/12/environmentsetup.png)

This will open a dialog that shows you your **global variables**, if any.

![globalvars](../images/2025/12/globalvars.png)

In our case, we have already defined the `AccessToken`. This will **always be available**, regardless of the environment.

To create an **environment**, click the `(+)` next to **Global Variables**.

![addEnvironmnet](../images/2025/12/addEnvironmnet.png)

In the dialog presented, you provide a **name** for the environment and **optionally** choose a **colour** to differentiate it **visually**.

![stagingSetup](../images/2025/12/stagingSetup.png)

Upon saving, you should see the new **environment** added as a node.

![completeStagingSetup](../images/2025/12/completeStagingSetup.png)

Next, we click on our new environment.

The UI will change to allow us to add our custom environment variable.

![stagingVariablesSetup](../images/2025/12/stagingVariablesSetup.png)

We can then **define** and **set** our variable.

![setupStagingAPIKey](../images/2025/12/setupStagingAPIKey.png)

1. The **name** of the variable
2. The **value**

We then create a **second** environment, `Production`, and also define a **key** for that.

![setupProductionAPIKey](../images/2025/12/setupProductionAPIKey.png)

Finally, we set up our endpoint to populate the `APIKey` in the **request** as a **header**.

![endpointKeySetup](../images/2025/12/endpointKeySetup.png)

To set the appropriate header, we toggle the environment we want to user here:

![environmentToggle](../images/2025/12/environmentToggle.png)

For `Staging`:

![stagingKeyRequest](../images/2025/12/stagingKeyRequest.png)

For `Production`:

![productionKey](../images/2025/12/productionKey.png)

We can see in both environments that **the key is set correctly**.

### TLDR

**You can set up environments in Yaak to control environment-specific settings you want it to use.**

Happy hacking!
