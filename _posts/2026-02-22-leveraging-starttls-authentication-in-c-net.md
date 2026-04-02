---
layout: post
title: Leveraging StartTLS Authentication in C# & .NET
date: 2026-02-22 00:38:34 +0300
categories:
    - C#
    - .NET
    - Security
---

In yesterday's post, "[Leveraging LDAPS Authentication in C# & .NET]({% post_url 2026-02-21-leveraging-ldaps-authentication-in-c-net %})", we looked at how to leverage [LDAPS](https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/enable-ldap-over-ssl-3rd-certification-authority) authentication in our applications, and the fact that it is more secure than [LDAP](https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol).

In today's post, we will look at a third alternative - [StartTLS](https://unix.stackexchange.com/questions/607560/why-is-ldap-with-starttls-preferred-over-ldaps).

This is also an improvement over `LDAP`, as it starts off as `LDAP` and then **upgrades to an encrypted connection**. This makes it more **flexible** and just as **secure** as `LDAPS`.

The code again is very similar to the `LDAP` and `LDAPS` code.

```c#
using System.DirectoryServices.Protocols;
using System.Net;

namespace Authenticators;

public sealed class StartTLSAuthenticator : IAuthenticator
{
    private const int StartTLSPort = 389;
    private readonly string _domain;

    public StartTLSAuthenticator(string domain)
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
            var identifier = new LdapDirectoryIdentifier(_domain, StartTLSPort);

            var connection = new LdapConnection(identifier)
            {
                Credential = new NetworkCredential(username, password),
                AuthType = AuthType.Negotiate
            };

            // Require TLS upgrade
            connection.SessionOptions.ProtocolVersion = 3;

            // Upgrade to TLS (StartTLS)
            connection.SessionOptions.StartTransportLayerSecurity(null);

            // Now the connection is encrypted
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

The magic is happening here:

```c#
// Require TLS upgrade
connection.SessionOptions.ProtocolVersion = 3;

// Upgrade to TLS (StartTLS)
connection.SessionOptions.StartTransportLayerSecurity(null);
```

Next, some tests.

```c#
using Authenticators;
using AwesomeAssertions;

namespace Tests;

[Trait("Category", "LDAPS")]
public class StartTLSAuthenticatorTests
{
    [Theory]
    [InlineData("yourDomain.com", "yourUser", "yourPassword")]
    public void Valid_Username_And_ValidPassword_Succeeds(string domain, string user, string password)
    {
        var authenticator = new StartTLSAuthenticator(domain);
        var act = () => authenticator.Authenticate(user, password);
        act.Should().NotThrow();
    }

    [Theory]
    [InlineData("yourDomain.com", "yourUser", "INVALID")]
    public void Valid_Username_And_InValidPassword_Fails(string domain, string user, string password)
    {
        var authenticator = new StartTLSAuthenticator(domain);
        var act = () => authenticator.Authenticate(user, password);
        act.Should().Throw<AuthenticationException>();
    }

    [Fact]
    public void Null_Domain_Throws_Exception()
    {
        var act = () => new StartTLSAuthenticator("");
        act.Should().Throw<ArgumentException>();
    }

    [Fact]
    public void Null_UserName_Throws_Exception()
    {
        var authenticator = new StartTLSAuthenticator("yourDomain.com");
        var act = () => authenticator.Authenticate("", "password");
        act.Should().Throw<ArgumentException>();
    }

    [Fact]
    public void Null_Password_Throws_Exception()
    {
        var authenticator = new StartTLSAuthenticator("yourDomain.com");
        var act = () => authenticator.Authenticate("user", "");
        act.Should().Throw<ArgumentException>();
    }
}
```

Thus, we can enjoy the security of `LDAPS` with the convenience of `LDAP`.

### TLDR

**You can use `StartTLS` for authentication in your applications using the types in the `System.DirectoryServices.Protocols` namespace.**

The code is in my GitHub.

Happy hacking!
