import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "dropdown", "inputs", "selected"]

  toggleDropdown() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  search(event) {
    const query = event.target.value.toLowerCase()
    this.dropdownTarget.querySelectorAll("div").forEach(option => {
      const text = option.textContent.toLowerCase()
      option.style.display = text.includes(query) ? "block" : "none"
    })
  }

  select(event) {
    const selectedId = event.currentTarget.dataset.value
    const selectedName = event.currentTarget.textContent.trim()

    // Prevent duplicate selections
    if (this.selectedIds().includes(selectedId)) return

    // Create a hidden input for the selected location
    const hiddenInput = document.createElement("input")
    hiddenInput.type = "hidden"
    hiddenInput.name = "search_contact[location_ids][]"
    hiddenInput.value = selectedId
    this.inputsTarget.appendChild(hiddenInput)

    // Create a tag to display the selected location
    const tag = document.createElement("span")
    tag.className = "inline-flex items-center px-2.5 py-1 rounded-full text-sm font-medium bg-gray-200 text-gray-800"
    tag.textContent = selectedName

    // Create a remove button for the tag
    const removeBtn = document.createElement("button")
    removeBtn.type = "button"
    removeBtn.className = "ml-1 text-grey-500 hover:text-grey-700"
    removeBtn.innerHTML = "&times;"
    
    // Add event listener to remove the tag and hidden input
    removeBtn.addEventListener("click", () => {
      hiddenInput.remove()
      tag.remove()
    })

    tag.appendChild(removeBtn)
    this.selectedTarget.appendChild(tag)

    // Clear the search input and hide the dropdown
    this.searchTarget.value = ""
    this.toggleDropdown()
  }

  selectedIds() {
    return Array.from(this.inputsTarget.querySelectorAll('input[name="search_contact[location_ids][]"]'))
      .map(input => input.value)
  }
}