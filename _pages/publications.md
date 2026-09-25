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

<script>
  window.addEventListener('load', function () {
    if (!window.location.hash) return;

    var hash = window.location.hash.slice(1);
    var targetIds = hash === 'agentic'
      ? ['ibrahimzada2026recodeagent', 'ibrahimzada2025matchfixagent']
      : [hash];
    var targets = targetIds
      .map(function (id) { return document.getElementById(id); })
      .filter(function (item) { return item && item.classList.contains('publication-item'); });
    if (!targets.length) return;

    var target = targets[0];

    var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    window.scrollTo(0, 0);

    if (reducedMotion) {
      targets.forEach(function (item) { item.classList.add('is-targeted'); });
      return;
    }

    var start = 0;
    var destination = target.getBoundingClientRect().top - 96;
    var duration = 850;
    var startedAt;

    function scrollToTarget(timestamp) {
      if (!startedAt) startedAt = timestamp;
      var progress = Math.min((timestamp - startedAt) / duration, 1);
      var eased = 1 - Math.pow(1 - progress, 3);
      window.scrollTo(0, start + (destination - start) * eased);

      if (progress < 1) {
        window.requestAnimationFrame(scrollToTarget);
      } else {
        targets.forEach(function (item) { item.classList.add('is-targeted'); });
      }
    }

    window.requestAnimationFrame(scrollToTarget);
  });
</script>
