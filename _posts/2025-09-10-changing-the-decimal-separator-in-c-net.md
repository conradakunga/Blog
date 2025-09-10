---
layout: post
title: Changing The Decimal Separator In C# & .NET
date: 2025-09-10 18:34:11 +0300
categories:
    - C#
    - .NET
    - Localization
---

We recently had a request from a client for an integration export file we were generating for them to consume.

The file contained some financial information, and they wanted those numbers to **use a comma as the decimal separator**.

In other words, they wanted the number `1000.00` to be written as `1000,00`.

This is something we have peripherally addressed before when we discussed [customizing the display of dates and times]({% post_url 2024-12-23-advanced-customizaton-of-the-display-of-dates-in-c %}).

There are two ways  around this:

## Use an existing locale that uses commas

A simple solution is to pick and use a locale that natively does this, for example, Italian (`it-IT`) or Dutch (`nl-NL`).

Below is some code that lists all the locales that use a **comma** as a **decimal** separator.

```c#
using System.Globalization;

string[] cultureStrings =
[
    "ar-EG", "hy-AM", "az-AZ", "be-BY", "bg-BG", "hr-HR", "cs-CZ", "da-DK", "nl-NL", "fi-FI", "fr-CA", "fr-FR", "ka-GE",
    "de-DE", "el-GR", "hu-HU", "id-ID", "it-IT", "kk-KZ", "lv-LV", "lt-LT", "nb-NO", "pl-PL", "pt-BR", "pt-PT", "ro-RO",
    "ru-RU", "sr-RS", "sk-SK", "sl-SI", "es-AR", "es-BO", "es-CL", "es-CO", "es-EC", "es-PY", "es-ES", "es-UY", "es-VE",
    "sv-SE", "tr-TR", "uk-UA", "vi-VN"
];
// Build a collection of locales
var locales = cultureStrings.Select(s => new CultureInfo(s)).OrderBy(s => s.EnglishName).ToArray();
// Print sample values
foreach (var locale in locales)
{
    Console.WriteLine($"{locale.EnglishName} - ({locale.Name})");
    Console.WriteLine(string.Format(locale, "{0:#,0.00}", 10_000));
}
```

This prints the following:

```plaintext
Arabic (Egypt) - (ar-EG)
10٬000٫00
Armenian (Armenia) - (hy-AM)
10 000,00
Azerbaijani (Azerbaijan) - (az-AZ)
10.000,00
Belarusian (Belarus) - (be-BY)
10 000,00
Bulgarian (Bulgaria) - (bg-BG)
10 000,00
Croatian (Croatia) - (hr-HR)
10.000,00
Czech (Czechia) - (cs-CZ)
10 000,00
Danish (Denmark) - (da-DK)
10.000,00
Dutch (Netherlands) - (nl-NL)
10.000,00
Finnish (Finland) - (fi-FI)
10 000,00
French (Canada) - (fr-CA)
10 000,00
French (France) - (fr-FR)
10 000,00
Georgian (Georgia) - (ka-GE)
10 000,00
German (Germany) - (de-DE)
10.000,00
Greek (Greece) - (el-GR)
10.000,00
Hungarian (Hungary) - (hu-HU)
10 000,00
Indonesian (Indonesia) - (id-ID)
10.000,00
Italian (Italy) - (it-IT)
10.000,00
Kazakh (Kazakhstan) - (kk-KZ)
10 000,00
Latvian (Latvia) - (lv-LV)
10 000,00
Lithuanian (Lithuania) - (lt-LT)
10 000,00
Norwegian Bokmål (Norway) - (nb-NO)
10 000,00
Polish (Poland) - (pl-PL)
10 000,00
Portuguese (Brazil) - (pt-BR)
10.000,00
Portuguese (Portugal) - (pt-PT)
10 000,00
Romanian (Romania) - (ro-RO)
10.000,00
Russian (Russia) - (ru-RU)
10 000,00
Serbian (Serbia) - (sr-RS)
10.000,00
Slovak (Slovakia) - (sk-SK)
10 000,00
Slovenian (Slovenia) - (sl-SI)
10.000,00
Spanish (Argentina) - (es-AR)
10.000,00
Spanish (Bolivia) - (es-BO)
10.000,00
Spanish (Chile) - (es-CL)
10.000,00
Spanish (Colombia) - (es-CO)
10.000,00
Spanish (Ecuador) - (es-EC)
10.000,00
Spanish (Paraguay) - (es-PY)
10.000,00
Spanish (Spain) - (es-ES)
10.000,00
Spanish (Uruguay) - (es-UY)
10.000,00
Spanish (Venezuela) - (es-VE)
10.000,00
Swedish (Sweden) - (sv-SE)
10 000,00
Turkish (Türkiye) - (tr-TR)
10.000,00
Ukrainian (Ukraine) - (uk-UA)
10 000,00
Vietnamese (Vietnam) - (vi-VN)
10.000,00
```

