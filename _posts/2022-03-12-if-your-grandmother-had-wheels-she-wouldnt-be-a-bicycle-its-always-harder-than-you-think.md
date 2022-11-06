---
layout: post
title: If Your Grandmother Had Wheels - She Wouldn't Be A Bicycle - Its ALWAYS Harder Than You Think
date: 2022-03-12 14:47:31 +0300
categories:
    - Business Of Software
---
"I have an idea!" a friend said breathlessly.

"I'm all ears, my son!" I answered.

"I'm always fogetting birthdays. So I'm going to build a web app where I will enter a name, an age, email anddress, phone number and a date - and when the time comes my app will send a happy birthday email and a text message! Spin this up on the cloud as SAAS and make some quick money from users."

This was music to my ears. I have precisely this problem as well, which, I can assure you, strains relationships. A webapp like this would certainly get my interest.

"Good stuff", I told my friend. "When can I access the prototype?"

"Oh it was just a few minutes of work - a React website with a Postgres database in the cloud. Let me send you the link to collect data."

![](../images/2022/03/Screen%201.png)

A couple of problems leapt out immediately.

"This age. You do realize it increments every year, right?"

"Oh shoot. Yes, that's right!"

"Also, this phone number - you are assuming the contact is in Kenya. What if they aren't?"

"Yes, I should tell them to enter the country code as well."

"Also, is this date 11 March or 3 November? Allowing people to type the date is too ambitious. Some people, like those in the UK will use day-month-year and others, like those in the US will use month-day-year. Others, like those in Japan, will use year-month-day."

"Good catch. Let me update the design."

Version 2 came out half an hour later.

![](../images/2022/03/Screen%202.png)

"Much better. But the phone number is still a problem."

"Why? Everyone knows their country code, surely."

"Yes, but remember this is me keying in the data. I know my friend Sonia is in Botwsana but I can't offhand remember the country code."

"Humph. Ok. What else?"

"What is this notification date? How is it different from the Date Of Birth?"

"You're right. That might not be necessary. Let me update the design."

Version 3 came out half an hour later.

![](../images/2022/03/Screen%203.png)

"Out of curiosity, what exactly does the message you send say?"

> Dear Bart,
> 
> On this occasion of your 11th birthday, I wanted to wish you the best today and going foward

"How does your system know to use 'Bart' in the messages?"

"I just pick the first name you enter."

"Hmm. That might be a problem. What if the person is named Mary Louise Parker? Mary Louise here is one name. Also, some pople (like me) would key it in as Simpson, Bart."

"Ugh. Fine. Let me update the protptype."

Version 4 came out 30 minutes later.

![](../images/2022/03/Screen%204.png)

"I hope you realize that not everyone has only two names. I myself, as you know, have four."

"Ah yes. My fault. Give me 20 minutes."

Version 5 came out 20 minutes later.

![](../images/2022/03/Screen%205.png)

"So remind me again how the message is constructed?"

"I take the first name and apply it to the template."

> Dear [First Name],
> 
> On this occasion of your 11th birthday, I wanted to wish you the best today and going foward

"I see. Well, I happen to know that Rihnana's government name is [Robyn Rihanna Fenty](https://en.wikipedia.org/wiki/Rihanna). Robyn is in fact her first name, but I'm pretty sure most people call her Rihanna. If it the message said "Robyn" she would know this is just some automated bot."

"Ugh!"

"Also, there are people who legally have one name. These are called mononyms. For example the former Emperor of Japan, [Akihito](https://en.wikipedia.org/wiki/Akihito). Or [Cher](https://en.wikipedia.org/wiki/Cher). How would I save these in your system?"


"Man, you're killing me here! Gime me 30."

Version 6 came out 30 minutes later.

![](../images/2022/03/Screen%206.png)

"Walk me through how it works now?"

"Well, regardless of the names keyed in, `Display Name` is used in the message."

"I see. How do you protect from abuse?"

"Abuse? What do you mean?"

"What stops me from keying in **ASS** as the display name?"

"WHAT? Should I screen the names input?"

"I dunno. Should you?"

"Oh my!"

