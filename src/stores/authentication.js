import axios from "axios";
import { defineStore } from "pinia";

const loginEndpoint = "/api/auth/login.php";
const registerEndpoint = "/api/auth/register.php";

export const useAuthenticationStore = defineStore("authentication", {
  state: () => ({
    valid: false,
  }),
  actions: {
    authenticate() {
      this.valid = true;
    },
    login(userData) {
      axios
        .post("http://localhost/picterest/backend/api/auth/login.php", {
          username: userData.username,
          password: userData.password,
        })
        .then((response) => {
          console.log("success: " + response.data.message);
        })
        .catch((error) => {
          console.log("error: " + error);
        });
    },
  },
  persist: true,
});
