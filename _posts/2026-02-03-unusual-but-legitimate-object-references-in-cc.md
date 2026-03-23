---
layout: post
title: Unusual (But Legitimate) Object References In C/C++
date: 2026-02-03 11:32:40 +0300
categories:
    - C
    - C++
---

When accessing an `array` in [C](https://en.wikipedia.org/wiki/C_(programming_language))/[C++](https://en.wikipedia.org/wiki/C%2B%2B) (and, indeed, many [C-based languages](https://en.wikipedia.org/wiki/List_of_C-family_programming_languages)), you would access a particular element in an `int` `array` like this:

```c++
// Create and initialize an array of 5 numbers
int numbers[] =  {1,2,3,4,5};
// Print the fifth
std::cout << numbers[4] << std::endl;
```

This will print, as we expect, `5`.

This also works with `strings`:

```c++
// Create and initialize a char array
char hello[] = "Hello\t";
// Print the third letter
std::cout << hello[1] << std::endl;
```

This will print, as we expect, `e`.

What you might not know is that it is also 100% legit to do this:

```c++
 std::cout << 1[hello] << std::endl;
```

This will print the same result.

These are also variations that will work:

```c++
std::cout << *( hello + 3 ) << std::endl;
std::cout << *( 3 + hello ) << std::endl;
```

Why does this work? Because `arrays` are ultimately [pointers](https://en.wikipedia.org/wiki/Pointer_(computer_programming)), and what we are doing is [pointer arithmetic](https://www.w3schools.com/c/c_pointers_arithmetic.php).

Happy hacking!
