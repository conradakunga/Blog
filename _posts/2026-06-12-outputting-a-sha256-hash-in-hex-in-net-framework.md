---
layout: post
title: Outputting A SHA256 Hash in Hex in .NET Framework
date: 2026-06-12 21:31:16 +0300
categories:
    - C#
    - .NET
    - Hashing
---

Obtaining a [SHA256](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.sha256?view=net-10.0) hash in C# & .NET is a pretty **trivial** exercise.

You call the [HashData](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.sha256.hashdata?view=net-10.0) method of the `SHA256` class as follows:

```c#
SHA256.HashData(Encoding.UTF8.GetBytes("Rainbows"))
```

This will give you an `array` of `bytes`.

Typically, you want this in a **human-readable** `string`.

A quick way to do so is to use the [ToHex](https://learn.microsoft.com/en-us/dotnet/api/system.convert.tohexstring?view=net-10.0) method of the [Convert](https://learn.microsoft.com/en-us/dotnet/api/system.convert?view=net-10.0) class.

```c#
Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes("Rainbows"))
```

If we output this, we get the following:

```plaintext
89C39E5BD3FF61EC26E432F0F576E7416C66FF7BF9E133E3C0776DCBE1477ED6
```

Recently, I needed to implement this in a legacy [.NET Framework](https://learn.microsoft.com/en-us/dotnet/framework/) application.

Hashing is slightly **different** there.

You do it like this:

```c#
SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes("Rainbows")
```

Getting the `byte` `array` as a `string` is more of a **challenge**, as there is no `ToHex` method in the .NET Framework's [Convert](https://learn.microsoft.com/en-us/dotnet/api/system.convert?view=netframework-4.6.2) class.

Thankfully, writing one is **trivial**.

```c#
public static class ByteArrayExtensions
{
  public static string ToHexString(this byte[] bytes)
  {
    var sb = new StringBuilder(bytes.Length * 2);
    foreach (var b in bytes)
      // Get the Hex letter values in upper case
      sb.Append(b.ToString("X2"));
    return sb.ToString();
  }
}
```

Here, I have implemented it as an [extension method.](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/extension-methods)

I can then use it like this:

```c#
SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes("Rainbows")).ToHexString()
```

This gives me the **same result as before**:

```plantext
89C39E5BD3FF61EC26E432F0F576E7416C66FF7BF9E133E3C0776DCBE1477ED6
```

### TLDR

**You can convert a `byte` `array` to a hex `string` on .NET Framework by writing a simple *extension method*.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-06-12%20-%20ToHex).

Happy hacking!
