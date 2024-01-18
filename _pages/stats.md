---
layout: page
permalink: /stats/
title: stats
description: 
nav: true
---

<style>

    h2 {
      color: #333;
      margin-bottom: 10px;
      font-size: 50px;
      text-align: center;
      font-weight: bold;
    }

    .floating-number {
      font-size: 70px;
      text-align: center;
      color: #007bff;
      font-weight: bold;
    }
    
    .circles-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-around;
      margin-top: 20px;
    }

    .circle-container {
      position: relative;
      width: 50px;
      height: 50px;
      margin: 10px;
    }

    .circle-progress {
      position: absolute;
      width: 100%;
      height: 100%;
      clip: rect(0, 50px, 50px, 25px);
      border-radius: 50%;
      background-color: #007bff;
    }

    .circle-fill {
      position: absolute;
      width: 100%;
      height: 100%;
      clip: rect(0, 25px, 50px, 0);
      border-radius: 50%;
      background-color: #007bff;
      transform: rotate(0deg);
      transform-origin: 50% 50%;
      transition: transform 1s linear;
    }

    .circle-age {
      position: absolute;
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
      font-size: 20px;
    }
    
  </style>

<h2>Ali, you are</h2>
<div class="floating-number" id="ageDisplay"></div>
<h2>years old!</h2>
<h2>enjoy it while you can 🥹</h2>

<div class="circles-container" id="circlesContainer"></div>

<script>

  function updateAge() {
    var currentDate = new Date();
    var ageInMilliseconds = currentDate - new Date('1999-01-28');
    var ageInYears = ageInMilliseconds / (365.25 * 24 * 60 * 60 * 1000);

    document.getElementById('ageDisplay').textContent = ageInYears.toFixed(10);

    // Update circles for each birthday
    var circlesContainer = document.getElementById('circlesContainer');
    circlesContainer.innerHTML = ''; // Clear existing circles

    for (var i = 0; i < 4; i++) {
      var rowContainer = document.createElement('div');
      rowContainer.style.display = 'flex';
      rowContainer.style.marginBottom = '10px';

      for (var j = 0; j < 25; j++) {
        var circleContainer = document.createElement('div');
        circleContainer.classList.add('circle-container');

        var circleProgress = document.createElement('div');
        circleProgress.classList.add('circle-progress');

        var circleFill = document.createElement('div');
        circleFill.classList.add('circle-fill');

        if (i * 25 + j === Math.floor(ageInYears)) {
          circleFill.style.backgroundColor = 'red';
          circleProgress.style.backgroundColor = 'red';

        } else if (i * 25 + j < Math.floor(ageInYears)) {
          circleFill.style.transform = 'rotate(360deg)';
        } else {
          circleFill.style.backgroundColor = 'gray';
          circleProgress.style.backgroundColor = 'gray';
          circleFill.style.transform = 'rotate(0deg)';
        }

        var circleAge = document.createElement('div');
        circleAge.classList.add('circle-age');
        circleAge.textContent = (i * 25 + j) < Math.floor(ageInYears) ? '🎂' : '';

        circleContainer.appendChild(circleProgress);
        circleContainer.appendChild(circleFill);
        circleContainer.appendChild(circleAge);
        rowContainer.appendChild(circleContainer);
      }

      circlesContainer.appendChild(rowContainer);
    }
  }

  setInterval(updateAge, 1);

  var elements = document.getElementsByTagName('h1');
  while (elements.length > 0) {
    elements[0].parentNode.removeChild(elements[0]);
  }

  updateAge();
</script>
