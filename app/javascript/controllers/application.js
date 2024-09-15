import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Import and register NavController
import NavController from "./nav_controller"
application.register("nav", NavController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
