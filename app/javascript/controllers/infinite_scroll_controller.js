import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.page = 1
    this.loading = false
    this.intersectionObserver = new IntersectionObserver(entries => this.handleIntersection(entries))
    this.intersectionObserver.observe(this.element)
  }

  disconnect() {
    this.intersectionObserver.unobserve(this.element)
  }

  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting && !this.loading) {
        this.loadMoreListings()
      }
    })
  }

  loadMoreListings() {
    this.loading = true
    this.page += 1

    fetch(`${this.element.dataset.infiniteScrollUrl}?page=${this.page}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
      .then(response => response.text())
      .then(html => {
        Turbo.renderStreamMessage(html)
        this.loading = false
      })
  }
}
