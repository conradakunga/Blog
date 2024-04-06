---
layout: post
title: Using Inheritance With FluentValidation
date: 2024-04-06 12:29:39 +0300
categories:
    - C#
    - FluentValidation
---
If you are a .NET developer, you really need to be using the [FluentValidation](https://fluentvalidation.net/) library.

This is an excellent library that is very powerful and very expressive, allowing you to write all sorts of validation code in a central place and reuse it across contexts - WebAPI, console applications, class libraries, etc.

Let me demonstrate by way of example.

Assume we have a `Person` class like this:

```csharp
public record Person
{
    public required string Name { get; init; } = null!;
    public required DateOnly DateOfBirth { get; init; }
}
```

We can write a validator by first of all adding the library to our project.

 `dotnet add package fluentvalidation`

We then create a class that subclasses the generic `AbstractValidator` type, and then write our validations in the constructor.

```csharp
public class PersonValidator : AbstractValidator<Person>
{
    public PersonValidator()
    {
        // The name must be specified, with a custom error message
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Please specify a name!");
        // The length of the name must be between 5 and 50 characters
        RuleFor(x => x.Name)
            .MinimumLength(5)
            .MaximumLength(50);
        // Date of birth cannot be today or later
        RuleFor(x => x.DateOfBirth).LessThan(DateOnly.FromDateTime(DateTime.Now));
    }
}
```

We can then setup a unit test to verify our testing logic.

```csharp
[Fact]
public void Person_When_Invalid_Throws_3_Errors()
{
    var person = new Person
    {
        Name = "",
        DateOfBirth = DateOnly.FromDateTime(DateTime.Now)
    };

    var validator = new PersonValidator();
    var result = Record.Exception(() => validator.ValidateAndThrow(person))!;
    result.Should().BeOfType<ValidationException>();
    var errors = ((ValidationException)result).Errors.Count();
    errors.Should().Be(3);
}
```

`Should()` here is from the use of the excellent [FluentAssertions](https://fluentassertions.com/) library.

Here I am expecting a `ValidationException`, so after capturing the `Exception` from xUnit, I cast it to the appropriate type so that I can count the number of failed validations.

I am expecting 3:
1. The name, an empty string, was not provided
1. The name, an empty string, has a string length that is less than the required minimum, 5
1. The date of birth is the current date, and the logic says the date of birth cannot be today or later.

We can then verify our code works with a passing test

```csharp
[Fact]
public void Person_When_Valid_Succeeds()
{
    var person = new Person
    {
        Name = "James Bond",
        DateOfBirth = new DateOnly(1960, 1, 1)
    };

    var validator = new PersonValidator();
    var result = Record.Exception(() => validator.ValidateAndThrow(person))!;
    result.Should().BeNull();
}
```

Great.

Now, imagine we are building a school administration application, and we have a `Teacher` entity. A teacher is a `Person`, but has an additional Subject property.

We can therefore inherit `Person` and add the new property.

```csharp
public record Teacher : Person
{
    public required string Subject { get; init; } = null!;
}
```

Now, we also need to write a validator for this.

It is tempting to simply copy the validation code from the person and do this:

```csharp
public class TeacherCopyValidator : AbstractValidator<Teacher>
{
    public TeacherCopyValidator()
    {
        // The name must be specified, with a custom error message
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Please specify a name!");
        // The length of the name must be between 5 and 50 characters
        RuleFor(x => x.Name)
            .MinimumLength(5)
            .MaximumLength(50);
        // Date of birth cannot be today or later
        RuleFor(x => x.DateOfBirth).LessThan(DateOnly.FromDateTime(DateTime.Now));
        // Subject must be specified!
        RuleFor(x => x.Subject).NotEmpty().WithMessage("The subject the teacher takes must be specified!");
    }
}
```

Which works.

The problem is now we have duplicate code in two places and you have to remember to make modifications / bug fixes in both places. And update two sets of tests.

A bad thing.

We can leverage the code that we have already written in the `PersonValidator` by using inheritance.

The first change is to make the `PersonValidator` generic. The rationale being we are making it aware that it can be passed anything inheriting `Person` - such as a `Teacher`.

It will now look like this:

```csharp
public class PersonValidator<T> : AbstractValidator<T> where T : Person
{
    public PersonValidator()
    {
        // The name must be specified, with a custom error message
        RuleFor(x => x.Name)
            .NotEmpty().WithMessage("Please specify a name!");
        // The length of the name must be between 5 and 50 characters
        RuleFor(x => x.Name)
            .MinimumLength(5)
            .MaximumLength(50);
        // Date of birth cannot be today or later
        RuleFor(x => x.DateOfBirth).LessThan(DateOnly.FromDateTime(DateTime.Now));
    }
}
```

We then subclass this to implement a `TeacherValidator`, like this:

```csharp
public class TeacherValidator : PersonValidator<Teacher>
{
    public TeacherValidator()
    {
        // Subject must be specified!
        RuleFor(x => x.Subject).NotEmpty().WithMessage("The subject the teacher takes must be specified!");
    }
}
```

What we are getting here is the following:
1. Ability for the `TeacherValidor` to leverage the code in the `PersonValidator`
1. Ability for a `PersonValidator` to also validate a teacher directly.

    In other words, this code will work:
    
    ```csharp
    var teacher = new Teacher
    {
        Name = "",
        DateOfBirth = DateOnly.FromDateTime(DateTime.Now),
        Subject = ""
    };
    
    var validator = new PersonValidator<Person>();
    ```
      
    As will this:
    
    
    ```csharp
    var teacher = new Teacher
    {
        Name = "",
        DateOfBirth = DateOnly.FromDateTime(DateTime.Now),
        Subject = ""
    };
    
    var validator = new PersonValidator<Teacher>();
    ```

Now you might ask what if there is a third level of inheritance.

Not a problem.

Suppose we have a `Headmaster`, who is also a `Teacher`.

```csharp
public record Headmaster : Teacher
{
    public DateOnly AppointmentDate { get; init; }
}
```

We can still leverage this architecture.

All we need to do is modify the `TeacherValidator` to make it generic aware; that it can be passed a `Teacher` or a `Headmaster`.

```csharp
public class TeacherValidator<T> : PersonValidator<T> where T : Teacher
{
    public TeacherValidator()
    {
        // Subject must be specified!
        RuleFor(x => x.Subject).NotEmpty().WithMessage("The subject the teacher takes must be specified!");
    }
}
```

We then implement our `Headmaster` validator.

```csharp
public class HeadmasterValidator<T> : TeacherValidator<T> where T : Headmaster
{
    public HeadmasterValidator()
    {
        // Appointment date must be specified!
        RuleFor(x => x.AppointmentDate)
            .NotEmpty();
        // Appointment date must be in the past
        RuleFor(x => x.AppointmentDate)
            .LessThan(DateOnly.FromDateTime(DateTime.Now));
    }
}
```

Again, a `Headmaster` (at least the relevant attributes) can be validated by:
1. `PersonValidator`
1. `TeacherValidator`

The beauty of this approach is that every inherited validator has access to the child properties of the parent object being validated.

you can cascade the validations and do things like this:

1. A headmaster must be at least 20 years old
1. A headmaster cannot be a Mathematics teacher

We can start by adding a computed property to the base `Person`

```csharp
public record Person
{
    public required string Name { get; init; } = null!;
    public required DateOnly DateOfBirth { get; init; }
    // Compute the age as difference between birth year and current year
    public int Age => DateOnly.FromDateTime(DateTime.Today).Year - DateOfBirth.Year;
}
```

We can then improve our `HeadmasterValidator` like this:

```csharp
public class HeadmasterValidator<T> : TeacherValidator<T> where T : Headmaster
{
    public HeadmasterValidator()
    {
        // Appointment date must be specified!
        RuleFor(x => x.AppointmentDate)
            .NotEmpty();
        // Appointment date must be in the past
        RuleFor(x => x.AppointmentDate)
            .LessThan(DateOnly.FromDateTime(DateTime.Now));
        // Headmaster cannot be a maths teacher
        RuleFor(x => x.Subject)
            .NotEqual("Mathematics").WithMessage("The headmaster cannot be a Mathematics teacher");
        // Headmaster must be at least 20 years old. Return the actual age in the error message (filled by the {PropertyValue} placeholder)
        RuleFor(x => x.Age)
            .GreaterThanOrEqualTo(20)
            .WithMessage(
                "The headmaster is currently {PropertyValue} and therefore is too young. Should be 20 or older");
    }
}
```

This means any improvements we make to the parent classes are available for free to the children and their validators.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2024-04-06%20-%20Using%20Inhertince%20With%20FluentValidation).

Happy hacking!

