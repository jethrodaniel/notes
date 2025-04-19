import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notes-search"
export default class extends Controller {
  // Our search input uses data-turbo-permanent to retain focus while updating.
  //
  // This means clearing the input (e.g, GET /notes) doesn't clear the current
  // input value, since the input isn't replaced by Turbo.
  //
  // To fix this, we manually clear the input on render if we don't have a
  // search param.
  //
  connect() {
    const input = this.element
    const params = new URLSearchParams(window.location.search)
    const query = params.get('q')

    if (!query && !input.value !== '') {
      input.value = ''
    }
  }
}
