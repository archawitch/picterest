import { defineStore } from "pinia";

export const usePinStore = defineStore("pin", {
  state: () => ({
    pinData: null,
  }),
  actions: {
    readPin(pin) {
      this.pinData = pin;
    },
  },
  persist: true,
});
