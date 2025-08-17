import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="confirm"
export default class extends Controller {
  static values = { message: String };

  submit(event) {
    if (!confirm(this.messageValue)) {
      event.preventDefault();
    }
  }
}
