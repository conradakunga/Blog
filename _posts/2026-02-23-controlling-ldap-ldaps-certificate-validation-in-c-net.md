---
layout: post
title: Controlling LDAP & LDAPS Certificate Validation In C# & .NET
date: 2026-02-23 11:41:58 +0300
categories:
    - C#
    - .NET
    - Security
---

Two recent posts, "[Leveraging LDAPS Authentication in C# & .NET]({% post_url 2026-02-21-leveraging-ldaps-authentication-in-c-net %})" and "[Leveraging StartTLS Authentication in C# & .NET]({% post_url 2026-02-22-leveraging-starttls-authentication-in-c-net %})", have covered how to leverage [LDAPS](https://rublon.com/blog/ldap-ldaps-difference/) and [StartTLS](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/enable-ldap-over-ssl-3rd-certification-authority) for authentication, and how they use [SSL](https://www.cloudflare.com/learning/ssl/what-is-ssl/) to ensure all the traffic between the **client** (application) and **server** (LDAP) is appropriately **encrypted**.

This may sometimes present problems, as the client needs to trust the server's SSL certificate in order for the connection to be securely established.

1. The certificate may have **expired**
2. The client does not trust the server certificate, as it may be from a different network or environment, or it may not have been imported.

In such cases, you might need to override the validation process in your code. 

This hinges on the [LdapConnection](https://learn.microsoft.com/en-us/dotnet/api/system.directoryservices.protocols.ldapconnection?view=net-10.0-pp) object.

The code looks like this for `LDAPS`:

```c#
var connection = new LdapConnection(identifier)
{
  Credential = new NetworkCredential(username, password),
  AuthType = AuthType.Negotiate
};

// Enforce SSL (LDAPS)
connection.SessionOptions.SecureSocketLayer = true
```

And like this for `StartTLS`:

```c#
var connection = new LdapConnection(identifier)
{
  Credential = new NetworkCredential(username, password),
  AuthType = AuthType.Negotiate
};

// Require TLS upgrade
connection.SessionOptions.ProtocolVersion = 3;
```

The addition for both scenarios is to add this code, an **event handler** for when the validation process takes place.

```c#
connection.SessionOptions.VerifyServerCertificate += (conn, cert) =>
{
	// Your logic here
};
```

Within this event handler, we have options, as we have access to both the `LdapConneciton` (`conn`) and the `X509Certificate` (`certificate`).

We can decide **not to bother doing anything at all** and just say that the validation is successful, like so:

```c#
connection.SessionOptions.VerifyServerCertificate += (conn, cert) =>
{
	// Always succeed
  return true;
};
```

This is useful for testing contexts.

Alternatively, we can write our own custom logic to validate the certificate. 

## The certificate must be present

```c#
connection.SessionOptions.VerifyServerCertificate += (conn, cert) =>
{
	return cert != null;
};
```

## The certificate metadata is valid

```c#
connection.SessionOptions.VerifyServerCertificate += (conn, cert) =>
{
    return cert.Issuer == "Your expected issuer";
};
```

In this way, you can control what constitutes validity.

## TLDR

**You can customize the SSL validation process for `LDAPS` and `StartTLS`.**

Happy hacking!
