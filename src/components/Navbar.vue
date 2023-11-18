<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import { useNavbarStore } from "../stores/navbar";
import { useUserStore } from "../stores/user";

const router = useRouter();
const navbarStore = useNavbarStore();
const userStore = useUserStore();

const searchText = ref("");
const inputBarDarken = ref(false);

const isAdmin = computed(() => {
  return userStore.userData.userType === "admin";
});

const toggleCreateModal = () => {
  if (navbarStore.isSettingModalOpen) {
    navbarStore.toggleSettingModal();
  }
  navbarStore.toggleCreateModal();
};

const toggleSettingModal = () => {
  if (navbarStore.isCreateModalOpen) {
    navbarStore.toggleCreateModal();
  }
  navbarStore.toggleSettingModal();
};

const resetModal = () => {
  navbarStore.resetModal();
};

const searchInput = () => {
  resetModal();
  router.push({
    name: "home",
    query: { q: searchText.value },
  });
};
</script>

<template>
  <nav class="flex w-full items-center justify-between bg-white px-10 py-4">
    <router-link :to="{ name: 'home' }">
      <button @click="resetModal" class="hidden w-[30px] md:mr-10 md:block">
        <img src="@/assets/images/picterest-logo.png" alt="" />
      </button>
    </router-link>
    <div class="pr-5">
      <router-link :to="{ name: 'home' }">
        <button
          @click="resetModal"
          class="rounded-full px-5 py-3 font-semibold transition duration-150 hover:bg-dark hover:text-white"
          :class="{
            'bg-dark': navbarStore.isHomePage,
            'text-white': navbarStore.isHomePage,
          }"
          :disabled="navbarStore.isHomePage"
        >
          Home
        </button>
      </router-link>
    </div>
    <div class="w-[170px] pl-5 pr-8">
      <button @click="toggleCreateModal()" class="flex">
        <span class="font-semibold">Create&nbsp;</span>
        <span class="ml-1"
          ><font-awesome-icon
            :icon="['fas', 'chevron-down']"
            class="text-gray-600"
        /></span>
      </button>
    </div>

    <form
      @submit.stop.prevent="searchInput()"
      :class="{
        'bg-secondary': inputBarDarken,
        'bg-tertiary': !inputBarDarken,
      }"
      class="mr-10 flex w-full items-center rounded-full px-7 py-3 transition"
    >
      <button type="submit">
        <font-awesome-icon
          :icon="['fas', 'magnifying-glass']"
          class="w-[0.85rem] pr-3 text-black-3"
        />
      </button>

      <input
        @input="searchInput"
        @focus="
          inputBarDarken = true;
          resetModal();
        "
        @blur="
          inputBarDarken = false;
          resetModal();
        "
        type="text"
        placeholder="Search"
        class="w-full bg-transparent text-black-3 outline-none"
        v-model="searchText"
      />
    </form>
    <router-link class="flex" :to="{ name: 'profile' }">
      <button
        @click="resetModal()"
        class="h-[50px] w-[50px] rounded-full bg-cover"
      >
        <img
          class="h-full w-full rounded-full object-cover"
          :src="userStore.userData.profileImage"
        />
      </button>
    </router-link>
    <button @click="toggleSettingModal()" class="ml-4">
      <span
        ><font-awesome-icon
          :icon="['fas', 'chevron-down']"
          class="text-gray-600"
      /></span>
    </button>
  </nav>
  <div
    v-if="navbarStore.isCreateModalOpen"
    class="absolute left-[190px] top-[70px] z-50 rounded-3xl bg-white py-4 pl-6 pr-14 shadow"
  >
    <ul>
      <li class="mb-2">
        <router-link :to="{ name: 'create-pin' }"
          ><button @click="resetModal()">Create pin</button></router-link
        >
      </li>
      <li>
        <router-link :to="{ name: 'create-board' }"
          ><button @click="resetModal()">Create board</button></router-link
        >
      </li>
    </ul>
  </div>
  <div
    v-if="navbarStore.isSettingModalOpen"
    class="absolute right-[30px] top-[70px] z-50 rounded-3xl bg-white py-4 pl-6 pr-12 shadow"
  >
    <ul>
      <li class="mb-2">
        <router-link :to="{ name: 'edit-profile' }"
          ><button @click="resetModal()">Edit Profile</button></router-link
        >
      </li>
      <li v-if="isAdmin" class="mb-2">
        <router-link :to="{ name: 'manage-user' }"
          ><button @click="resetModal()">Manage User</button></router-link
        >
      </li>
      <li>
        <router-link :to="{ name: 'login' }"
          ><button @click="resetModal()">Log out</button></router-link
        >
      </li>
    </ul>
  </div>
</template>
