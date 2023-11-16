<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import { useNavbarStore } from "../stores/navbar";
import { useUserStore } from "../stores/user";

const router = useRouter();
const navbarStore = useNavbarStore();
const userStore = useUserStore();

const isCreateModalOpen = ref(false);
const isSettingModalOpen = ref(false);
const searchText = ref("");

const isAdmin = computed(() => {
  return userStore.userData.userType == "admin";
});

const toggleCreateModal = () => {
  isCreateModalOpen.value = !isCreateModalOpen.value;
};

const toggleSettingModal = () => {
  isSettingModalOpen.value = !isSettingModalOpen.value;
};

const searchInput = () => {
  router.push({
    name: "home",
    query: { q: searchText.value },
  });
};
</script>

<template>
  <nav class="flex w-full items-center justify-between bg-white px-10 py-4">
    <router-link :to="{ name: 'home' }">
      <button class="hidden w-[30px] md:mr-10 md:block">
        <img src="@/assets/images/picterest-logo.png" alt="" />
      </button>
    </router-link>
    <div class="pr-5">
      <router-link :to="{ name: 'login' }">
        <button
          class="rounded-full px-5 py-3"
          :class="{ active: navbarStore.isHomePage }"
          :disabled="navbarStore.isHomePage"
        >
          Home
        </button>
      </router-link>
    </div>
    <div class="w-[170px] pl-5 pr-8">
      <button @click="toggleCreateModal()" class="flex">
        <span>Create&nbsp;</span>
        <span class="ml-1"
          ><font-awesome-icon
            :icon="['fas', 'chevron-down']"
            class="text-gray-600"
        /></span>
      </button>
    </div>

    <form
      class="mr-10 flex w-full items-center rounded-full bg-secondary px-7 py-3"
    >
      <font-awesome-icon
        :icon="['fas', 'magnifying-glass']"
        class="w-[0.85rem] pr-3 text-black-3"
      />
      <input
        @input="searchInput"
        type="text"
        placeholder="Search"
        class="focus: w-full bg-transparent text-black-3 outline-none"
        v-model="searchText"
      />
    </form>
    <router-link class="flex" :to="{ name: 'home' }">
      <button
        class="h-[50px] w-[50px] bg-cover"
        :style="{
          backgroundImage: 'url(' + userStore.userData.profileImage + ')',
        }"
      ></button>
    </router-link>
    <button @click="toggleSettingModal" class="ml-4">
      <span
        ><font-awesome-icon
          :icon="['fas', 'chevron-down']"
          class="text-gray-600"
      /></span>
    </button>
  </nav>
  <div
    v-if="isCreateModalOpen"
    class="absolute left-[190px] top-[70px] rounded-3xl bg-white py-4 pl-6 pr-14 shadow"
  >
    <ul>
      <li class="mb-2">
        <router-link :to="{ name: 'home' }"
          ><button>Create pin</button></router-link
        >
      </li>
      <li>
        <router-link :to="{ name: 'home' }"
          ><button>Create board</button></router-link
        >
      </li>
    </ul>
  </div>
  <div
    v-if="isSettingModalOpen"
    class="absolute right-[30px] top-[70px] rounded-3xl bg-white py-4 pl-6 pr-12 shadow"
  >
    <ul>
      <li class="mb-2">
        <router-link :to="{ name: 'home' }"
          ><button @click="">Edit Profile</button></router-link
        >
      </li>
      <li v-if="isAdmin" class="mb-2">
        <router-link :to="{ name: 'home' }"
          ><button>Manage User</button></router-link
        >
      </li>
      <li>
        <router-link :to="{ name: 'login' }"
          ><button>Log out</button></router-link
        >
      </li>
    </ul>
  </div>
  <router-link to="/auth/login">Login</router-link>
</template>

<style scoped>
.active {
  background-color: var(--bg-black);
  color: white;
  font-weight: 600;
}
</style>
