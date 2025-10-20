document.addEventListener('turbo:load', () => {
  const modal = document.getElementById('new-entry-modal');
  const openBtn = document.getElementById('open-modal-btn');
  const closeBtn = modal?.querySelector('.close-btn');

  if (!modal || !openBtn || !closeBtn) {
    return;
  }

  const openModal = () => modal.style.display = 'block';
  const closeModal = () => modal.style.display = 'none';

  openBtn.addEventListener('click', openModal);
  closeBtn.addEventListener('click', closeModal);

  modal.addEventListener('click', (event) => {
    if (event.target === modal) {
      closeModal();
    }
  });

  const errorExplanation = document.getElementById('error_explanation');
  if (errorExplanation) {
    openModal();
  }
});
