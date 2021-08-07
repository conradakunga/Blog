---
layout: post
title: Tip - Get Current Date In C#
date: 2021-08-07 16:42:48 +0300
categories:
    - C#
---
Frequently in the course of your code, you will need to get the current date.

Which is very simple - the `Now` property of the [DateTime](https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=net-5.0) object.

```csharp
var currentDate = DateTime.Now;
```

This is correct; and also wrong.

Because if you get the actual value:

```csharp
Console.WriteLine(currentDate);
```

the value returned is as follows:

```plaintext
7 Aug 2021 17:00:43
```

It is correct in the sense that the date I am writing this is indeed 7 August.

It is wrong because **there is a time component to the date**.

This is important because if you are doing any sort of date comparison logic, the time might throw off your comparison.

So a query like this might produce unexpected results:

```csharp
var ordersToday = db.Orders.Where(x=>x.OrderDate == currentDate);
```

The `Time` component will restrict the results.

There are two ways around this:

The first is to use the `Date` property of the `DateTime` object.

```csharp
var currentDate = DateTime.Now.Date;
Console.WriteLine(currentDate);
```

This constructs a new `DateTime` object using the current `DateTime`, but ignores the time component.

The output is as follows:

```plaintext
7 Aug 2021 00:00:00
```

An even quicker way is to use the `Today` property of the `DateTime`

```plaintext
var currentDate = DateTime.Today;
```

The benefit of the Date method is it works with any date.

Happy hacking!

