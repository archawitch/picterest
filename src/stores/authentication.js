import { defineStore } from "pinia";

const loginEndpoint = "/api/auth/login.php";
const registerEndpoint = "/api/auth/register.php";

export const useAuthenticationStore = defineStore("authentication", {
  state: () => ({
    valid: false,
  }),
  actions: {
    authenticate(user) {
      this.valid = true;
    },
  },
  persist: true,
});
