import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-all"
export default class extends Controller {
  static targets = ["link"];

  connect() {
  }

  goToLink() {
    const link = this.linkTarget.getAttribute("href");
    if (link) {
      window.location.href = link;
    }
  }
}
