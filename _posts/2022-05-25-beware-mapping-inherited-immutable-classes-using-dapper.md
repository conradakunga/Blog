---
layout: post
title: Beware - Mapping Inherited Immutable Classes Using Dapper
date: 2022-05-25 16:39:45 +0300
categories:
    - C#
    - Dapper
---
Assume you have the following class:

```csharp
public class Person
{
    public DateTime DateOfBirth { get;}
    public string Name { get; }
}
```

Assume you also have the following class, that inherits from `Person`:

```csharp
public class Student : Person
{
    public string DegreeProgram { get; }
}
```

There is an excellent library, [Dapper](https://github.com/DapperLib/Dapper), that you can use for mapping between C# objects and the database.

First, let us let **Dapper** create for us a dynamic object, and dump that using [Linqpad](https://www.linqpad.net/).

To get a `dynamic` object when using the [Query](https://www.learndapper.com/selecting-multiple-rows) method, do not specify a type.

```csharp
var cn = new SqlConnection("data source=;trusted_connection=true;database=test;encrypt=false");
var result = cn.Query("Select '12 nov 2000' DateOfBirth, 'James Bond' Name, 'Finance' DegreeProgram");
result.Dump();
```

This will display the following:

![](../images/2022/05/DapperDynamic.png)

Next, we want to map the query to a strongly typed object.

Let us start with the `Person` class.

```csharp
var cn = new SqlConnection("data source=;trusted_connection=true;database=test;encrypt=false");
var result = cn.Query<Person>("Select '12 nov 2000' DateOfBirth, 'James Bond' Name, 'Finance' DegreeProgram");
result.Dump();
```

This will output the following:

![](../images/2022/05/DapperPerson.png)

The problem arises when you try to map to a `Student` type.

```csharp
var cn = new SqlConnection("data source=;trusted_connection=true;database=test;encrypt=false");
var result = cn.Query<Student>("Select '12 nov 2000' DateOfBirth, 'James Bond' Name, 'Finance' DegreeProgram");
result.Dump();
```

This outputs the following:

![](../images/2022/05/DapperStudent.png)

Notice that the `DateOfBirth` and `Name` are the default values of their respective types - [DateTime.MinValue](https://docs.microsoft.com/en-us/dotnet/api/system.datetime.minvalue?view=net-6.0) for a [DateTime](https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=net-6.0) and `null` for a [string](https://docs.microsoft.com/en-us/dotnet/api/system.string?view=net-6.0).

If we modify the `Person` class and make the properties read/write:

```csharp
public class Person
{
    public DateTime DateOfBirth { get; set; }
    public string Name { get; set; }
}
```

If we re-run the query we get this:

![](../images/2022/05/DapperPersonUpdated.png)

Now the data is being pulled correctly.

The problem here is that `Dapper` seems to be unable to set the properties of the parent after it has successfully done so for the child if the parent is immutable.

## Moral

When mapping objects with an inheritance chain in Dapper, beware if they are immutable.


The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2022-05-25%20-%20Mapping%20Objects%20In%20Inheritance%20Chain%20To%20Dapper).

Happy hacking!