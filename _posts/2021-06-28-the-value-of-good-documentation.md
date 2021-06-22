---
layout: post
title: The Value Of Good Documentation
date: 2021-06-28 15:34:22 +0300
categories:
    - The Business Of Software
    - Documentation
published: false
---
As a company, our primary stack is built on .NET, and we are on a current exercise to migrate our core systems to .NET 5.0.

Recent developments, as well as strategic decisions have forced me to interface with systems and ecosystems not at code level as I am accustomed to, but at documentation level.

And one of the things that stands out the most is the following:

> Good documentation appears to be a secondary objective.

Most institutions, including my own, I must regretfully confess, spend the bulk of our attention on the UI, UX and code, and then, when we have time, the documentation.

There are a couple of reasons for this:

* Documentation is not glamorous
* Most people are not actually good at writing good documentation
* The deployed software is generally considered the primary deliverable
* The skill-set to write good code and the skill-set to write good documentation are very different.
* For documentation it is easy to conflate quality over quantity
* Good documentation cost resources (time, people and money) and seeing as everyone is cost constrained, if you need to cut costs, you start to cut the easiest targets, and documentation is first on the chopping board.

The premise behind good documentation should make it easy for someone who is totally new to the thing you are documenting to do the following:
* Understand at a broad level what your thing is, and how it works
* Understand what problems you are trying to solve
* Understand how it relates to existing technologies and how it complements / improves upon
* Drill into a deeper level the plumbing and conventions of your thing, and how to use it, preferably with samples
* A list of FAQs that addresses common issues / problems.

Let me discuss a few of the examples of documentation that does not meet its objectives..

# Invalid / Wrong Assumptions

Let us look at one of Microsoft's key APIs - the object relational management framework [Entity Framework](https://docs.microsoft.com/en-us/ef/).

Assume you have never used it at all. 

This is the home page of the technology:

![](../images/2021/06/EF%201.png)

An obvious place to start is [Getting Started](https://docs.microsoft.com/en-us/ef/core/get-started/overview/first-app).

You are immediately [dumped here](https://docs.microsoft.com/en-us/ef/core/get-started/overview/first-app?tabs=netcore-cli), where you are expected to run commands and write code.

![](../images/2021/06/EF%202.png)

But what is Entity Framework Core? And how does it relate to Entity Framework?

![](../images/2021/06/EF%203.png)

What is a context class? What is an entity class? What is a model?

I don't think it is reasonable for the authors of this documentation to assume users know these things in advance.

It doesn't get any better as you progress.

![](../images/2021/06/Ef%204.png)

Next you are expected to run a bunch of cryptic commands, with nothing but cursory explanations. What is a design package? What is a migration? What is a scaffold? Why does `database update` **create** the database?

Let me not belabour the point. This documentation is written with the assumption that the developers reading already understand the technology, design considerations, terminologies etc.

This is not a valid assumption.

Due to the fact that Microsoft's own documentation is inadequate, a whole cottage industry of alternative documentation has developed, like [Learn Entity Framework](https://www.learnentityframeworkcore.com/)

Maybe there's something in the Learn section

![](../images/2021/06/EF%205.png)

Alas!

![](../images/2021/06/Ef%206.png)

There is a laundry list of things you are already expected to know, and you get straight to writing code.

Now in terms of quantity of documentation for Entity Framework - [there is lots and lots of it](https://docs.microsoft.com/en-us/ef/core/get-started/overview/first-app?tabs=netcore-cli).

But bombarding users, especially new users, with lots of specialized documentation without fundamentals and context - does that help or hinder the adoption of the technology?

# Unhelpful Documentation

Another problem is documentation that is there, but is not helpful.

SDK / API documentation is the most notorious for this.

**Listing API end points and parameters is not complete documentation!**

Having SwaggerGen or other such tools to generate OpenAPI documentation does not mean that the documentation is complete.

You will still need to spend some time