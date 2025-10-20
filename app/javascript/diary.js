document.addEventListener('turbo:load', () => {
  const modal = document.getElementById('new-entry-modal');
  const openBtn = document.getElementById('open-modal-btn');
  const closeBtn = document.querySelector('.modal .close-btn'); // Seletor mais específico

  if (modal && openBtn && closeBtn) {
    openBtn.onclick = function() {
      modal.style.display = 'block';
    }

    closeBtn.onclick = function() {
      modal.style.display = 'none';
    }

    window.onclick = function(event) {
      if (event.target == modal) {
        modal.style.display = 'none';
      }
    }
  }

  const errorExplanation = document.getElementById('error_explanation');
  if (errorExplanation && modal) {
    modal.style.display = 'block';
  }
});