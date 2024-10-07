import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "dropdown", "input", "selected"]

  connect() {
    this.selectedItems = new Set()
    document.addEventListener("click", this.closeDropdown.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.closeDropdown.bind(this))
  }

  search(event) {
    const searchTerm = event.target.value.toLowerCase()
    this.dropdownTarget.classList.remove("hidden")
    this.dropdownTarget.querySelectorAll("div").forEach(item => {
      const text = item.textContent.toLowerCase()
      item.style.display = text.includes(searchTerm) ? "block" : "none"
    })
  }

  toggleDropdown(event) {
    event.preventDefault()
    this.dropdownTarget.classList.toggle("hidden")
  }

  select(event) {
    const id = event.currentTarget.dataset.value
    const name = event.currentTarget.textContent

    if (this.selectedItems.has(id)) {
      this.selectedItems.delete(id)
      this.removeSelectedItem(id)
    } else {
      this.selectedItems.add(id)
      this.addSelectedItem(id, name)
    }

    this.updateInputValue()
    this.searchTarget.value = ""
    this.dropdownTarget.classList.add("hidden")
  }

  addSelectedItem(id, name) {
    const item = document.createElement("div")
    item.classList.add("inline-flex", "items-center", "bg-gray-200", "rounded-full", "px-3", "py-1", "text-sm", "font-semibold", "text-gray-700")
    item.innerHTML = `${name} <button type="button" class="ml-1 focus:outline-none" data-action="click->searchable-select#removeItem" data-id="${id}">&times;</button>`
    this.selectedTarget.appendChild(item)
  }

  removeSelectedItem(id) {
    this.selectedTarget.querySelector(`[data-id="${id}"]`).parentElement.remove()
  }

  removeItem(event) {
    event.preventDefault()
    const id = event.currentTarget.dataset.id
    this.selectedItems.delete(id)
    this.removeSelectedItem(id)
    this.updateInputValue()
  }

  updateInputValue() {
    this.inputTarget.value = Array.from(this.selectedItems).join(",")
  }

  closeDropdown(event) {
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.add("hidden")
    }
  }
}
