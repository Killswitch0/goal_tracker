import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  connect() {
    this.addCompletionStyle();
  }

  addCompletionStyle() {
    let elements = document.querySelectorAll('.simple-calendar .day div');

    elements.forEach((element) => {
      let goalMarker = element.dataset.goalMarker;
      let complete = element.dataset.complete;

      if (element && goalMarker) {
        if (complete === 'true') {
          element.classList.add('completed');
          element.style.background = `linear-gradient(
            to right,
            ${goalMarker} 7%,
            rgba(24, 225, 68, 0.5) 0%)`;
        } else {
          element.classList.add('uncompleted');
          element.style.background = `linear-gradient(
            90deg,
            ${goalMarker} 7%,
            rgba(239, 22, 22, 0.5) 0%)`;
        }
      };
    });
  };
  
}
