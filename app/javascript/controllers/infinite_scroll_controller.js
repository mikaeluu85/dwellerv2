import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    page: { type: Number, default: 1 }
  }

  static targets = ["container", "loader"]

  connect() {
    this.intersectionObserver = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadMore()
        }
      })
    })

    this.intersectionObserver.observe(this.loaderTarget)
  }

  disconnect() {
    this.intersectionObserver.disconnect()
  }

  loadMore() {
    if (this.loading) return

    this.loading = true
    this.loaderTarget.classList.remove('hidden')
    
    fetch(`${this.urlValue}?page=${this.pageValue}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
      .then(response => response.text())
      .then(html => {
        if (html.trim() !== '') {
          this.containerTarget.insertAdjacentHTML('beforeend', html)
          this.pageValue++
        } else {
          this.intersectionObserver.disconnect()
          this.loaderTarget.remove()
        }
      })
      .catch(error => console.error('Error:', error))
      .finally(() => {
        this.loaderTarget.classList.add('hidden')
        this.loading = false
      })
  }
}
