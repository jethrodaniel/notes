import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notes-search"
//
// Our search input uses data-turbo-permanent to retain focus while updating.
//
// This means clearing the input (e.g, GET /notes) doesn't clear the current
// input value, since the input isn't replaced by Turbo.
//
// To fix this, we manually clear the input when we click the "Clear" button.
//
export default class extends Controller {
  static targets = ["input"]

  // Calling :prevent in the data-action seems to be all we need here
  click(_event) {}
}
