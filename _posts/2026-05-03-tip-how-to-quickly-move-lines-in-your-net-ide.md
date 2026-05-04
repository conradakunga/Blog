---
layout: post
title: Tip - How To Quickly Move Lines In Your .NET IDE
date: 2026-05-03 18:40:03 +0300
categories:
    - Tip
    - Development
---

Suppose you are working in your favourite IDE and need to move a line of code `3` lines up.

How you would do it depends on whether you are a **novice** or a **master**.

A **novice** would:

1. **Select the entire line** with their mouse (or keyboard if they are especially adept)
2. **Cut** - keyboard `Control` / `Command` , `x`
3. Move the cursor three rows up (using mouse or keyboard)
4. **Paste** - keyboard `Control` / `Command`, `v`

A **master** would probably use [vi](https://www.vim.org/) key bindings and do the following:

1. **Cut** the entire line and put the contents in the buffer - keystroke. `d`,`d`
2. **Move** three lines up - keystroke `3`, `k`
3. **Paste** the contents of the buffer - keystroke `p`

There is a better way for **Zen** masters.

1. **Place the cursor** on the line you want to move
2. Press and hold the `ALT` key
3. Press the up arrow  ⬆️ as many times as you want the line to move up

<video controls>
<source src="../images/2026/05/ALTMoveText.mp4"/>
</video>

To move lines **down**, use the down arrow, ⬇️ .

This works with the following IDEs:

1. [Visual Studio](https://visualstudio.microsoft.com/)
2. [Visual Studio Code](https://code.visualstudio.com/)
3. [JetBrains Rider](https://www.jetbrains.com/rider/) (if you use Visual Studio bindings)

Happy hacking!

