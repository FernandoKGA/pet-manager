import { Controller } from "@hotwired/stimulus"

// Conecta-se diretamente na div .modal
export default class extends Controller {
  static values = { openOnError: Boolean }

  connect() {
    // this.element é a própria div do modal
    this.modal = new bootstrap.Modal(this.element)

    // Se houver erro no formulário, abre automaticamente
    if (this.openOnErrorValue) {
      this.modal.show()
    }
  }

  disconnect() {
    if (this.modal) {
      this.modal.hide()
    }
  }

  // Função chamada quando o formulário é enviado com sucesso
  close(event) {
    // Verifica se o envio do Turbo foi bem sucedido antes de fechar
    if (event.detail.success) {
      this.modal.hide()
    }
  }
}