import { Controller } from "@hotwired/stimulus";

// TODO: replace with `field-sizing-content` when it's widely available.
//
// - https://developer.mozilla.org/en-US/docs/Web/CSS/field-sizing
// - https://gregkedzierski.com/essays/new-css-property-field-sizing-content/
// - https://tailwindcss.com/docs/field-sizing
//
// Until then, we're using https://github.com/jackmoore/autosize
//
import autosize from "autosize";

// Connects to data-controller="textarea"
export default class extends Controller {
  static targets = ["textarea"];

  connect() {
    autosize(this.textareaTarget);
  }
}
