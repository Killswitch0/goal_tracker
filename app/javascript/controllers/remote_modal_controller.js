import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remote-modal"
export default class extends Controller {
  connect() {
    this.modal = new bootstrap.Modal(this.element)
    this.hideBeforeRender();

    this.open();
    this.hideAfterRender();
  }

  open() {
    if (!this.modal.isOpened) {
      this.modal.show()
    }
  }

  hideBeforeRender() {
    this.element.addEventListener('show.bs.modal', () => {
      let otherBackdrops = document.querySelectorAll('.modal-backdrop');

      otherBackdrops.forEach(backdrop => {
        if (backdrop !== this.modal._backdrop.element) {
          backdrop.remove(); 
        }
      });
    });
  }

  hideAfterRender() {
    this.element.addEventListener('hidden.bs.modal', () => {
      this.element.remove();
      document.querySelector('body').style = ''
    });
  }
}
