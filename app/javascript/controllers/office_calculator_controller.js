import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "prevButton", "nextButton", "submit"]

  connect() {
    this.currentStep = 0
    this.updateButtonVisibility()
  }

  nextStep() {
    this.currentStep++
    this.updateStepVisibility()
  }

  previousStep() {
    this.currentStep--
    this.updateStepVisibility()
  }

  updateStepVisibility() {
    this.stepTargets.forEach((step, index) => {
      step.classList.toggle('hidden', index !== this.currentStep)
    })
    this.updateButtonVisibility()
  }

  updateButtonVisibility() {
    this.prevButtonTarget.classList.toggle('hidden', this.currentStep === 0)
    this.nextButtonTarget.classList.toggle('hidden', this.currentStep === this.stepTargets.length - 1)
    this.submitTarget.classList.toggle('hidden', this.currentStep !== this.stepTargets.length - 1)
  }
}