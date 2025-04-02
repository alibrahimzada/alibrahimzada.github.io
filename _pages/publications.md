---
layout: page
permalink: /publications/
title: publications
description: 
years_pub: [2025,2024,2023,2022,2020,2019]
nav: true
---

<div class="publications">

{% for y in page.years_pub %}
  <h2 class="year" style="width:110%;">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
