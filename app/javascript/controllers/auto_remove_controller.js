import { Controller } from "@hotwired/stimulus";
import { debounce } from "utils/debounce";

// Connects to data-controller="auto-remove"
export default class extends Controller {
  static values = { delay: Number };

  initialize() {
    this.remove = this.remove.bind(this);
  }

  connect() {
    if (this.delayValue > 0) {
      debounce(this.remove, this.delayValue)();
    } else {
      this.remove();
    }
  }

  remove() {
    this.element.classList.add("opacity-0");
    setTimeout(() => this.delayValue, 300);
  }
}
