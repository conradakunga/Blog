---
layout: post
title: Generating A Cryptographically Random String In C# & .NET
date: 2025-08-03 21:25:10 +0300
categories:
    - C#
    - .NET
---

In our previous post, [Generating A Random String In C# & .NET]({% post_url 2025-08-02-generating-a-random-string-in-c-net %}), we looked at how to generate a **random string of specified length**.

In this post, we will look at how to generate **cryptographically secure random strings**, especially in cases where the strings need to be truly **random**. This is important when requirements involve **security** and **encryption**.

Our code will largely be similar to the previous case.

We will re-use the same alphabet:

```c#
public static class Constants
{
  public const string Alphabet = "ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz123456789";
}
```

The code for the generation will make use of a true [random number generator](https://en.wikipedia.org/wiki/Random_number_generation), found in the [RandomNumberGenerator](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.randomnumbergenerator?view=net-9.0) class in the [System.Security.Cryptography](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography?view=net-9.0) namespace. 

```c#
public static string GenerateRandomString(int length)
{
  // Ensure length is at least 1
  ArgumentOutOfRangeException.ThrowIfLessThan(length, 1);

  // Generate string
  var result = new char[length];
  for (int i = 0; i < length; i++)
  {
  	result[i] = Constants.Alphabet[RandomNumberGenerator.GetInt32(Constants.Alphabet.Length)];
  }

  return new string(result);
}
```

There is another way of doing this:

```c#
public static string GenerateRandomString2(int length)
{
  // Ensure length is at least 1
  ArgumentOutOfRangeException.ThrowIfLessThan(length, 1);

  // Generate a byte array of required length 
  var randomBytes = new byte[length];
  using (var rng = RandomNumberGenerator.Create())
  {
    // Fill the array with random bytes
    rng.GetBytes(randomBytes);
    //Get the corresponding character for each the byte using modulus
    return new string(randomBytes.Select(x => Constants.Alphabet[x % Constants.Alphabet.Length]).ToArray());
  }
}
```

There is, however, a **slight disadvantage** of this technique - given that the length of the alphabet is not an exact power of 2, there is a **very slight bias** in terms of the returned distribution after the modulo operation.

We then write some tests to verify that both methods return expected results:

`````c#
public static string GenerateRandomString(int length)
{
  // Ensure length is at least 1
  ArgumentOutOfRangeException.ThrowIfLessThan(length, 1);

  // Generate string
  var result = new char[length];
  for (int i = 0; i < length; i++)
  {
  	result[i] = Constants.Alphabet[RandomNumberGenerator.GetInt32(Constants.Alphabet.Length)];
  }

  return new string(result);
}

public static string GenerateRandomString2(int length)
{
  // Ensure length is at least 1
  ArgumentOutOfRangeException.ThrowIfLessThan(length, 1);

  // Generate a byte array of required length 
  var randomBytes = new byte[length];
  using (var rng = RandomNumberGenerator.Create())
  {
    // Fill the array with random bytes
    rng.GetBytes(randomBytes);
    //Get the corresponding character for each the byte using modulus
    return new string(randomBytes.Select(x => Constants.Alphabet[x % Constants.Alphabet.Length]).ToArray());
  }
}
`````

![CryptographicRandomStringTests](../images/2025/08/CryptographicRandomStringTests.png)

And we can see some samples of the generated strings:

```plaintext
Generated string: x of length 1
Generated string: k8gKE1qe7upq72v56T8H of length 20
Generated string: xcPca of length 5
Generated string: StZFAEjQBbU621DjVGcxD3abGcKjuVj5J1DAzWf8S7rD79ExyP of length 50
```

### TLDR

**You can use the `RandomNumberGenerator` class to generate cryptographically random strings for use in scenarios where true randomness is key, such as security.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-08-02%20-%20Random%20String).

Happy hacking!
