---
layout: post
title: A Rose By Any Other Name - Short Circuiting
date: 2024-06-05 13:40:34 +0300
categories:
    - C#
    - VB.NET
---
Suppose you have the following C# program:

It is composed of a main function, and two functions that are called by the main function.

```csharp
void Main()
{
    var config = new LoggerConfiguration().WriteTo.Console();
    Log.Logger = config.CreateLogger();

    if (firstChecK() && secondCheck())
    {
    	Log.Information("Do work");
    }
    else
    {
    	Log.Information("Skip work");
    }
}

bool firstChecK()
{
    Log.Information("Accessing first check");
    return false;
}

bool secondCheck()
{
    Log.Information("Accessing second check");
    return false;
}
```

If you run this program, given that the first function returns `false`, you would expect it to ultimately print '*Skip Work*'

Which it does:

```plaintext
[18:20:51 INF] Accessing first check
[18:20:51 INF] Skip work
```

Now, let us take the exact same program in VB.NET

```vbnet
Sub Main
    Dim config = New LoggerConfiguration().WriteTo.Console()
    Log.Logger = config.CreateLogger()
    
    If firstChecK() And secondCheck() Then
        Log.Information("Do work")
    Else
    	Log.Information("Skip work")
    End If
End Sub

Function firstChecK() As Boolean
    Log.Information("Accessing first check")
    Return False
End Function

Function secondCheck() As Boolean
    Log.Information("Accessing second check")
    Return False
End Function
```

If we run this program, it also prints 'Skip work'. But if you look closely you will find a difference in the outputs; to whit:

![VB Output](../images/2024/06/VBOutput.png)

In the C# program, that line was not printed.
  
What does this mean?

In C#, if the first check is `false`, it does not bother to evaluate the second check. This is called [short circuiting](https://www.geeksforgeeks.org/short-circuit-evaluation-in-programming/).

VB.NET does not short circuit the `AND` operator. It will evaluate every condition in a logic statement.

Which begs the question: what if you in fact wanted to short circuit in VB.NET?

This can be achieved using the [AndAlso](https://learn.microsoft.com/en-us/dotnet/visual-basic/language-reference/operators/andalso-operator) operator.

You can rewrite the logic check as follows:

```vbnet
If firstChecK() AndAlso secondCheck() Then
    Log.Information("Do work")
Else
    Log.Information("Skip work")
End If
```

It now short circuits.

Correspondingly, if you do NOT want short-circuiting in C#, how do you achieve that?

You use the logical `AND` operator, `&`, which is different from the `&&` operator, the conditional `AND`.

You can rewrite the logic check in C# as follows:

```csharp
if (firstChecK() & secondCheck())
{
    Log.Information("Do work");
else
{
    Log.Information("Skip work");
}
```

This will now perform **all** the checks.

When is this useful?

A simple case in use interface development is to validate a value **only** if it has been provided.

For instance to check if a text is a certain length in a `TextBox`:

```csharp
if(textEdit.HasValue && textEdit.Length > 10)
{
    Log.Warning("Your provided text is too long");
}
```

This works out because the length is only checked if there is in fact a provided value.

The same code in VB is as follows:

```vbnet
If textEdit.HasValue AndAlso textEdit.Length > 10 Then
    Log.Warning("Your provided text is too long");
End If
```

Happy hacking!