import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "answer", "expandIcon", "collapseIcon"]

  toggle(event) {
    event.preventDefault()
    this.questionTarget.setAttribute(
      "aria-expanded",
      this.expanded ? "false" : "true"
    )
    this.answerTarget.classList.toggle("hidden")
    this.expandIconTarget.classList.toggle("hidden")
    this.collapseIconTarget.classList.toggle("hidden")
  }

  get expanded() {
    return this.questionTarget.getAttribute("aria-expanded") === "true"
  }
}