If you're curious, these are the locales (and their codes)

| Name | Code |
| ---- | ---- |
| Arabic (Egypt) | ar-EG |
| Armenian (Armenia) | hy-AM |
| Azerbaijani (Azerbaijan) | az-AZ |
| Belarusian (Belarus) | be-BY |
| Bulgarian (Bulgaria) | bg-BG |
| Croatian (Croatia) | hr-HR |
| Czech (Czechia) | cs-CZ |
| Danish (Denmark) | da-DK |
| Dutch (Netherlands) | nl-NL |
| Finnish (Finland) | fi-FI |
| French (Canada) | fr-CA |
| French (France) | fr-FR |
| Georgian (Georgia) | ka-GE |
| German (Germany) | de-DE |
| Greek (Greece) | el-GR |
| Hungarian (Hungary) | hu-HU |
| Indonesian (Indonesia) | id-ID |
| Italian (Italy) | it-IT |
| Kazakh (Kazakhstan) | kk-KZ |
| Latvian (Latvia) | lv-LV |
| Lithuanian (Lithuania) | lt-LT |
| Norwegian Bokmål (Norway) | nb-NO |
| Polish (Poland) | pl-PL |
| Portuguese (Brazil) | pt-BR |
| Portuguese (Portugal) | pt-PT |
| Romanian (Romania) | ro-RO |
| Russian (Russia) | ru-RU |
| Serbian (Serbia) | sr-RS |
| Slovak (Slovakia) | sk-SK |
| Slovenian (Slovenia) | sl-SI |
| Spanish (Argentina) | es-AR |
| Spanish (Bolivia) | es-BO |
| Spanish (Chile) | es-CL |
| Spanish (Colombia) | es-CO |
| Spanish (Ecuador) | es-EC |
| Spanish (Paraguay) | es-PY |
| Spanish (Spain) | es-ES |
| Spanish (Uruguay) | es-UY |
| Spanish (Venezuela) | es-VE |
| Swedish (Sweden) | sv-SE |
| Turkish (Türkiye) | tr-TR |
| Ukrainian (Ukraine) | uk-UA |
| Vietnamese (Vietnam) | vi-VN |

The problem with this technique is that you get **all the other baggage of the locale** - thousand separators, date formats, etc.

For example, in the extract above, some use a **space**, and others use a **decimal**.

There are **two** solutions to this:

## Modify an existing locale

In this approach, we can **take an existing locale and modify it as necessary** to achieve our desired outcome.

For example, if we are happy with all the other details of `en-KE`, we can modify **just what we need** - the **thousand separator**.

```c#
var existingLocale = new CultureInfo("en-KE")
{
    NumberFormat =
    {
        NumberDecimalSeparator = ",",
        NumberGroupSeparator = " "
    }
};
Console.WriteLine(string.Format(existingLocale, "{0:#,0.00}", 10_000));
```

This will print the following:

```plaintext
--Modify existing locale--

10 000,00
```

You need to be careful when doing this, because it is possible to have **clashing definitions**. For example, in `en-KE` the **group** (thousand) separator is a **comma**. So if we also say that the **decimal** separator is a **comma**, we get something confusing to users.

```plaintext
10,000,00
```

This is why I have modified the **number group separator** as well to be a space.

## Create a custom number format

If what you are doing is very localized, you can create a [NumberFormatInfo](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.numberformatinfo?view=net-9.0) directly without needing an entire locale.

```c#
var nf = new NumberFormatInfo
{
    NumberDecimalSeparator = ",",
    NumberGroupSeparator = " "
};

Console.WriteLine(string.Format(nf, "{0:#,0.00}", 10_000))
```

This will produce what we expect.

```plaintext
10 000,00
```

It can get cumbersome having to keep specifying the locale when outputting text.

You can set the locale for the current thread as follows:

```c#
Thread.CurrentThread.CurrentCulture = existingLocale;
Console.WriteLine("{0:#,0.00}", 10_000);
```

Then you can write your code as usual.

### TLDR

**There are several ways to format a number in a desired format - choice of [locale](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.cultureinfo?view=net-9.0), modification of an existing [locale](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.cultureinfo?view=net-9.0) and creation of a [NumberFormatInfo](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.numberformatinfo?view=net-9.0).**

The code is in my GitHub.

Happy hacking!
