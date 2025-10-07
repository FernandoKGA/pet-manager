document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("add-expense-btn");
  const modal = document.getElementById("expense-modal");
  if (!btn || !modal) return;

  btn.addEventListener("click", (e) => {
    e.preventDefault();
    modal.style.display = "block";
  });


  const closeBtn = document.getElementById("close-expense-modal");
  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none";
    });
  }
});
