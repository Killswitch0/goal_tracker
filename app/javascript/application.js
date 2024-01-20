// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "chartkick/chart.js"


Turbo.setConfirmMethod(() => {
  return new Promise((resolve, reject) => {
    let modal = new bootstrap.Modal(document.getElementById('exampleModal'));
    let clicked =  document.activeElement.dataset

    document.querySelector('.turbo-confirm #exampleModalLabel').innerText = clicked.modalTitle;
    document.querySelector('.turbo-confirm .modal-body').innerText = clicked.turboConfirm;
    
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




