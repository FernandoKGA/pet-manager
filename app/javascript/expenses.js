document.addEventListener("turbo:load", () => {
  const btn = document.getElementById("add-expense-btn");
  const modal = document.getElementById("expense-modal");
  const closeBtn = document.getElementById("close-expense-modal");

  if (!btn || !modal) return;

  btn.addEventListener("click", (e) => {
    e.preventDefault();
    modal.style.display = "flex"; 
  });

  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none";
    });
  }

  modal.addEventListener("click", (e) => {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });
});
