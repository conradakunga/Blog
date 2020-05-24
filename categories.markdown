---
layout: page
title: Categories
permalink: /categories/
---
## All posts by caregory

{% assign sorted_cats = site.categories | sort %}
{% for cartegory in sorted_cats %}
  <h3>{{ cartegory[0] }}</h3>
  <ul>
    {% for post in cartegory[1] %}
      <li><a href="{{ post.url }}">{{ post.title }}</a> {{ post.date | date_to_long_string: "ordinal" }}</li>
    {% endfor %}
  </ul>
{% endfor %}
