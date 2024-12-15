---
layout: post
title: Simplified Hashing In .NET 9
date: 2024-12-15 22:40:48 +0300
categories:
    - Security
    - .NET 9
---

If you are dealing with security, no matter how peripherally, you will have dealt with [hashing functions](https://en.wikipedia.org/wiki/Hash_function) and the requirement to hash data.

Let us take the case where we need to hash some data using the [SHA265](https://www.movable-type.co.uk/scripts/sha256.html) algorithm,

We would do it like this:

```csharp
// Build a byte array of our original data
var originalData = Encoding.Default.GetBytes("This is some data");
// Compute the hash
var hashedData = SHA256.HashData(originalData);
```

If we needed to use a different algorithm, say [SHA512](https://medium.com/@zaid960928/cryptography-explaining-sha-512-ad896365a0c1), the code would be very similar:

```csharp
// Build a byte array of our original data
var originalData = Encoding.Default.GetBytes("This is some data");
// Compute the hash
var hashedData = SHA512.HashData(originalData);
```

For the examples here, I have used a simple `string` that I converted to a byte array, but the `byte` array could be anything, including a file, which is probably one of the [most common use cases for this](https://codesigningstore.com/what-is-a-file-hash-definition).

.NET 9 has some improvements around this, such as centralizing the hashing into the HashData method from the CryptographicOperations class.

The above two examples can be written as follows:

```csharp
// Hash using SHA256
var sha256HashedData = CryptographicOperations.HashData(HashAlgorithmName.SHA256, originalData);
// Hash using SHA512
var sha512HashedData = CryptographicOperations.HashData(HashAlgorithmName.SHA512, originalData);
```

The magic is in the new static struct [HashAlgorithmName](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.hashalgorithmname?view=net-9.0) that you can use to specify the following algorithms:

- MD5	
- SHA1
- SHA256
- SHA3_256
- SHA3_384
- SHA3_512
- SHA384
- SHA512

If the data you are processing is very large, you can call an async version of the method - [HashDataAsync](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.cryptographicoperations.hashdataasync?view=net-9.0)

```csharp
// Hash using SHA256, passing the cancellation token from the context
var sha256HashedData = await CryptographicOperations.HashDataAsync(HashAlgorithmName.SHA256, originalData, token);
// Hash using SHA512, passing the cancellation token from the context
var sha512HashedData = await CryptographicOperations.HashDataAsync(HashAlgorithmName.SHA512, originalData, token);
```

The `HashData` and `HashDataAsync` methods also allow you to pass your data as a `Stream` or a `ReadOnlySpan<byte>`

Happy hacking!