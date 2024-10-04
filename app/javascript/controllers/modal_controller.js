import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "submitButton", "phoneInput", "emailInput", "phoneError", "emailError"]

  connect() {
    document.addEventListener("turbo:submit-end", this.handleSubmit.bind(this))
    document.addEventListener("keydown", this.handleKeydown.bind(this))
    this.validateForm()
  }

  disconnect() {
    document.removeEventListener("turbo:submit-end", this.handleSubmit.bind(this))
    document.removeEventListener("keydown", this.handleKeydown.bind(this))
  }

  open() {
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
    
    // Reset the form view when closing the modal
    const formContent = this.element.querySelector('#form-content')
    const successMessage = this.element.querySelector('#success-message')
    
    if (formContent && successMessage) {
      formContent.classList.remove('hidden')
      successMessage.classList.add('hidden')
    }
  }

  handleSubmit(event) {
    if (event.detail.success) {
      const formContent = this.element.querySelector('#form-content')
      const successMessage = this.element.querySelector('#success-message')
      
      if (formContent && successMessage) {
        formContent.classList.add('hidden')
        successMessage.classList.remove('hidden')
      }
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  backgroundClick(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }

  // New method for form validation
  validateForm() {
    const form = this.element.querySelector('form')
    if (form) {
      const requiredFields = form.querySelectorAll('input[required]')
      const allFieldsFilled = Array.from(requiredFields).every(field => field.value.trim() !== '')
      const phoneValid = this.validatePhone()
      const emailValid = this.validateEmail()
      
      this.submitButtonTarget.disabled = !(allFieldsFilled && phoneValid && emailValid)
    }
  }

  validatePhone() {
    const phoneRegex = /^[0-9]{8,}$/
    const isValid = phoneRegex.test(this.phoneInputTarget.value)
    this.phoneErrorTarget.classList.toggle('hidden', isValid)
    return isValid
  }

  validateEmail() {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    const isValid = emailRegex.test(this.emailInputTarget.value)
    this.emailErrorTarget.classList.toggle('hidden', isValid)
    return isValid
  }
}
