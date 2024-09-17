import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    console.log("Connected Type Selector Controller");
    console.log("Content Targets on Connect:", this.contentTargets);  // Debug: log all content targets
    this.selectInitialType();  // Ensure this method is called here
  }

  // Add this method to select the initial type
  selectInitialType() {
    const firstTypeIcon = this.element.querySelector('[data-type]');
    if (firstTypeIcon) {
      this.setActiveType(firstTypeIcon);
    }
  }

  selectType(event) {
    const selectedIcon = event.currentTarget;
    console.log("Selected Icon Type:", selectedIcon.dataset.type);
    this.setActiveType(selectedIcon);
  }

  setActiveType(selectedIcon) {
    // Remove the active border from all icons
    this.element.querySelectorAll('[data-type]').forEach(icon => {
      icon.classList.remove('border-primary');
      icon.classList.add('border-transparent');
    });

    // Add the active border to the selected icon
    selectedIcon.classList.remove('border-transparent');
    selectedIcon.classList.add('border-primary');

    // Show the corresponding content
    this.showSelectedTypeContent(selectedIcon.dataset.type);
  }

  showSelectedTypeContent(selectedType) {
    console.log("Selected Type:", selectedType);  // Debug log for the selected type

    // Log and hide all content sections
    this.contentTargets.forEach(content => {
      console.log("Checking content:", content.dataset.typeContent);  // Log each content's data-type-content
      content.classList.add('hidden');
    });

    // Find the matching content block
    const selectedContent = this.contentTargets.find(content => content.dataset.typeContent === selectedType);

    if (selectedContent) {
      console.log("Showing content for:", selectedType);  // Log success if found
      selectedContent.classList.remove('hidden');
    } else {
      console.log("No content found for:", selectedType);  // Log failure if not found
    }
  }
}
