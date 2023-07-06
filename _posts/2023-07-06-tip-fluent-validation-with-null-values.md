---
layout: post
title: Tip - Fluent Validation With Null Values
date: 2023-07-06 15:48:18 +0300
categories:
    - .NET
    - Validation
    - Libraries
---
There is an excellent library, [FluentValidation](https://fluentvalidation.net/), that is very handy when it comes to expressing validation logic, and doing it centrally.

Suppose we have the following class:


```csharp
public class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}
```

We can express validation logic by inheriting from the generic abstract class [AbstractValidator](https://docs.fluentvalidation.net/en/latest/start.html) and then supplying our logic.

Like this:

```csharp
public class PersonValidator : AbstractValidator<Person>
{
    public PersonValidator()
    {
        RuleFor(x => x.Name)
            .MinimumLength(5)
            .MaximumLength(10);
        
        RuleFor(x => x.Age)
            .GreaterThan(18);
    }
}
```

Our logic here is:

1. Age must be **greater** than 18
1. Name must have a **length** between **5** and **10** characters

Our logic to validate is as simple as this:

```csharp
var person = new Person() { Name = "", Age = 30 };
var validator = new PersonValidator();
validator.ValidateAndThrow(person);
```

This code will throw an exception if any of the validations is not satisfied.

So the code above will throw this exception:

```plaintext
Validation failed:
 -- Name: The length of 'Name' must be at least 5 characters. You entered 0 characters. Severity: Error
```

So far so good - if you provide an empty string as a name, it will throw an exception.

Suppose someone supplies a `null` as the name.

Like so:

```csharp
var person = new Person() { Name = null, Age = 30 };
var validator = new PersonValidator();
validator.ValidateAndThrow(person);
```

You'd think the logic for minimum and maximum length would catch this.

You would be wrong.

A `null` will successfully pass validation!

To address this issue, you need to add an additional validation - [NotEmpty()](https://docs.fluentvalidation.net/en/latest/built-in-validators.html?highlight=notempty#notempty-validator)

```csharp
public class PersonValidator : AbstractValidator<Person>
{
    public PersonValidator()
    {
        RuleFor(x => x.Name)
            .NotEmpty()
            .MinimumLength(5)
            .MaximumLength(10);
        
        RuleFor(x => x.Age)
            .GreaterThan(18);
    }
}
```

This has the additional benefit of rejecting strings that are whitespace.

If you run the validator you should get the following result:

```plaintext
Validation failed:
 -- Name: 'Name' must not be empty. Severity: Error
```

If you don't want to throw an exception but want to get the errors anyway, you can do it like this:

```csharp  

var result = validator.Validate(person);
```

From here you can either get a [dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-7.0) of properties and errors, like this:

```csharp
result.ToDictionary();
```


Or you can get a single string of all the errors, like this:

```csharp
result.ToString();
```

Happy hacking!