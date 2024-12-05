---
layout: page
title: Archives
permalink: /archives/
---
{% assign count = site.posts | size %}

<h3>Total Posts : {{count}}</h3>

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear %}
  <h2>{{ year.name }}</h2>
  {% assign postsByMonth = year.items | group_by_exp:"post", "post.date | date: '%B'" %}


{% for month in postsByMonth %}
{% assign monthCount = month.items | size %}
<h2>{{ month.name }} : <i>{{monthCount}}</i></h2>
<ul>
  {% for post in month.items %}
    <li>
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a> - {{ post.date | date: "%A, %-d %B" }} <h5><b> {% if post.categories and post.categories.size > 0 %}
  [{{ post.categories | join: ", " }}]
{% else %}
  []
{% endif %}</b></h5>
    </li>
  {% endfor %}
</ul>

{% endfor %}
{% endfor %}