import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "prevButton", "nextButton", "submit", "seatCounter", "input", "errorIcon", "errorMessage"]
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

  validateField(event) {
    const field = event.target;
    const container = field.closest('.relative');
    const errorIcon = container.querySelector('[data-office-calculator-target="errorIcon"]');
    const dropdownIcon = container.querySelector('[data-office-calculator-target="dropdownIcon"]');
    const errorMessage = field.closest('.sm\\:col-span-4').querySelector('[data-office-calculator-target="errorMessage"]');

    if (!field.checkValidity()) {
      field.classList.add('text-red-900', 'ring-red-300', 'placeholder:text-red-300');
      field.classList.remove('ring-gray-300');
      errorIcon.classList.remove('hidden');
      dropdownIcon.classList.add('hidden');
      errorMessage.classList.remove('hidden');
      errorMessage.textContent = field.validationMessage || "Please fill out this field";
      
      // Add this condition for select elements
      if (field.tagName === 'SELECT') {
        field.classList.add('text-red-300');
      }
    } else {
      field.classList.remove('text-red-900', 'ring-red-300', 'placeholder:text-red-300', 'text-red-300');
      field.classList.add('ring-gray-300');
      errorIcon.classList.add('hidden');
      dropdownIcon.classList.remove('hidden');
      errorMessage.classList.add('hidden');
    }
  }

  validateForm(event) {
    let isValid = true
    this.inputTargets.forEach(input => {
      if (!input.checkValidity()) {
        isValid = false
        this.validateField({ target: input })
      }
    })
    if (!isValid) {
      event.preventDefault()
    }
  }
}