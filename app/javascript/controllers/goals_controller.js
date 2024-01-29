import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="goals"
export default class extends Controller {
  connect() {
    this.showProgress();
  }

  showProgress() {
    let progressElement = document.querySelector('.completed-info__progress');
    let percentage = progressElement.dataset.percentage;

    if (progressElement && percentage) {
      progressElement.style.background = 
      `radial-gradient(closest-side, white 79%, transparent 80%),
       conic-gradient(rgba(9, 194, 30, 1) ${percentage}%, rgba(39, 245, 63, 0.21) 0%)`;
    };
  };
}
