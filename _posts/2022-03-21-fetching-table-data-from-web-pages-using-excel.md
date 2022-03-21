---
layout: post
title: Fetching Table Data From Web Pages Using Excel
date: 2022-03-21 11:34:40 +0300
categories:
    - Excel
    - PowerUser
    - Office
---
[Microsoft Excel](https://www.microsoft.com/en-us/microsoft-365/excel) is like that old, dependable, reliable friend that always has a solution to your problems.

But like all friends, you occasionally stumble onto very welcome and pleasant surprises.

For example, I have previously talked about how you can [fetch JSON data over a REST API]({% post_url 2021-02-11-consuming-rest-json-apis-from-excel %}).

I recently needed to get into Excel a table of data - and this case was time zones in Russia.

[Wikipiedia](https://www.wikipedia.org/), as usual, came to the rescue and that data is available [here](https://en.wikipedia.org/wiki/Time_in_Russia) as a table.

![](../images/2022/03/RussianTimeZones.png)

Most people would typically copy the table and paste it into Excel.

Here's an even better way.

Go to the **Data** tab

![](../images/2022/03/1-Data.png)

Hit the **Get Data** button

![](../images/2022/03/2-GetData.png)

Select the **From Web** in the **From Other Sources** menu

![](../images/2022/03/3-FromWeb.png)

From the prompt you get, paste (or type in) the URL to the page that has the table.

![](../images/2022/03/4-WebURL.png)

You should get a prompt like this that lists all the things Excel think are potential data sources in the URL.

![](../images/2022/03/5-DataSources.png)

You can click on each to preview the sources so that you can identify your preferred one.

![](../images/2022/03/6-Preview.png)

Once satisfied, click **Load**.

Your workbook will have a new Worksheet appropriately named.

![](../images/2022/03/7-Worksheet.png)

There are a couple of benefits to doing it this way:
1. Copying and pasting data from web pages is a black art and it is usually hit or miss
2. You get a beautifully formatted [table](https://support.microsoft.com/en-us/office/overview-of-excel-tables-7ab0bb7d-3a9e-4b56-a3c9-6c94334e492c#:~:text=To%20quickly%20create%20a%20table,row%2C%20and%20then%20click%20OK.) quickly and for free.
3. Excel maintains a link to the web page, and you can update your worksheet if the Wikipedia page is updated by right clicking the data source and clicking the **Refresh** menu item.

    ![](../images/2022/03/8-Refresh.png)

    If there is any changed data, your worksheet will update.
4. This way is much tidier