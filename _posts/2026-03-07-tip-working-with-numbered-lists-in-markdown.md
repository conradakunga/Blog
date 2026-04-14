---
layout: post
title: Tip - Working With Numbered Lists In Markdown
date: 2026-03-07 13:45:32 +0300
categories:
    - MarkDown
---

This blog is written in [Markdown](https://www.markdownguide.org/), with the [Ruby](https://www.ruby-lang.org/en/) built [Jekyll](https://jekyllrb.com/) platfom. The source is available [here](https://github.com/conradakunga/Blog).

When composing a [numbered list,](https://www.markdownguide.org/basic-syntax/#lists-1) you do it like so:

```plaintext
1. One
2. Two
3. Three
4. Four
5. Five
```

Which, unsurprisingly, will render like this:

1. One
2. Two
3. Three
4. Four
5. Five

The problem arises when you need to insert a number midway in the list.

```plaintext
1. One
2. Two
<-- INSERT HERE -->
3. Three
4. Four
5. Five
```

You have some options here.

The first is you **re-order the numbers** to accomodate the new row.

```plaintext
1. One
2. Two
3. INSERT HERE
4. Three
5. Four
6. Five
```

1. One
2. Two
3. INSERT HERE
4. Three
5. Four
6. Five


The second is you just put an **arbitrary number**.

```plaintext
1. One
2. Two
6. INSERT HERE
4. Three
5. Four
6. Five
```

1. One
2. Two
6. INSERT HERE
4. Three
5. Four
6. Five


The third, and clearner solution is to just **number everything `1`**.

```plaintext
1. One
1. Two
1. INSERT HERE
1. Three
1. Four
1. Five
```

1. One
1. Two
1. INSERT HERE
1. Three
1. Four
1. Five


As you can see, in all these cases the list is renderend correctly.

My preference is to use the latter where all the indexes are `1`.

This isn't very much of an issue if you are using an **intelligent editor** that will **re-order the indexes for you**. For example I am currenty using [Typora](https://typora.io/), which does this for me.

### TLDR

**If you are working on a numbered list whose elements are fluid, number them all `1` to make it more decipherable, especially if you are not using an intelligent edtor.**

Happy hacking!