---
layout: post
title: Leveraging LDAPS Authentication in C# & .NET
date: 2026-02-21 00:18:37 +0300
categories:
    - C#
    - .NET
    - Security
---

In yesterday's post, "[Leveraging LDAP Authentication in C# & .NET]({% 2026-02-20-leveraging-ldap-authentication-in-c-net %})", we looked at how to leverage [LDAP](https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol) for authentication.

The problem with LDAP, however, is that it sends the `username` and `password` in plain text over the network, making it vulnerable to [man-in-the-middle attacks](https://www.ibm.com/think/topics/man-in-the-middle), as well as [sniffing](https://www.okta.com/identity-101/sniffing-attack/).

There is, however, a solution to this - [LDAP over Secure Sockets Layer (SSL)](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/enable-ldap-over-ssl-3rd-certification-authority), better known as `LDAPS`.

In this protocol, the LDAP traffic is wrapped in SSL / TLS, meaning that all the `usernames`, `passwords`, **queries**, and **responses** are **encrypted**.

The code is very similar to the LDAP.

```c#
using System.DirectoryServices.Protocols;
using System.Net;

namespace Authenticators;

public sealed class LDAPSAuthenticator : IAuthenticator
{
    private const int LDAPSPort = 636;
    private readonly string _domain;

    public LDAPSAuthenticator(string domain)
    {
        ArgumentException.ThrowIfNullOrEmpty(domain);
        _domain = domain;
    }

    public void Authenticate(string username, string password)
    {
        ArgumentException.ThrowIfNullOrEmpty(username);
        ArgumentException.ThrowIfNullOrEmpty(password);
        try
        {
            var identifier = new LdapDirectoryIdentifier(_domain, LDAPSPort, fullyQualifiedDnsHostName: true,
                connectionless: false);

            var connection = new LdapConnection(identifier)
            {
                Credential = new NetworkCredential(username, password),
                AuthType = AuthType.Negotiate
            };

            // Enforce SSL (LDAPS)
            connection.SessionOptions.SecureSocketLayer = true;

            // Authenticate
            connection.Bind();
        }
        catch (LdapException ex)
        {
            throw new AuthenticationException($"Ldap Exception: {ex.Message}", ex);
        }
        catch (Exception ex)
        {
            throw new AuthenticationException($"General Authentication Exception: {ex.Message}", ex);
        }
    }
}
```

Of interest here is the following:

1. We are setting the [AuthType](https://learn.microsoft.com/en-us/dotnet/api/system.directoryservices.protocols.ldapconnection.-ctor?view=net-10.0-pp#system-directoryservices-protocols-ldapconnection-ctor(system-directoryservices-protocols-ldapdirectoryidentifier-system-net-networkcredential-system-directoryservices-protocols-authtype)) of the [LdapConnecton](https://learn.microsoft.com/en-us/dotnet/api/system.directoryservices.protocols.ldapconnection.-ctor?view=net-10.0-pp#system-directoryservices-protocols-ldapconnection-ctor(system-directoryservices-protocols-ldapdirectoryidentifier-system-net-networkcredential-system-directoryservices-protocols-authtype)) to Negotiate. The other options are [here](https://learn.microsoft.com/en-us/dotnet/api/system.directoryservices.protocols.authtype?view=net-10.0-pp)
2. We are setting the [SessionOptions](https://learn.microsoft.com/en-us/dotnet/api/system.directoryservices.protocols.ldapconnection.sessionoptions?view=net-10.0-pp#system-directoryservices-protocols-ldapconnection-sessionoptions) to require [SSL](https://www.cloudflare.com/learning/ssl/what-is-ssl/)

We write some **tests** for the same:

```c#
using Authenticators;
using AwesomeAssertions;

namespace Tests;

[Trait("Category", "LDAPS")]
public class LDAPSAuthenticatorTests
{
    [Theory]
    [InlineData("yourDomain.com", "yourUser", "yourPassword")]
    public void Valid_Username_And_ValidPassword_Succeeds(string domain, string user, string password)
    {
        var authenticator = new LDAPSAuthenticator(domain);
        var act = () => authenticator.Authenticate(user, password);
        act.Should().NotThrow();
    }

    [Theory]
    [InlineData("yourDomain.com", "yourUser", "INVALID")]
    public void Valid_Username_And_InValidPassword_Fails(string domain, string user, string password)
    {
        var authenticator = new LDAPSAuthenticator(domain);
        var act = () => authenticator.Authenticate(user, password);
        act.Should().Throw<AuthenticationException>();
    }

    [Fact]
    public void Null_Domain_Throws_Exception()
    {
        var act = () => new LDAPSAuthenticator("");
        act.Should().Throw<ArgumentException>();
    }

    [Fact]
    public void Null_UserName_Throws_Exception()
    {
        var authenticator = new LDAPSAuthenticator("yourDomain.com");
        var act = () => authenticator.Authenticate("", "password");
        act.Should().Throw<ArgumentException>();
    }

    [Fact]
    public void Null_Password_Throws_Exception()
    {
        var authenticator = new LDAPAuthenticator("yourDomain.com");
        var act = () => authenticator.Authenticate("user", "");
        act.Should().Throw<ArgumentException>();
    }
}
```

### TLDR

**Due to the insecurity of `LDAP`, we can use the recommended approach of `LDAPS` from the [System.DirectoryServices.Protocols](https://learn.microsoft.com/en-us/dotnet/api/system.directoryservices.protocols?view=net-10.0-pp) namespace.**

The code is in my GitHub.

Happy hacking!

