import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notes-search"
//
// Our search input uses data-turbo-permanent to retain focus while updating.
//
// This means clearing the input (e.g, GET /notes) doesn't clear the current
// input value, since it isn't replaced by Turbo.
//
// To fix this, we manually clear the input when we click the "Clear" button,
// then submit the form, and then finally re-focus the input.
//
export default class extends Controller {
  static targets = ["input", "form"]

  click(event) {
    event.preventDefault()
    event.stopPropagation()

    this.formTarget.reset()

    this.formTarget.requestSubmit()

    this.inputTarget.focus()
  }
}
