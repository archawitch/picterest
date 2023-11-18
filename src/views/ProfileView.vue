<script setup>
import { reactive, computed } from "vue";
import { RouterLink } from "vue-router";
import { useUserStore } from "../stores/user";
import Grid from "../components/Grid.vue";
import pinData from "../assets/json/dummy-images.json";
import boardData from "../assets/json/dummy-boards.json";

const followingData = reactive([
  {
    type: "follower",
    count: 2,
  },
  {
    type: "following",
    count: 98,
  },
]);

const userStore = useUserStore();

const currentPage = reactive({
  isCreated: true,
  isSaved: false,
});

const pins = computed(() => {
  return pinData.items.filter(
    (item) => item.creatorUsername === userStore.userData.username,
  );
});

const fullName = computed(() => {
  return `${userStore.userData.fname} ${userStore.userData.lname}`;
});

const followText = computed(() => {
  return `${followingData[0].count} ${
    followingData[0].count <= 1 ? "follower" : "followers"
  } | ${followingData[1].count} following`;
});

const switchMode = () => {
  if (currentPage.isCreated) {
    currentPage.isCreated = false;
    currentPage.isSaved = true;
  } else if (currentPage.isSaved) {
    currentPage.isCreated = true;
    currentPage.isSaved = false;
  }
};
</script>

<template>
  <div class="mt-4 flex flex-col items-center">
    <img class="w-[110px]" :src="userStore.userData.profileImage" />
    <div class="mt-4">
      <h1 class="text-2xl font-bold">{{ fullName }}</h1>
    </div>
    <div class="mt-2 text-sm text-black-3">
      @{{ userStore.userData.username }}
    </div>
    <div class="mt-1.5 text-black-1">{{ userStore.userData.bio }}</div>
    <div class="mt-2 font-semibold text-black-2">{{ followText }}</div>
    <RouterLink to="edit-profile">
      <button
        class="mt-4 rounded-full bg-tertiary px-6 py-2.5 text-sm font-medium transition hover:bg-secondary"
      >
        Edit Profile
      </button>
    </RouterLink>
  </div>
  <div class="mt-8 flex justify-center">
    <button
      @click="switchMode"
      :disabled="currentPage.isCreated"
      class="pr-6 font-medium disabled:font-bold disabled:underline"
    >
      Created
    </button>
    <button
      @click="switchMode"
      :disabled="currentPage.isSaved"
      class="pl-6 font-medium disabled:font-bold disabled:underline"
    >
      Saved
    </button>
  </div>
  <div v-if="currentPage.isCreated" class="mt-6">
    <Grid :pin-items="pins"></Grid>
  </div>
  <div v-if="currentPage.isSaved" class="mt-6">
    <Grid :board-items="boardData.boards"></Grid>
  </div>
</template>
