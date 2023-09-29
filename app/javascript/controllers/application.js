import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

Turbo.setConfirmMethod(() => {
    let dialog = document.getElementById('turbo-confirm')
    dialog.showModal()

    return new Promise((resolve, reject) => {
        dialog.addEventListener('close', () => {
            resolve(dialog.returnValue == 'confirm')
        })
    })
})
