---
layout: post
title: Handing JSON Deserialization In The Wild
date: 2024-12-16 06:42:41 +0300
categories:
    - C#
    - JSON
---

Deserializing JSON is typically a very straightforward affair, and the recommended JSON Serializer, [Sysem.Text.Json](https://learn.microsoft.com/en-us/dotnet/api/system.text.json?view=net-9.0), typically handles this easily.

Given this model:

```csharp
public class WeatherForecast
{
  public DateTime Date { get; init; }
  public int Temperature { get; set; }
  public string Summary { get; set; }
};
```

And this JSON:

```json
{
  "Date": "2024-12-17T23:38:10.775738+03:00",
  "Temperature": 40,
  "Summary": "Hot"
}
```

Deserialization is straightforward:

```csharp
var weatherForecast = JsonSerializer.Deserialize<WeatherForecast>(json);
	
Console.WriteLine(weatherForecast);
```

This will print the following:

```plaintext
WeatherForecast { Date = 17/12/2024 23:38:10, Temperature = 0, Summary = Hot }
```

Now assume the JSON had a slight difference - the temperature was encoded as a `string`. Like this:

```json
{
  "Date": "2024-12-17T23:38:10.775738+03:00",
  "Temperature": "40",
  "Summary": "Hot"
}
```

If we run the code again, we get an exception:

```plaintext
dotnet run

Unhandled exception. System.Text.Json.JsonException: The JSON value could not be converted to System.Int32. Path: $.Temperature | LineNumber: 0 | BytePositionInLine: 61.
 ---> System.InvalidOperationException: Cannot get the value of a token type 'String' as a number.
   at System.Text.Json.ThrowHelper.ThrowInvalidOperationException_ExpectedNumber(JsonTokenType tokenType)
   at System.Text.Json.Utf8JsonReader.TryGetInt32(Int32& value)
   at System.Text.Json.Serialization.Metadata.JsonPropertyInfo`1.ReadJsonAndSetMember(Object obj, ReadStack& state, Utf8JsonReader& reader)
   at System.Text.Json.Serialization.Converters.ObjectDefaultConverter`1.OnTryRead(Utf8JsonReader& reader, Type typeToConvert, JsonSerializerOptions options, ReadStack& state, T& value)
   at System.Text.Json.Serialization.JsonConverter`1.TryRead(Utf8JsonReader& reader, Type typeToConvert, JsonSerializerOptions options, ReadStack& state, T& value, Boolean& isPopulatedValue)
   at System.Text.Json.Serialization.JsonConverter`1.ReadCore(Utf8JsonReader& reader, T& value, JsonSerializerOptions options, ReadStack& state)
   --- End of inner exception stack trace ---
   at System.Text.Json.ThrowHelper.ReThrowWithPath(ReadStack& state, Utf8JsonReader& reader, Exception ex)
   at System.Text.Json.Serialization.JsonConverter`1.ReadCore(Utf8JsonReader& reader, T& value, JsonSerializerOptions options, ReadStack& state)
   at System.Text.Json.Serialization.Metadata.JsonTypeInfo`1.Deserialize(Utf8JsonReader& reader, ReadStack& state)
   at System.Text.Json.JsonSerializer.ReadFromSpan[TValue](ReadOnlySpan`1 utf8Json, JsonTypeInfo`1 jsonTypeInfo, Nullable`1 actualByteCount)
   at System.Text.Json.JsonSerializer.ReadFromSpan[TValue](ReadOnlySpan`1 json, JsonTypeInfo`1 jsonTypeInfo)
   at Program.<Main>$(String[] args) in /Users/rad/Projects/Temp/TestConsole/Program.cs:line 7
```

This is easily fixable.

We create an instance of a [JsonSerializationOptions](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions?view=net-9.0) and configure it as follows:

```csharp
var options = new JsonSerializerOptions
{
    NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.AllowReadingFromString
};
var weatherForecast = JsonSerializer.Deserialize<WeatherForecast>(json, options);

Console.WriteLine(weatherForecast);
```

It now works as before.

We can also run into a situation where the property attributes in the JSON are [camel-cased](https://simple.wikipedia.org/wiki/CamelCase).

```json
{
  "date": "2024-12-17T23:38:10.775738+03:00",
  "temperature": "40",
  "summary": "Hot"
}
```

If we run the code, we get a surprising result:

```plaintext
WeatherForecast { Date = 01/01/0001 00:00:00, Temperature = 0, Summary =  }
```

All of the properties appear to be initialized to default values.

This is because, by default, the serializer expects the properties in the JSON to match exactly with the properties of the type to deserialize. Since it can't match them it initializes every property to its default values.

This is easily fixable, by extending the `JsonSerializerOptions` to tell the serializer to treat the property names as case insensitive.

```csharp
var options = new JsonSerializerOptions
{
  NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.AllowReadingFromString,
  PropertyNameCaseInsensitive = true
};
var weatherForecast = JsonSerializer.Deserialize<WeatherForecast>(json, options);

Console.WriteLine(weatherForecast);
```

This prints the expected result:

```plaintext
WeatherForecast { Date = 15/12/2024 23:38:10, Temperature = 40, Summary = Hot }
```

These two scenarios are very common on the web with JSON that is produced by other systems and/or in other programming languages.

If the JSON is produced by you, the serializer, by default, will generate JSON that matches the type property name with the JSON attributes, and numbers will not be output as strings.

If not, you can deal with the abovementioned situation with the `JsonSerializerOptions`.

This issue is so common that you can handle this scenario without directly creating your own `JsonSerializerOptions`.

You can rewrite the code as follows:

```charp
var weatherForecast = JsonSerializer.Deserialize<WeatherForecast>(json, JsonSerializerOptions.Web);

Console.WriteLine(weatherForecast);
```

Here, rather than create your own `JsonSerializationOption`, we pass a default - [JsonSerializerOptions.Web,](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializeroptions.web?view=net-9.0) which sets the defaults as outlined [here](https://learn.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializerdefaults?view=net-9.0) in the Web enum.

This makes the code able to process a vast majority of the JSON in the wild.

If you want default behaviour, you can either not pass any `JsonSerializationOptions` at all or explicitly request default behaviour by passing `JsonSerializerOptions.Default`

Happy hacking!