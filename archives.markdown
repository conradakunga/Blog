---
layout: page
title: Archives
permalink: /archives/
---
{% assign count = site.posts | size %}

<h2>Total Posts : {{count}}</h2>

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear %}
{% assign yearCount = year.items | size %}
  <h3>{{ year.name }} Posts : {{yearCount}}</h3>
  {% assign postsByMonth = year.items | group_by_exp:"post", "post.date | date: '%B'" %}


{% for month in postsByMonth %}
{% assign monthCount = month.items | size %}
<h3>{{ month.name }} Posts : <i>{{monthCount}}</i></h3>
<ul>
  {% for post in month.items %}
    <li>
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a> - {{ post.date | date: "%a, %-d %b %Y" }} <b>{% if post.categories and post.categories.size > 0 %}
  [{{ post.categories | join: ", " }}]
{% else %}
  []
{% endif %}</b>
    </li>
  {% endfor %}
</ul>

{% endfor %}
{% endfor %}