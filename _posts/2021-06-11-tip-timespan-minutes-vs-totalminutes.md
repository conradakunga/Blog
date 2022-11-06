---
layout: post
title: Tip - TimeSpan Minutes vs TotalMinutes
date: 2021-06-11 10:57:59 +0300
categories:
    - C#
    - Time
    - Tips
---
The [TimeSpan](https://docs.microsoft.com/en-us/dotnet/api/system.timespan?view=net-5.0) object allows for the representations of a point in time (the [TimeOfDay](https://docs.microsoft.com/en-us/dotnet/api/system.datetime.timeofday?view=net-5.0) component of a [DateTime](https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=net-5.0)).

It also allows for computations (subtraction and addition) of `TimeSpans`.

What often trips me up (and I suspect I am not alone) is the difference between the [Minutes](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.minutes?view=net-5.0) property and the [TotalMinutes](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.totalminutes?view=net-5.0) property; as well as the similar properties:
* [Hours](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.hours?view=net-5.0) vs [TotalHours](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.totalhours?view=net-5.0)
* [Days](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.days?view=net-5.0) vs [TotalDays](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.totaldays?view=net-5.0)
* [Seconds](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.seconds?view=net-5.0) vs [TotalSeconds](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.totalseconds?view=net-5.0)
* [Milliseconds](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.milliseconds?view=net-5.0) vs [TotalMilliseconds](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.totalmilliseconds?view=net-5.0)

If you use the interchangeably you can get all sort of strange errors where your code returns the correct results in some situations and the wrong results in others.

Let's look at some code to illustrate:

```csharp
var start = new TimeSpan(10, 0, 0);

var firstEnd = new TimeSpan(10, 30, 0);

Console.WriteLine((firstEnd - start).Minutes);
Console.WriteLine((firstEnd - start).TotalMinutes);
```

The results should be as follows:

```plaintext
[14:55:58 INF] Minutes: 30
[14:55:58 INF] Total Minutes: 30
```

If we subtract the TimeSpans from each other, the resultant TimeStamp's relevant properties are as displayed.

Here we can see that they are exactly the same.

Let's try something different:

```csharp
var start = new TimeSpan(10, 0, 0);
var secondEnd = new TimeSpan(11, 1, 0);

Log.Information("Minutes: {minutes}", (secondEnd - start).Minutes);
Log.Information("Total Minutes: {minutes}", (secondEnd - start).TotalMinutes);
```

The results should be as follows:

```plaintext
[14:58:54 INF] Minutes: 1       
[14:58:54 INF] Total Minutes: 61
```

Here we can see that they are different.

So, it seems as follows:

* `Minutes` is simply a calculation where the `Minutes` component of each `TimeSpan` is subtracted from the other. This implies the minimum is 0 and the maximum is 59.

    In other words, after getting to 59, the `Minutes` cycle back to 0
* `TotalMinutes` is a calculation of how many minutes are there between each of the `TimeSpans`. This implies for all intents and purposes, there isn't a maximum.

Additionally, seconds and milliseconds factor into the `TotalMinutes` computation:

```csharp
var thirdEnd = new TimeSpan(0, 12, 0, 30, 0);
Log.Information("Minutes: {minutes}", (thirdEnd - start).Minutes);
Log.Information("Total Minutes: {minutes}", (thirdEnd - start).TotalMinutes);
```

The results should be as follows:

```plaintext
[15:11:19 INF] Minutes: 0
[15:11:19 INF] Total Minutes: 120.5
```

Note that the `0.5` is from the `30` seconds in the `TimeSpan` constructor we have used (Days, hours, minutes, seconds, milliseconds)

If we add milliseconds we can see the impact:

```csharp
var fourthEnd = new TimeSpan(0, 12, 0, 30, 0);
Log.Information("Minutes: {minutes}", (fourthEnd - start).Minutes);
Log.Information("Total Minutes: {minutes}", (fourthEnd - start).TotalMinutes);
```

The results should be as follows:

```plaintext
[15:16:08 INF] Minutes: 0
[15:16:08 INF] Total Minutes: 120.50083333333333
```

It is possible to retrieve the smaller units after subtracting the `TimeStamps`. Now this is where it gets interesting

```csharp
var fourthEnd = new TimeSpan(0, 12, 0, 30, 50);
var result = (fourthEnd - start);
Log.Information("Minutes: {minutes}", result.Minutes);
Log.Information("Total Minutes: {minutes}", result.TotalMinutes);
Log.Information("Total Seconds: {seconds}", result.Seconds);
Log.Information("Total MilliSeconds: {milliseconds}", result.Milliseconds);
```

The results should be as follows:

```plaintext
[15:20:37 INF] Minutes: 0
[15:20:37 INF] Total Minutes: 120.50083333333333
[15:20:37 INF] Total Seconds: 30
[15:20:37 INF] Total MilliSeconds: 50
```

Now, you might ask why did we use Seconds and Milliseconds instead of TotalSeconds and TotalMilliseconds?

Because using `TotalXXXX` will compute, remember, the **total difference** between the two `TimeSpans` **in that unit**;.

If you in fact change the code to do so, this is the result you will get:

```plaintext
[15:23:07 INF] Minutes: 0
[15:23:07 INF] Total Minutes: 120.50083333333333
[15:23:07 INF] Total Seconds: 7230.05
[15:23:07 INF] Total MilliSeconds: 7230050
```

So play close attention to what exactly you want to retrieve from your computation.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2021-06-11%20-%20TimeSpan%20Minutes%20vs%20TotalMinutes).

Happy hacking!

