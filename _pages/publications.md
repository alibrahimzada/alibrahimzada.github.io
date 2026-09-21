---
layout: default
permalink: /publications/
title: Publications
navbar_title: Publications
description: 
years_pub: [2026,2025,2024,2023,2022,2020,2019]
nav: true
body_attr: >-
  data-spy="scroll" data-target="#navbar-year" data-offset="100"
---

<h1 class="sr-only">Publications</h1>
<div class="row publications">
  <div class="col-12 col-lg-10">
    {% for y in page.years_pub %}
    <section aria-labelledby="year-{{ y }}">
      <h2 class="h2 pt-4 mb-3" id="year-{{ y }}">{{ y }}</h2>
      <div class="bg-white shadow-sm rounded-xl">
        {% bibliography -f papers -q @*[year={{y}}]* %}
      </div>
    </section>
    {% endfor %}
  </div>
  <aside class="col-lg-2 d-none d-lg-block">
    <nav id="navbar-year" class="nav nav-pills flex-column sticky-top publication-years" aria-label="Publication years">
      {% for y in page.years_pub %}<a class="nav-link" href="#year-{{ y }}">{{ y }}</a>{% endfor %}
    </nav>
  </aside>
</div>
