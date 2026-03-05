---
layout: page
title: Archives
permalink: /archives/
---
<img src="{{ site.baseurl }}/images/MVP_Badge_Avatar_Secondary_DarkBlue7694_RGB_small.png" alt="MVP Logo">

{% assign count = site.posts | size %}
{% capture total_words %}
  {% posts_word_count total %}
{% endcapture %}

## Total ({{ count }} Posts)

{% assign postsByYear = site.posts | group_by_exp:"post", "post.date | date: '%Y'" %}
{% for year in postsByYear %}
{% assign yearCount = year.items | size %}

### {{ year.name }} ({{yearCount}} Posts)

{% assign postsByMonth = year.items | group_by_exp:"post", "post.date | date: '%B'" %}

{% for month in postsByMonth %}
{% assign monthCount = month.items | size %}

### {{ month.name }} {{ year.name }} ({{monthCount}}  Posts)

 {% assign postsByWeek = month.items | group_by_exp:"post", "post.date | date: '%V'"  %}

  {% for week in postsByWeek %}

#### 📅 Week {{week.name}}
  
  <ol reversed type="i">
  {% for post in week.items %}
    <li>
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a> - {{ post.date | date: "%A, %-d %B %Y" }} <h5><b>{% if post.categories and post.categories.size > 0 %}
  [{{ post.categories | join: ", " }}]
{% else %}
  []
{% endif %}</b></h5>
    </li>
  {% endfor %}
  </ol>
{% endfor %}
{% endfor %}
{% endfor %}
