import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  connect() {
    this.showAndHideNotifications();
  }

  showAndHideNotifications() {
    let dropdownLink = document.querySelector('.notifications-dropdown');
    let notifications = document.querySelector('#notifications');

    dropdownLink.addEventListener('click', (e) => {
      e.preventDefault();

      notifications.classList.toggle('show-block');
    });

    dropdownLink.addEventListener('blur', (e) => {
      notifications.classList.remove('show-block')
    });
  }
}
