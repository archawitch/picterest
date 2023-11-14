import { defineStore } from "pinia";

export const useAuthenticationStore = defineStore("authentication", {
  state: () => ({
    valid: false,
  }),
  actions: {
    authenticate() {
      this.valid = true;
    },
  },
});
