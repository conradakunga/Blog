---
layout: post
title: Consuming REST JSON APIs From Excel
date: 2021-02-11 12:25:53 +0300
categories:
    - Excel
    - WebAPI
    - REST
---
So today I wanted to see if Excel could natively consume JSON APIs.

So I fired up Excel 2019 and went to the obvious place to find it:

![](../images/2021/02/Excel%201.png)

**From Online Sources** looks like a good candidate.

![](../images/2021/02/Excel%202.png)

Nope.

How about **From Other Sources**?

![](../images/2021/02/Excel%203.png)

Nothing seems to stand out here.

It is definitely not OData.

Maybe **From Web?**

The tool-tip seems to suggest otherwise - web page implies to pull HTML content.

![](../images/2021/02/Excel%204.png)

**Surely** Microsoft Excel 2019, which I believe is the latest, can consume a JSON API!

Turns out it can.

*THE TOOLTIP FOR **FROM WEB** IS MISLEADING!*

Click it anyway and you will get this prompt:

![](../images/2021/02/Excel%205.png)

Paste your URL endpoint there and click OK.

![](../images/2021/02/Excel%206.png)

Excel will try to connect and parse the data

![](../images/2021/02/Excel%207.png)

It then launches a tool named Power Query.

![](../images/2021/02/Excel%208.png)

Now I happen to know that this endpoint gives a list of `country` objects, and that there are 249 of them.

If I scroll down I can confirm this.

![](../images/2021/02/Excel%209.png)

If I click on any of the records, Excel expands it.

![](../images/2021/02/Excel%2010.png)

So it is pulling down the data!

The next step is to instruct Excel how to display it. While it is technically correct that each entry is an object, we want to represent the data as rows.

On the task-pane on your right, click on Source to go back to our original view.

![](../images/2021/02/Excel%2011.png)

You should go back to this:

![](../images/2021/02/Excel%2012.png)

To convert this to tabular format, click the button **To Table** on the menu bar.

![](../images/2021/02/Excel%2013.png)

You may get this prompt:

![](../images/2021/02/Excel%2014.png)

Remember when we expanded one of the records? Excel thinks we might want that as part of our workflow. 

We don't.

For now let us go ahead and **Insert**.

Next we get this prompt.

![](../images/2021/02/Excel%2015.png)

Click OK.

You will then be returned to this view.

![](../images/2021/02/Excel%2016.png)

It may look like nothing has changed but something has. Look closely at the column header.

![](../images/2021/02/Excel%2017.png)

Click on that and you will get a list of the fields in the response.

![](../images/2021/02/Excel%2018.png)

I don't want `countryID`, but I want the others.

Say Insert again to the prompt and we get the following:

![](../images/2021/02/Excel%2019.png)

We are almost there but there are a couple of things:

First, the `column1` prefix is noise. We can get rid of it.

On the task-pane on your right, click the tiny gear icon for the `Expanded Column 1` step.

![](../images/2021/02/Excel%2020.png)

On the resulting screen, remove the caption. You can also change your mind about the fields that you want to see.

The data should now look like this:

![](../images/2021/02/Excel%2021.png)

While we are at it, we can click the icon on the left and delete the step we took to view a single record

![](../images/2021/02/Excel%2022.png)

The next problem is the `currency` column. This appears to be **another** record.

We can also expand those to view the individual items as columns..

Click this icon on the header:

![](../images/2021/02/Excel%2023.png)

You should get a choice of columns to view.

![](../images/2021/02/Excel%2024.png)

I want to see the `currency name`, `ISO Code` and `Numeric Code` only, so I deselect the rest.

This time I want the column name as a prefix so I don't mix up the currency name and the country name.

This is the resulting data now.

![](../images/2021/02/Excel%2025.png)

Note the column headers now reflect what we want to see.

What we are viewing here is actually a preview, and in fact you can refresh it at any time by clicking **Refresh Preview** (if the source data changes while you are configuring the data source.)

![](../images/2021/02/Excel%2027.png)

The final step is to get this data back into Excel. Click **Close & Load**

![](../images/2021/02/Excel%2026.png)

Our data is now loaded into Excel, beautifully formatted as a table.

![](../images/2021/02/Excel%2028.png)

You can refresh this data from Excel at anytime by going to the Data pane and clicking **Refresh All**

![](../images/2021/02/Excel%2029.png)

Happy hacking!