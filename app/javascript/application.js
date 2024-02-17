// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "chartkick/chart.js"

window.bootstrap = bootstrap;

Turbo.setConfirmMethod(() => {
  return new Promise((resolve, reject) => {
    let modal = new bootstrap.Modal(document.getElementById('exampleModal'));
    let elementData = document.activeElement.dataset;
    let confirmButton = document.querySelector('.turbo-confirm #confirmButton');

    document.querySelector('.turbo-confirm #exampleModalLabel').innerText = elementData.modalTitle;
    document.querySelector('.turbo-confirm .modal-body').innerText = elementData.turboConfirm;

    if (elementData.confirmButton) {
      confirmButton.innerText = elementData.confirmButton;
    }
    
    modal.show();

    document.getElementById('confirmButton').addEventListener('click', () => {
      modal.hide();
      resolve(true);
    });

    document.getElementById('cancelButton').addEventListener('click', () => {
      modal.hide();
      resolve(false);
    });
  });
});




