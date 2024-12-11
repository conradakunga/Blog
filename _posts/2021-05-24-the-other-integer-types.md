---
layout: post
title: The Other Integer Types
date: 2021-05-24 10:00:21 +0300
categories:
    - C#
---
Most developers, when requiring an integer type, use the `int` type and go about their business.

The largest `int` you can use is **2,147,483,647**, and the smallest is **-2,147,483,647**. `int` is a 32-bit type

This is a very big range - `4,294,967,295`

`Int` is a **signed** type - it has provisions for `-` and `+` numbers.

There is an unsigned version  - `uint`

This one has a minimum of **0** and a maximum of **4,294,967,295**

You can establish the minimum of the `int` (or any numeric type for that matter) as follows:

```csharp
Console.WriteLine(int.MinValue);
```

Similarly, for the maximum value

```csharp
Console.WriteLine(int.MaxValue);
```

In the context of storage - for instance, if using [Entity Framework](https://docs.microsoft.com/en-us/ef/core/modeling/value-conversions?tabs=data-annotations) - the size of the type can start to matter when you are storing very large numbers of values.

For more efficient storage (depending on your use case), you might find it more prudent to default to alternative types.


| Name  | Minimum | Maximum | Signed? | Size (bits) |
|-------|---------:|---------:|---------|------|
| `sbyte` | -128    | 127     | Yes     | 8    |
| `byte` | 0    | 255     | No     | 8    |
| `short` | -32,767    | 32,767     | Yes     | 16    |
| `ushort` | 0   | 65,535     | No     | 16    |

There are also types bigger than the 32-bit `integer` (a consideration, for example, when specifying integral primary keys in Entity Framework)

| Name  | Minimum | Maximum | Signed? | Size (bits) |
|-------|---------:|---------:|---------|------|
| `long` | -9,223,372,036,854,775,808    | 9,223,372,036,854,775,808     | Yes     | 64    |
| `ulong` | 0    | 18,446,744,073,709,551,615     | Yes     | 64    |

There are some integral types whose size depends on the underlying platform - native integer (`nint`) and native unsigned integer (`nuint`).

The minimum, maximum, and size depend on the underlying platform, so it should be either 32 or 64 bits. You should only use these if you know what you are doing.

Finally, for very big numbers of arbitrary size, there is a specialised type for these - [System.Numerics.BigInteger](https://docs.microsoft.com/en-us/dotnet/api/system.numerics.biginteger?view=net-5.0)

Happy hacking!