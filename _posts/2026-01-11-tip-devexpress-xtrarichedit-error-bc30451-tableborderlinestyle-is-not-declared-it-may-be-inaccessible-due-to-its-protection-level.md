---
layout: post
title: "Tip - DevExpress XtraRichEdit error BC30451: 'TableBorderLineStyle' is not declared. It may be inaccessible due to its protection level"
date: 2026-01-11 14:19:36 +0300
categories:
    - C#
    - .NET
    - DevExpress
    - XtraRichEdit
---

After upgrading to [DevExpress](https://www.devexpress.com/) `24`or `25`, you may encounter the following **error** when using the [RichEditDocumentServer](https://docs.devexpress.com/OfficeFileAPI/DevExpress.XtraRichEdit.RichEditDocumentServer) class.

```plaintext
error BC30451: 'TableBorderLineStyle' is not declared. It may be inaccessible due to its protection level.
```

This is an error you will get if you have code like this:

```vb
 With tStyleMain
     .FontSize = 10
     .CellLeftPadding = CellPadding
     .CellRightPadding = CellPadding
     .CellTopPadding = CellPadding
     .CellBottomPadding = CellPadding
     With .TableBorders
         .InsideHorizontalBorder.LineStyle = TableBorderLineStyle.Single
         .InsideVerticalBorder.LineStyle = TableBorderLineStyle.Single
         .Top.LineStyle = TableBorderLineStyle.Single
         .Left.LineStyle = TableBorderLineStyle.Single
         .Bottom.LineStyle = TableBorderLineStyle.Single
         .Right.LineStyle = TableBorderLineStyle.Single
     End With
     .TableLayout = TableLayoutType.Autofit
     .Name = "Table Details"
 End With
```

The example here is in VisualBasic.NET.

The issue here is that there has been a breaking change where this enum, `TableBorderLineStyle` has been [renamed](https://supportcenter.devexpress.com/ticket/details/t1256923/word-processing-the-tableborderlinestyle-enumeration-is-renamed-to-borderlinestyle) to `BorderLineStyle`.

As they explain:

> The `BorderLineStyle` enumeration is used for table, page, and paragraph borders.

The updated code will look like this:

```vb
  With tStyleMain
      .FontSize = 10
      .CellLeftPadding = CellPadding
      .CellRightPadding = CellPadding
      .CellTopPadding = CellPadding
      .CellBottomPadding = CellPadding
      With .TableBorders
          .InsideHorizontalBorder.LineStyle = BorderLineStyle.Single
          .InsideVerticalBorder.LineStyle = BorderLineStyle.Single
          .Top.LineStyle = BorderLineStyle.Single
          .Left.LineStyle = BorderLineStyle.Single
          .Bottom.LineStyle = BorderLineStyle.Single
          .Right.LineStyle = BorderLineStyle.Single
      End With
      .TableLayout = TableLayoutType.Autofit
      .Name = "Table Details"
  End With
```

### TLDR

The `TableBorderLineStyle` enum has been renemed to `BorderLineStyle` from DevExpress 24 onwards
