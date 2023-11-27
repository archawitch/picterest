import axios from "axios";
import { defineStore } from "pinia";

export const useAuthenticationStore = defineStore("authenticationStore", {
  state: () => ({
    valid: false,
  }),
  actions: {
    authenticate() {
      this.valid = true;
    },
    logout() {
      this.valid = false;
    },
  },
  persist: true,
});
