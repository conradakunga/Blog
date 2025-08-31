---
layout: post
title: Tip - Disappeared Database Objects In DataGrip
date: 2025-08-16 12:07:18 +0300
categories:
    - Database
    - Tips
---

[Jetbrains](https://www.jetbrains.com/)  are the makers of the famous [IntelliJ IDEA](https://www.jetbrains.com/idea/) Java IDE, which is also the IDE that [Android Studio](https://developer.android.com/studio) is based on. 

They also make my IDE of choice, [Rider](https://www.jetbrains.com/rider/).

They also make a tool, [DataGrip](https://www.jetbrains.com/datagrip/) that is a tool that can connect to and allow for **querying and manipulation of various DBMS**.

Here is my current database drivers setup:

![DataGripDB1](../images/2025/08/DataGripDB1.png)

And continuing ..

![DataGripDB2](../images/2025/08/DataGripDB2.png)

Once you have connected to a database, you can see the following:

![DataGripObjects](../images/2025/08/DataGripObjects.png)

If, for some reason, you find you cannot see any objects and you know that they exist, go to the top of the **Database Explorer** and click this icon.

![DatagripExplorer](../images/2025/08/DatagripExplorer.png)

In the resulting menu, click Filter.

![DatagripFilter](../images/2025/08/DatagripFilter.png)

You should see a list of objects. Check them as appropriate so that **DataGrip** will show them.

![DatagripAllObjects](../images/2025/08/DatagripAllObjects.png)

The objects should now appear.

Happy hacking!
