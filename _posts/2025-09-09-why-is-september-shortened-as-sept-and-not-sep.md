---
layout: post
title: Why Is September Shortened As Sept And Not Sep
date: 2025-09-09 16:57:00 +0300
categories:
    - C#
    - .NET
    - Localization
---

In our last post, "[Sep Is The Short Date Format For September. Sometimes]({% post_url 2025-09-08-sep-is-the-short-date-format-for-september-sometimes %})", we looked at an issue where the short format for **September** would vary by operating system. (**Sept** vs **Sep**).

As a recap, the short month format for months in [English UK](https://en.wikipedia.org/wiki/British_English) (and many locales based on it) is as follows:

```plaintext
1 Jan 2025
1 Feb 2025
1 Mar 2025
1 Apr 2025
1 May 2025
1 Jun 2025
1 Jul 2025
1 Aug 2025
1 Sept 2025
1 Oct 2025
1 Nov 2025
1 Dec 2025
```

Note that it is **Sept** and not **Sep**.

Why is this?

So, for many years, **Sep** was used until 2021 when the [ISO](https://www.iso.org/home.html) decided to make a change.

The rationale appears to be that in the UK, **Sept** is the accepted abbreviation for **September**, as opposed to **Sep**. And so, in 2021, ISO decided to formalize this.

This meant **applications**, **vendors**, and programming languages that followed the ISO standards implemented this change, and feedback came hot and heavy almost immediately.

Whether it was [StackOverflow](https://stackoverflow.com/questions/69267710/septembers-short-form-sep-no-longer-parses-in-java-17-in-en-gb-locale), [Google Sheets](https://issuetracker.google.com/issues/175332493?pli=1), [Excel](https://techcommunity.microsoft.com/discussions/excelgeneral/excel-365-dd-mmm-yyyy-now-gives-sept-instead-of-sep/4451187), or [programming language issue trackers](https://bugs.openjdk.org/browse/JDK-8329375), comments were **fast and furious**.

The biggest objection was that [this change would needlessly break existing code](https://unicode-org.atlassian.net/browse/CLDR-14412), for **what problem was it solving**?

This is a view I happen to concurr with.

I don't believe there is anyone incapable of understanding that **Sep** is **September**, and breaking applications that have been running for years for something so pedantic makes little sense to me.

But the change has been made, and we are (presumably) stuck with it.

Things are even worse when we come to locales like [Australia](https://en.wikipedia.org/wiki/Australia) ([en-AU](https://en.wikipedia.org/wiki/Australian_English)).

```plaintext
-----
English (Australia)
-----
1 Jan 2025
1 Feb 2025
1 Mar 2025
1 Apr 2025
1 May 2025
1 June 2025
1 July 2025
1 Aug 2025
1 Sept 2025
1 Oct 2025
1 Nov 2025
1 Dec 2025
```

Here we can see that **June**, **July,** and **Sept** do not conform to the rest.

This generally isn't an issue too much when **displaying** data, but when [parsing]({% post_url 2025-06-16-locale-considerations-when-parsing-dates %})) it.

### TLDR

**Programming languages that faithfully implement ISO standards can lead to surprises if you do not follow closely the changes in the standards.**

Happy hacking!
