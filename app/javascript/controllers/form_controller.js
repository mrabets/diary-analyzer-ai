import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reset(event) {
    this.element.reset();
    this.messages = document.getElementById("messages");
    this.resetScroll();
  }

  submitOnEnter(event) {
    if (event.keyCode === 13 && !event.shiftKey) {
      event.preventDefault();
      event.target.form.requestSubmit();
    }
  }

  resetScroll() {
    this.messages.scrollTop = this.messages.scrollHeight - this.messages.clientHeight;
  }
}
