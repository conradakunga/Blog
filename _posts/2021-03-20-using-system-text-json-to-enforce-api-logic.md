---
layout: post
title: Using System.Text.Json To Enforce API Logic
date: 2021-03-20 16:52:43 +0300
categories:
    - Design
    - API
    - System.Text.Json
---
Assume you have the following type:

```csharp
public class Person
{
    public string FirstName { get; set; }
    public string Surname { get; set; }
    public DateTime DateOfBirth { get; set; }
}
```

And in the context of your work you decide that you need some anti-money laundering functionality.

The vendor tells you that they have a REST API for this very purpose, and the payload to request a verification process is as follows:

```json
{
    "fullname":"string",
    "age":int,
    "dateOfBirth":"string"
}
```


The vendor further says that the string is formatted as `YYYY-MM-dd`.

An obvious way to tackle this problem is to write some sort of converter that translates from our native class to the representation expected.

We start by pulling the data we need

```csharp
// build the data we need
var name = p.FirstName + " " + p.Surname;
var age = DateTime.Now.Year - p.DateOfBirth.Year;
var dateOfBirth = DateTime.Now.ToString("yyyy-MM-dd");
```
            
Next we construct the Json payload. 

First we make use of [anonymous types](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/anonymous-types) to create a new object with the properties that we want.