"Just so you know, Dick is not an unusual legit name in the UK."

"Good Lord!"

"I'll leave you to think about that. Another question - what if I keyed in data in Mandarin. Or Kanji. Would your app work?"

"I ... I dunno. Why wouldn't it?"

"Well, you can't assume everyone speaks English. If you have to store data in a language other than English your database needs to be prepared accordigly otherwise your data will be converted to gibberish. In short, your database needs to be setup as [unicode](https://en.wikipedia.org/wiki/Unicode) aware to cater for almost all languages."

"Let me check with my DBA. Give me 15"

--- Interlude ---

"Hello? You were right. We've had to recreate the database and re-import the test data."

"Great. Tell me, what are you going to do about Ethiopia?"

"Ethiopia? Why?"

"This would be a good time to tell you that Ethiopia does not use the [Gregorian Calendar](https://en.wikipedia.org/wiki/Gregorian_calendar), but [has its own](https://en.wikipedia.org/wiki/Ethiopian_calendar) - a year has 12 months of 30 days and then a 13th month that has either 5 or 6 days, depending on if it is a leap year."

"What?!"

"There are also a bunch of other calendars used besides those two. [Hebrew](https://en.wikipedia.org/wiki/Hebrew_calendar), for example. And The [Egyptian](https://en.wikipedia.org/wiki/Egyptian_calendar). And some others I forget. You'll have to research them."

"I thought birthdays was a very simple concept! How hard can it be?"

"Quite, it would appear. Another question. I imagine if my birthday is on 1 December I should get the messages at some point on 1 December, right?"

"Right."

"So what time does your app send the messages?"

"Midnight!"

"Midnight whose time?"

"I don't understand your question."

"Assume your servers are in Nairobi. Your friend Seanice is in South Africa. I happen to know Cape Town is 1 hour behind Nairobi. So if your server sends the messages at midnight Kenyan time, Seanice will receive her text and email at 11.00, South African time. The day BEFORE her birthday."

"Ah. I get you. Why then can't we use the country drop down we use for the phone number for this purpose?"

"Well, I happen to know a lot of people who live on border towns happen to have lines of the neighbouring country."

"All right. Give me 30."

Version 7 came out 30 minutes later.

![](../images/2022/03/Screen%207.png)

"Better, but still we have a problem."

"What now?"

"I was surprised the other day to discover that South Africa's territory includes an Island called Marion Island."

"What's that got to do with anything?"

"So while South Africa observes [South African Standard Time](https://www.timeanddate.com/time/zones/sast), Marion Island observes [East African Time](https://www.timeanddate.com/time/zones/eat). That means South Africa has two time zones. So a country drop down is not enough."

"My goodness!"

"Russia has 11 different time zones. So to prevent your contacts getting their notifications too early (or too late) you need a way to specify which time zone your contact is so that the server can compute the correct time to send the messages."

Version 8 came out 2 hours later.

![](../images/2022/03/Screen%208.png)

"Looking good!"

"We have had to add a timezone database and lookup!"

"You're not going to like what I say next."

"What now?"

"Time zones are not in fact static - they change due to various practical and poilitical reasons. So you can't keep that as a static database in your app - you will have to be updating it."

"What do you mean change?"

"Some countries can decide that they will stop - or start - observing [daylight savings time](https://www.timeanddate.com/time/dst/). Which will throw off your server time calculations."

"Oh no!"

"Alas. Some countries can even decide to observe differnet time zones, either changing the ones they currently observe or harmonizing those that they do."

"Wow!"

"Such is life! Now going back to your template - you will need to allow users to specify their own messages, in their own language. Can't assume everyone speaks English!"

"Hmm. Hadn't thought of that!"

"You probably also need a different template for text and another for email. Text messages have some constraints in terms of length."

"That's a good idea!"

"And finally you need a way to track delivery of the emails and text messages. Its not like you can send a test message!"

"Finally!? Does that mean you've run out of critques?"

"No. It just means dinner has been served and I am hungry. 

As you have seen, this is not as simple as you thought when starting, huh?

Good evening!"

Happy hacking!