---
layout: post
title: Fare Thee Well, VBScript
date: 2025-09-12 22:24:06 +0300
categories:
    - VBScript
    - Windows
---

If you are old enough to have remembered [ASP](https://en.wikipedia.org/wiki/Active_Server_Pages) (not [ASP.NET](https://www.asp.net/)), then you almost certainly used [VBScript](https://en.wikipedia.org/wiki/VBScript).

`ASP`, you may be interested to know, stood for **Active Server Pages**.

Fun times!

You would output text to be sent to the browser like this:

```html
<!DOCTYPE html>
<html>
<body>
<%
Response.Write("Hello World!")
%>
</body>
</html>
```

This code would send the string "Hello World" to the browser.

Back then, [Microsoft Access](https://en.wikipedia.org/wiki/Microsoft_Access) was the go-to free database.

Database access was via [ActiveX Data Objects](https://en.wikipedia.org/wiki/ActiveX_Data_Objects) (ADO), the ancestor of [ADO.NET](https://learn.microsoft.com/en-us/dotnet/framework/data/adonet/ado-net-overview).

You would access it like this:

```vb
<%
set conn = Server.CreateObject("ADODB.Connection")
conn.Provider="Microsoft.Jet.OLEDB.4.0"
conn.Open "c:\Data\data.mdb"

// Create a recordset
set rs = Server.CreateObject("ADODB.Recordset")
rs.Open "Select FirstName, Surame from Users", conn

// Loop through each record and output
do until rs.EOF
  for each x in rs.Fields
    Response.Write(x.FirstName)
    Response.Write(" ")
    Response.Write(x.Surname)
    Response.Write("<br>")
  next
    
  Response.Write("<br>")
    
  rs.MoveNext
loop

rs.Close
%>
```

There were no **controllers**, **routes**, and other fancy things like are commonplace these days.

**Fun times!**

You could also write ASP with [JScript](https://en.wikipedia.org/wiki/JScript), but the vast majority of developers used `VBScript`.

You could also use `VBScript` to do **Windows Automation**, as well as write [macros](https://learn.microsoft.com/en-us/office/vba/library-reference/concepts/getting-started-with-vba-in-office) in Microsoft Office.

You probably may have missed this, but last year, on May 22, 2024, [Microsoft announced the deprecation of VBScript](https://techcommunity.microsoft.com/blog/windows-itpro-blog/vbscript-deprecation-timelines-and-next-steps/4148301), recommending the use of `JavaScript` or `PowerShell` instead.

> Technology has advanced over the years, giving rise to more powerful and versatile scripting languages such as JavaScript and PowerShell. These languages offer broader capabilities and are better suited for modern web development and automation tasks.

The second phase of deprecation will take effect **next year**.

I spent many years writing `ASP` applications, and I have fond memories of the time.

However, in this industry, **you must move with the times** even more quickly than most.

### TLDR

**VBScript is undergoing the deprecation process.**

Happy hacking!
