(function () {
  'use strict';
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

  document.querySelectorAll('.personal-slideshow').forEach(function (gallery) {
    const slides = Array.from(gallery.querySelectorAll('.personal-slide'));
    const bars = Array.from(gallery.querySelectorAll('.personal-slide-bars button'));
    if (slides.length < 2 || bars.length < 2) return;
    let index = 0;
    function show(next) {
      slides[index].hidden = true;
      bars[index].setAttribute('aria-selected', 'false');
      index = (next + slides.length) % slides.length;
      slides[index].hidden = false;
      bars[index].setAttribute('aria-selected', 'true');
    }
    bars.forEach(function (bar, barIndex) {
      bar.addEventListener('click', function () { show(barIndex); });
    });
    gallery.addEventListener('keydown', function (event) {
      if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
      event.preventDefault();
      show(index + (event.key === 'ArrowRight' ? 1 : -1));
    });
    gallery.addEventListener('mouseenter', function () { window.clearInterval(gallery._personalTimer); });
    gallery.addEventListener('mouseleave', function () { start(); });
    function start() {
      window.clearInterval(gallery._personalTimer);
      if (reducedMotion.matches) return;
      gallery._personalTimer = window.setInterval(function () { show(index + 1); }, 4200);
    }
    start();
    document.addEventListener('visibilitychange', function () {
      if (document.hidden) window.clearInterval(gallery._personalTimer);
      else start();
    });
    /* Keep the controls intentionally limited to the reference page's bars. */
    /* Ignore accidental legacy controls if an older generated page is cached. */
    gallery.addEventListener('click', function (event) {
      const button = event.target.closest('button');
      if (!button) return;
      if (button.parentElement !== gallery.querySelector('.personal-slide-bars')) return;
      window.clearInterval(gallery._personalTimer);
      window.setTimeout(start, 6500);
    });
  });

  document.querySelectorAll('.age-tracker').forEach(function (tracker) {
    // The existing stats page specifies a date, not a birth time. Use midnight UTC consistently.
    const birth = new Date(tracker.dataset.birthDate + 'T00:00:00Z');
    const ring = tracker.querySelector('.age-ring-progress');
    const milestones = tracker.querySelector('.age-milestones');
    let previousYears = -1;
    function anniversary(year, month = birth.getUTCMonth()) {
      const lastDay = new Date(Date.UTC(year, month + 1, 0)).getUTCDate();
      return new Date(Date.UTC(year, month, Math.min(birth.getUTCDate(), lastDay)));
    }
    function set(name, value) {
      const element = tracker.querySelector('[data-age="' + name + '"]');
      const text = String(value);
      if (element.textContent === text) return;
      const wasSet = element.textContent !== '—';
      element.textContent = text;
      if (wasSet && !reducedMotion.matches && name !== 'birthday') {
        element.classList.remove('age-tick');
        void element.offsetWidth;
        element.classList.add('age-tick');
      }
    }
    function update() {
      const now = new Date();
      let years = now.getUTCFullYear() - birth.getUTCFullYear();
      if (now < anniversary(birth.getUTCFullYear() + years)) years--;
      const lastBirthday = anniversary(birth.getUTCFullYear() + years);
      const nextBirthday = anniversary(birth.getUTCFullYear() + years + 1);
      let months = 0;
      while (months < 11 && anniversary(birth.getUTCFullYear() + years, birth.getUTCMonth() + months + 1) <= now) months++;
      let remaining = now - anniversary(birth.getUTCFullYear() + years, birth.getUTCMonth() + months);
      const days = Math.floor(remaining / 86400000);
      remaining %= 86400000;
      set('years', years);
      set('months', months);
      set('days', days);
      set('hours', Math.floor(remaining / 3600000));
      set('minutes', Math.floor(remaining / 60000) % 60);
      set('seconds', Math.floor(remaining / 1000) % 60);
      const progress = (now - lastBirthday) / (nextBirthday - lastBirthday);
      ring.style.strokeDashoffset = 100 * (1 - progress);
      const birthdayToday = now.getUTCMonth() === birth.getUTCMonth() && now.getUTCDate() === birth.getUTCDate();
      const daysUntil = Math.ceil((nextBirthday - now) / 86400000);
      set('birthday', birthdayToday ? 'A new lap around the sun. Happy birthday, Ali!' : daysUntil + ' days until the next trip around the sun.');
      if (years !== previousYears) {
        milestones.replaceChildren();
        for (let i = 0; i <= years; i++) {
          const dot = document.createElement('span');
          dot.className = 'age-milestone' + (i === years ? ' age-milestone-current' : '');
          dot.setAttribute('aria-hidden', 'true');
          dot.title = i === years ? 'Year ' + (i + 1) + ' — in progress' : 'Year ' + (i + 1);
          milestones.appendChild(dot);
        }
        milestones.setAttribute('aria-label', years + ' completed years, and one in progress');
        previousYears = years;
      }
    }
    update();
    window.setInterval(function () { if (!document.hidden) update(); }, 1000);
    document.addEventListener('visibilitychange', function () { if (!document.hidden) update(); });
  });
})();
