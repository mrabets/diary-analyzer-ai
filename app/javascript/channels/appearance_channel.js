import consumer from "./consumer"

consumer.subscriptions.create("AppearanceChannel", {
  connected() {
  },

  disconnected() {
  },

  received(data) {
  }
});
