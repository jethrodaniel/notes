import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosave"
//
// Credit: Adapted from https://nts.strzibny.name/rails-autosave-form-turbo-stream/
//
export default class extends Controller {
  static targets = ["form"]

  submit() {
    this.formTarget.requestSubmit()
  }
}
