import { defineStore } from "pinia";

export const useNavbarStore = defineStore("navbarStore", {
  state: () => ({
    isHomePage: true,
  }),
  actions: {
    addCreateActive() {
      this.isHomePage = true;
    },
    removeCreateActive() {
      this.isHomePage = false;
    },
  },
});
