import { defineStore } from "pinia";

export const useNavbarStore = defineStore("navbarStore", {
  state: () => ({
    isHomePage: false,
    isCreateModalOpen: false,
    isSettingModalOpen: false,
  }),
  actions: {
    addCreateActive() {
      this.isHomePage = true;
    },
    removeCreateActive() {
      this.isHomePage = false;
    },
    toggleCreateModal() {
      this.isCreateModalOpen = !this.isCreateModalOpen;
    },
    toggleSettingModal() {
      this.isSettingModalOpen = !this.isSettingModalOpen;
    },
    resetModal() {
      this.isCreateModalOpen = false;
      this.isSettingModalOpen = false;
    },
  },
});
