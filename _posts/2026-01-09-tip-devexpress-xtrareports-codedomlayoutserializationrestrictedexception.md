---
layout: post
title: Tip - DevExpress XtraReports CodeDomLayoutSerializationRestrictedException
date: 2026-01-09 22:12:50 +0300
categories:
    - C#
    - .NET
    - DevExpress
    - XtraReports
---

**Reporting** is a very common requirement for line-of-business applications, and the inevitable request for **user-customizable** reports will always arise.

[DevExpress](https://www.devexpress.com/) [XtraReports](https://docs.devexpress.com/XtraReports/14651/get-started-with-devexpress-reporting) has a solution to this. It offers an **end-user report designe**r, and you can **serialize** the modified report to storage once the user is done, and **load** it from storage when required for reporting.

When you upgrade to **DevExpress 25.2.5**, you will start getting the following **error** when attempting to serialize or deserialize a persisted report:

```plaintext
DevExpress.XtraReports.Security.CodeDomLayoutSerializationRestrictedException' occurred in xxxxxxxxx
DevExpress Reports default configuration prohibits CodeDOM serialization
```

This, as you can see, is a **security** exception.

There are two solutions to this problem.

1. The first, and preferred, is to eschew CodeDOM serialization altogether and use [XML serialization](https://docs.devexpress.com/XtraReports/10011/feature-guide-to-devexpress-reports/store-and-distribute-reports/store-report-layouts-and-documents/xml-serialization).
2. The second, shorter-term solution (as you get your ducks in a row) is to **temporarily** allow CodeDOM.

This line of code will achieve this:

```c#
DevExpress.XtraReports.Configuration.Settings.Default.AllowCodeDomLayoutDeserialization = True
```

Place it somewhere in your **application startup**, and everything should work.

### TLDR

**DevExpress XtraReports now, by default, restricts the loading and persistence of CodeDOM-serialized reports.**
