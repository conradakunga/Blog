---
layout: post
title: Using NewLines In SQL
date: 2025-04-15 23:12:01 +0300
categories:
    - SQL
---

In our [last post]({% post_url 2025-04-14-beware-environmentnewline-is-not-a-silver-bullet %}), we looked at newlines in the context of strings and files.

In this post, we will look at how to deal with newlines in SQL.

In [C#](https://learn.microsoft.com/en-us/dotnet/csharp/) (and most languages), you can indicate a **newline** directly in your text by simply passing the escaped newline - `\n`.

The following code:

```c#
var text = "The quick\nbrown fox\nwent home";
Console.WriteLine(text);
```

Will print the following:

```plaintext
The quick
brown fox
went home
```

Suppose we need to do the same thing with the [SQL Server](https://www.microsoft.com/en-us/sql-server/).

```sql
DECLARE @Text NVARCHAR(50);

SET @Text ='The quick\nbrown fox\nwent home';

SELECT
    @Text;
```

If we run the above [T-SQL](https://learn.microsoft.com/en-us/sql/t-sql/language-reference?view=sql-server-ver16), we get the following result:

```plaintext
The quick\nbrown fox\nwent home
```

SQL Server does not understand escaped characters.

It does, however, allow you to **pass the actual character**s.

We can rewrite the script as follows:

```sql
-- Declare a newline character (LineFeed)
DECLARE @NewLine CHAR(1) = CHAR(13);

DECLARE @Text NVARCHAR(50);

SET @Text = N'The quick' + @NewLine + N'brown fox' + @NewLine + N'went home';

SELECT
    @Text;
```

If we run this, we get the following:

```plaintext
The quick
brown fox
went home
```

SQL Server will also allow you to use the carriage return directly

```sql
-- Declare a newline character (carriage return)
DECLARE @NewLine CHAR(1) = CHAR(10);

DECLARE @Text NVARCHAR(50);

SET @Text = N'The quick' + @NewLine + N'brown fox' + @NewLine + N'went home';

SELECT
    @Text;
```

This means if you pass **both** a carriage return and a line feed `\r\n` -

```sql
-- Declare a newline character (carriage return & line feed)
DECLARE @NewLine CHAR(2) = CHAR(10) + CHAR(13);

DECLARE @Text NVARCHAR(50);

SET @Text = N'The quick' + @NewLine + N'brown fox' + @NewLine + N'went home';

SELECT
    @Text;
```

You will get **two line breaks** between each line.

```plaintext
The quick

brown fox

went home
```

Keep this in mind if such text needs to be **written directly into a file**!

### TLDR

**`T-SQL` allows you to specify newlines by directly embedding the characters in the text.**

Happy hacking!
