document.addEventListener('click', async function (event) {
  const button = event.target.closest('.bibtex-copy');
  if (!button) return;

  const code = button.closest('.bibtex-panel').querySelector('code');
  const icon = button.querySelector('i');
  const status = button.parentElement.querySelector('.bibtex-copy-status');
  if (button.dataset.copying) return;
  button.dataset.copying = 'true';
  try {
    await navigator.clipboard.writeText(code.textContent);
    icon.className = 'fas fa-check';
    status.textContent = 'Copied!';
  } catch (error) {
    icon.className = 'fas fa-exclamation-triangle';
    status.textContent = 'Copy failed';
  }
  button.title = status.textContent;
  button.setAttribute('aria-label', status.textContent);
  window.setTimeout(function () {
    icon.className = 'far fa-copy';
    button.title = 'Copy BibTeX';
    button.setAttribute('aria-label', 'Copy BibTeX');
    status.textContent = '';
    delete button.dataset.copying;
  }, 2000);
});
