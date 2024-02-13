import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  showSpinner(event) {
    const iconRobot = this.element.querySelector("#icon-robot");
    iconRobot.style.display = "none";

    const iconSpinner = this.element.querySelector("#icon-spinner");
    iconSpinner.style.display = "inline-block";
  }
}
