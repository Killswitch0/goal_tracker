import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="charts"
export default class extends Controller {
  connect() {
    this.toggleChevron()
  }

  toggleChevron() {
    let habitLinks = document.querySelectorAll('#chart div.buttons-list #navbarDropdown.icon-toggle');

    habitLinks.forEach((el) => {
      let elChevron = el.querySelector('i');

      el.addEventListener('click', () => {
        elChevron.classList.toggle('bi-chevron-down');
        elChevron.classList.toggle('bi-chevron-up');
      });
    });
  }
}
