---
layout: post
title: Chaining Constructors In Visual Basic.NET
date: 2026-01-14 00:41:29 +0300
categories:
    -  Visual Basic.NET
    - .NET
---

Recently, while refactoring some legacy Visual Basic .NET code, I ran into a situation where I realized I could reap significant benefits from chaining [constructors](https://learn.microsoft.com/en-us/dotnet/visual-basic/programming-guide/language-features/objects-and-classes/walkthrough-defining-classes), rather than **copying and pasting the body** across slightly different versions.

The original `type` was as follows:

```basic
Public class Person
    Private ReadOnly FirstName as String
    Private ReadOnly Surname as String
    Private ReadOnly MiddleName as String

    Public Sub New(Firstname as String, Surname as String)
        Me.FirstName = Firstname
        Me.Surname = Surname
    End sub

    Public Sub New(Firstname as String, Surname as String, MiddleName as String)
        Me.FirstName = Firstname
        Me.Surname = Surname
        Me.MiddleName = MiddleName
    End sub
End class
```

I then subclassed this, as follows:

```basic
Public class Teacher
    Inherits Person
    Private ReadOnly Subject as String

    Public Sub New(Firstname as String, Surname as String, Subject as string)
        MyBase.New(Firstname, Surname)
        Me.Subject = Subject
    End Sub
End class
```

The refactoring was around the fact that the domain now required a person to have three names.

```basic
Public Sub New(Firstname as String, Surname as String, MiddleName as String)
    Me.FirstName = Firstname
    Me.Surname = Surname
    Me.MiddleName = MiddleName
End sub
```

If you look at the code, there is a clear duplication between the two `Person` constructors.

```basic
Public class Person
    Private ReadOnly FirstName as String
    Private ReadOnly Surname as String
    Private ReadOnly MiddleName as String

    Public Sub New(Firstname as String, Surname as String)
        Me.FirstName = Firstname
        Me.Surname = Surname
    End sub

    Public Sub New(Firstname as String, Surname as String, MiddleName as String)
        Me.FirstName = Firstname
        Me.Surname = Surname
        Me.MiddleName = MiddleName
    End sub
End class
```

We can avoid this by **chaining** the constructors using `Me.New` as follows:

```basic
Public class Person
    Private ReadOnly FirstName as String
    Private ReadOnly Surname as String
    Private ReadOnly MiddleName as String

    Public Sub New(Firstname as String, Surname as String)
        Me.FirstName = Firstname
        Me.Surname = Surname
    End sub

    Public Sub New(Firstname as String, Surname as String, MiddleName as String)
        Me.New(Firstname, Surname)
        Me.MiddleName = MiddleName
    End sub
End class
```

The `Teacher` class presents a **complication**, as there is already a `constructor` that takes `3` `string` parameters.

We can work around this as follows:

```basic
Public class Teacher
    Inherits Person
    Private ReadOnly Subject as String

    Public Sub New(Firstname as String, Surname as String, Subject as string)
        MyBase.New(Firstname, Surname)
        Me.Subject = Subject
    End Sub

    Public Sub New(Firstname as String, Surname as String, MiddleName as string, Subject as string)
        MyBase.New(Firstname, Surname, MiddleName)
        Me.Subject = Subject
    End Sub
End class
```

Here, we call the base-class **constructor** that takes the `3` names, then set the `Subject`.

Note the use of keywords here:

- `Me` refers to the current class
- `MyBase` refers to the base class

### TLDR

**Object chaining can simplify object creation and management (generally) without duplicating code.**

The code is in my GitHub.

Happy hacking!
