import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.adjustWidth();
  }

  adjustWidth() {
    const messageLength = this.element.textContent.trim().length;
    this.element.style.width = this.calculateWidth(messageLength);
  }

  calculateWidth(length) {
    const widthThresholds = [
      { max: 30, width: '20%' },
      { max: 40, width: '30%' },
      { max: 60, width: '40%' },
      { max: 80, width: '50%' },
      { max: 100, width: '60%' },
      { max: 120, width: '70%' },
      { max: 140, width: '80%' },
      { max: 160, width: '90%' },
      { max: Infinity, width: '100%' }
    ];

    return widthThresholds.find(threshold => length < threshold.max).width;
  }
}
