import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "prevButton", "nextButton", "submit", "seatCounter"]
  static values = {
    currentEmployees: Number,
    currentStep: Number
  }

  connect() {
    console.log("Office Calculator controller connected");
    document.addEventListener("turbo:before-stream-render", this.logStreamRender);
    this.updateButtonVisibility()
    this.validateSeats()
  }

  currentStepValueChanged() {
    if (this.currentStepValue === 2) {
      this.validateSeats()
    }
  }

  nextStep(event) {
    if (this.currentStep === 1 && this.nextButtonTarget.disabled) {
      event.preventDefault()
      return
    }
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
    if (this.currentStep === 1) {
      this.validateSeats()
    }
  }

  updateButtonVisibility() {
    this.prevButtonTarget.classList.toggle('hidden', this.currentStep === 0)
    this.nextButtonTarget.classList.toggle('hidden', this.currentStep === this.stepTargets.length - 1)
    this.submitTarget.classList.toggle('hidden', this.currentStep !== this.stepTargets.length - 1)
  }

  disconnect() {
    document.removeEventListener("turbo:before-stream-render", this.logStreamRender);
  }

  logStreamRender = (event) => {
    console.log("Turbo Stream received:", event.detail);
  }

  validateSeats() {
    if (this.currentStepValue !== 2) return;

    const totalSeats = this.calculateTotalSeats()
    const remainingSeats = this.currentEmployeesValue - totalSeats

    this.nextButtonTarget.disabled = remainingSeats > 0
    
    if (remainingSeats <= 0) {
      this.seatCounterTarget.textContent = `Bra jobbat! Alla ${this.currentEmployeesValue} anställda har tilldelats plats.`
    } else {
      this.seatCounterTarget.textContent = `${remainingSeats} av ${this.currentEmployeesValue} anställda behöver tilldelas plats.`
    }
  }

  calculateTotalSeats() {
    let totalSeats = 0
    this.element.querySelectorAll('[data-seat-count]').forEach(input => {
      const seatCount = parseInt(input.dataset.seatCount, 10)
      const quantity = parseInt(input.value, 10) || 0
      totalSeats += seatCount * quantity
    })
    return totalSeats
  }

  updateSeatCount() {
    this.validateSeats()
  }
}