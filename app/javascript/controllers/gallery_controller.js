import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "indicator"]

  connect() {
    this.showImage(0)
  }

  next() {
    this.showImage((this.index + 1) % this.imageTargets.length)
  }

  previous() {
    this.showImage((this.index - 1 + this.imageTargets.length) % this.imageTargets.length)
  }

  showImage(index) {
    this.imageTargets.forEach((el, i) => {
      el.classList.toggle("hidden", i !== index)
    })
    this.indicatorTargets.forEach((el, i) => {
      el.classList.toggle("bg-white", i === index)
      el.classList.toggle("bg-gray-400", i !== index)
    })
    this.index = index
  }
}
