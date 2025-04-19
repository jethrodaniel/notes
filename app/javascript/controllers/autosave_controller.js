import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosave"
//
// Adapted from:
// - https://nts.strzibny.name/rails-autosave-form-turbo-stream/
// - https://github.com/stimulus-components/stimulus-components/blob/master/components/auto-submit/src/index.ts
//
export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.submit = this.#debounce(() => this.formTarget.requestSubmit(), 300)
  }

  #debounce(callback, delay) {
    let timeoutId

    return (...args) => {
      clearTimeout(timeoutId)
      timeoutId = setTimeout(() => callback.apply(this, args), delay)
    }
  }
}
