import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  clear(event) {
    this.element.reset();
  }
}
