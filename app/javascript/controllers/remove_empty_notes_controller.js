import { Controller } from "@hotwired/stimulus"
import { debounce } from "utils/debounce"

// Connects to data-controller="remove-empty-notes"
export default class extends Controller {
  static values = { delay: Number }
  static targets = [ "form", "item" ]

  initialize() {
    this.submit = this.submit.bind(this)
  }

  connect() {
    if (this.delayValue > 0) {
      debounce(this.submit, this.delayValue)()
    } else {
      this.submit()
    }
  }

  submit() {
    for (const form of this.formTargets) {
      form.requestSubmit()
    }

    for (const item of this.itemTargets) {
      item.remove()
    }
  }
}
