import { defineStore } from "pinia";

export const useUserStore = defineStore("user", {
  state: () => ({
    userData: {
      profileImage: "/src/assets/images/user/default-profile-image.png",
    },
  }),
  actions: {
    addUser(user) {
      this.userData = user;
    },
  },
  persist: true,
});
