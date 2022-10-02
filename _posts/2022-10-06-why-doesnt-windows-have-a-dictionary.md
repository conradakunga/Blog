---
layout: post
title: Why Doesn't Windows Have A Dictionary
date: 2022-10-06 12:18:22 +0300
categories:
    - The Business Of Software
---
"Why," a CEO friend of mine asked one day in exasperation "doesn't Windows have a dictionary?"

"A dictionary?" I asked.

"Yes." She pushed back her laptop in visible frustration. "You know - right click a word and it gives me the definition. Like my iPhone does. How hard can it be?"

If there's one thing I know for a fact is that writing software of any kind is harder than you'd think.

"I don't know, to be honest. But I am 100% sure at some point someone thought about it and wanted to do it and then ran into some challenges."

"What sort of challenges?"

"The first one is very simple. Which dictionary are you going to include?"

"English I guess. You can detect which version of Windows someone is using and then just use the corresponding language."

"So which English? US? UK? Australia?"

"Oh. I guess you can be asked which one the first time you launch."

"Which brings me to the second point - you have to maintain dictionaries for several languages and dialects. Which in itself is a lot of work. But the other problem is how do you update them?"

"Update them?"

"Language is fluid. So words are being added all the time. Assuming you have cracked the problem of keeping track of these changes and updating your databases, how do you get these out to users?"

"Ah. Gotcha. I guess there will need to be machinery to keep track of all these additions to all these databases and maybe using Windows Update or something push out the changes?"

"Correct. And remember you're doing this for English, French, Japanese, etc."

"Whoa. Ok."

"Then there is the question of where this feature is to be deployed."

"Pardon?"

"Well, you were asking about Windows. What version of Windows do you have there?"

"Windows 10." She said.

"Right. windows 10 is the consumer operating system. What about Windows Server? Would it also have the dictionary?"

"Er ... I suppose. Don't administrators want to know the meaning of words too?"

"Undoubtedly. So if you add that to the server operating system that means they have yet another thing to include in their operating system. Which means additional risk and therefore additional audits, design considerations and costs. But we will revisit this."

"Er... OK."

"Were you thinking about the dictionary as a standalone app or as a thing available across the system? I imagine the latter."

"Yes."

"Then that means this dictionary is something that the operating system will offer as a service. Which is the logical way to approach this. That means all user apps, old and new, can take advantage of it."

"That's right."

"So now you have added work to the operating systems team, who have to accommodate this in the core operating system. You also have to get them to offer APIs to this function to popup definitions, menus, etc. You also have to get the guys who do the various Windows SDKs to update them with wrappers to these APIs. You also need to get the documentation guys to not only document the new feature, but also to write sample code in various languages to demonstrate this."

"Oh!"

