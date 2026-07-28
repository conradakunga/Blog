---
layout: post
title: .NET 11 Preview - X25519 Diffie-Hellman
date: 2026-07-28 21:06:16 +0300
categories:
---

The X25519 [elliptic-curve](https://en.wikipedia.org/wiki/Elliptic_curve) [Diffie-Hellman](https://mathworld.wolfram.com/Diffie-HellmanProtocol.html) algorithm is used heavily where **security** is paramount, and is currently in use in a number of critical **infrastructural** components:

- [SSH](https://en.wikipedia.org/wiki/Secure_Shell)
- TLS [1.3](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/statements/using)
- [Signal](https://signal.org/docs/)
- [Wireguard](https://www.wireguard.com/)
- [WhatsApp](https://medium.com/@tanyaradzwatmushonga/whatsapp-engineering-how-end-to-end-encryption-works-4d051e68d465)

It is, technically, available in .NET 19, but requires a bit of **elbow grease** to correctly **configure** and **use**.

```c#
bool match = false;
using (var alice = ECDiffieHellman.Create(ECCurve.NamedCurves.nistP256))
{
  using (var bob = ECDiffieHellman.Create(ECCurve.NamedCurves.nistP256))
  {
    // Get alice's secret in a byte array
    var aliceSecret = alice.DeriveKeyMaterial(bob.PublicKey);
    // Get bob's secret in a byte array
    var bobSecret = bob.DeriveKeyMaterial(alice.PublicKey);

    // verify the secrets match
    match = CryptographicOperations.FixedTimeEquals(aliceSecret, bobSecret);
  }
}

Console.WriteLine(match);
```

This should print `true`.

A couple of things to note here:

- **You are responsible** for creating the **ECDH** infrastucture yourself
- The [static](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.ecdiffiehellman?view=net-10.0) [Create](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.ecdiffiehellman.create?view=net-10.0) method requires specification of an appropriate **curve**. The one you choose matters

This has been **simplified** in .NET 11, where a dedicated [type](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.ecdiffiehellman?view=net-10.0) has been introduced for this function.

The equivalent code is as follows:

```c#
// Generate key pairs for alice
using (var alice = X25519DiffieHellman.GenerateKey())
{
  // Generate key pairs for bob
  using (var bob = X25519DiffieHellman.GenerateKey())
  {
    // get alice's secret with bob's key
    byte[] aliceShared = alice.DeriveRawSecretAgreement(bob);
    // get boob's secret with alice's key
    byte[] bobShared = bob.DeriveRawSecretAgreement(alice);
    // Check if they are equal
    Console.WriteLine(CryptographicOperations.FixedTimeEquals(aliceShared, bobShared));
  }
}
```

Purists would use [using declarations](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/statements/using) and write the code as follows:

```c#
// Generate key pairs for alice
using var alice = X25519DiffieHellman.GenerateKey();
// Generate key pairs for bob
using var bob = X25519DiffieHellman.GenerateKey();
// get alice's secret with bob's key
byte[] aliceShared = alice.DeriveRawSecretAgreement(bob);
// get boob's secret with alice's key
byte[] bobShared = bob.DeriveRawSecretAgreement(alice);
// Check if they are equal
Console.WriteLine(CryptographicOperations.FixedTimeEquals(aliceShared, bobShared));
```

Personally, I prefer the **previous** because I can **visually see the scope**. The choice is **yours**!

### TLDR

**.NET 11 simplifies working with `X25519 elliptic-curve Diffie-Hellman` operations.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-07-28%20-%20CryptoECDiffieHellman),

Happy hacking!