Next we use the [System.Text.Json](https://docs.microsoft.com/en-us/dotnet/api/system.text.json?view=net-5.0) serializer to generate the Json. During the serialization process, we have instructed the serializer to indent the values.

```csharp
// create the object payload
var payload = new 
{ 
    fullName = name, 
    age = age, 
    dateOfBirth = dateOfBirth 
};

var json = JsonSerializer.Serialize(payload, new JsonSerializerOptions() { WriteIndented = true });
return json;
```

This solution works, but has a couple of drawbacks:
1. It is brittle, and requires additional indirection.
2. The logic for the class is now in multiple places.
3. It is possible for subtle bugs to be introduced into this processing code.

A better solution is to make use of the original type and some simple techniques.

The first thing we can tackle is the generation of the Json using our prior knowledge of the Json serializer.

```csharp
var person = new Person()
{
    FirstName = "Donald",
    Surname = "Trump",
    DateOfBirth = new DateTime(1960, 1, 1)
};
var json = JsonSerializer.Serialize(person, new JsonSerializerOptions() { WriteIndented = true });
```
 This produces the following Json:
 
```json
{
    "FirstName": "Donald",
    "Surname": "Trump",
    "DateOfBirth": "1960-01-01T00:00:00"
}
```
This clearly violates our contract.

We can begin by addressing the `fullName`.
  
This we can achieve using an expression.

```csharp
public class Person
{
    public string FirstName { get; set; }
    public string Surname { get; set; }
    public string FullName => $"{FirstName} {Surname}";
    public DateTime DateOfBirth { get; set; }
}
```

If we run our serialization code, we get this:

```json
{
  "FirstName": "Donald",
  "Surname": "Trump",
  "FullName": "Donald Trump",
  "DateOfBirth": "1960-01-01T00:00:00"
}
```
Next, we fix the age - another expression.

```csharp
public class Person
{
	public string FirstName { get; set; }
	public string Surname { get; set; }
	public string FullName => $"{FirstName} {Surname}";
	public DateTime DateOfBirth { get; set; }
	public int Age => DateTime.Now.Year - DateOfBirth.Year;
}
```

When we serialize we get the following:

```csharp
{
  "FirstName": "Donald",
  "Surname": "Trump",
  "FullName": "Donald Trump",
  "DateOfBirth": "1960-01-01T00:00:00",
  "Age": 61
}
```
Our next issue is the `dateOfBirth`.

We could change it to be a string, but it is always better to use native types.

A better option is to create another expression to format our data correctly, and then submit that instead.

```csharp
public class Person
{
    public string FirstName { get; set; }
    public string Surname { get; set; }
    public string FullName => $"{FirstName} {Surname}";
    [JsonIgnore]
    public DateTime DateOfBirth { get; set; }
    public string DateOfString => DateOfBirth.ToString("yyyy-MM-dd");
    public int Age => DateTime.Now.Year - DateOfBirth.Year;
}
```

The attribute [JsonIgnore](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.serialization.jsonignoreattribute?view=net-5.0) instructs the serializer to skip our native date of birth.

Our Json now is as follows:

```json
{
  "FirstName": "Donald",
  "Surname": "Trump",
  "FullName": "Donald Trump",
  "DateOfString": "1960-01-01",
  "Age": 61
}
```

But our contract is still not correct - the name is not correct.

This we can fix with another attribute  [JsonPropertyName](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.serialization.jsonpropertynameattribute?view=net-5.0)

```csharp
public class Person
{
	public string FirstName { get; set; }
	public string Surname { get; set; }
	public string FullName => $"{FirstName} {Surname}";
	[JsonIgnore]
	public DateTime DateOfBirth { get; set; }
	[JsonPropertyName("DateOfBirth")]
	public string DateOfString => DateOfBirth.ToString("yyyy-MM-dd");
	public int Age => DateTime.Now.Year - DateOfBirth.Year;
}
```
This attribute allows us to override the property name.

Our result now should be this:

```json
{
  "FirstName": "Donald",
  "Surname": "Trump",
  "FullName": "Donald Trump",
  "DateOfBirth": "1960-01-01",
  "Age": 61
}
```

We can then further remove the `FirstName` and `Surname` using the `JsonIgnore` attribute.

```csharp
public class Person
{
    [JsonIgnore]
    public string FirstName { get; set; }
    [JsonIgnore]
    public string Surname { get; set; }
    public string FullName => $"{FirstName} {Surname}";
    [JsonIgnore]
    public DateTime DateOfBirth { get; set; }
    [JsonPropertyName("DateOfBirth")]
    public string DateOfString => DateOfBirth.ToString("yyyy-MM-dd");
    public int Age => DateTime.Now.Year - DateOfBirth.Year;
}
```
Our Json should now be as follows:

```json
{
  "FullName": "Donald Trump",
  "DateOfBirth": "1960-01-01",
  "Age": 61
}
```

But this is still not 100% correct.

Some parsers are very case sensitive - our code is using `PascalCase` but the json contract is in `camelCase`.

We could rename our properties but that would be an overkill - our code is not specifically for the API.

Alternatively, we could use `JsonPropertyName` attribute to change the name.

But the best way is to let the serializer handle it for us.

```csharp
var person = new Person()
{
    FirstName = "Donald",
    Surname = "Trump",
    DateOfBirth = new DateTime(1960, 1, 1)
};
var json = JsonSerializer.Serialize(person, new JsonSerializerOptions() 
{ 
    WriteIndented = true, 
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
});
```

Here we are using the [JsonSerializerOption](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions?view=net-5.0) to, in addition to indenting the attributes, to [CamelCase](https://en.wikipedia.org/wiki/Camel_case) them.

Our results should be as follows:

```json
{
  "fullName": "Donald Trump",
  "DateOfBirth": "1960-01-01",
  "age": 61
}
```

Notice that the `DateOfBirth` is still not correct- this is because the serializer does not override the `JsonProperty` attribute. That we have to change ourselves.

```csharp
public class Person
{
	[JsonIgnore]
	public string FirstName { get; set; }
	[JsonIgnore]
	public string Surname { get; set; }
	public string FullName => $"{FirstName} {Surname}";
	[JsonIgnore]
	public DateTime DateOfBirth { get; set; }
	[JsonPropertyName("dateOfBirth")]
	public string DateOfString => DateOfBirth.ToString("yyyy-MM-dd");
	public int Age => DateTime.Now.Year - DateOfBirth.Year;
}
```

I like to think that the serializer will be updated to handle other casing types - PascalCase, snake_case

Our final Json is as follows:
```json
{
  "fullName": "Donald Trump",
  "dateOfBirth": "1960-01-01",
  "age": 61
}
```

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-03-24%20-%20Using%20System.Text.Json%20To%20Enforce%20API%20Logic).

Happy hacking!