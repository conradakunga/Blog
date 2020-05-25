---
layout: page
title: Categories
permalink: /categories/
---
## All posts by category

{% assign sorted_cats = site.categories | sort %}
{% for category in sorted_cats %}
  <h3>{{ category[0] }}</h3>
  <ul>
    {% for post in category[1] %}
      <li><a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a> {{ post.date | date_to_long_string: "ordinal" }}</li>
    {% endfor %}
  </ul>
{% endfor %}
