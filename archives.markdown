---
layout: page
title: Archives
permalink: /archives/
---
{% assign count = site.posts | size %}

<h3>Total Posts : {{count}}</h3>

{% if jekyll.environment == "production" %}

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear %}
  <h2>{{ year.name }}</h2>
  {% assign postsByMonth = year.items | group_by_exp:"post", "post.date | date: '%B'" %}

{% for month in postsByMonth %}
<h2>{{ month.name }}</h2>
<ul>
  {% for post in month.items %}
    <li>
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a> - {{ post.date | date: "%-d %B" }}
    </li>
  {% endfor %}
</ul>

{% endfor %}
{% endfor %}

{% endif %}