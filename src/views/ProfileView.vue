<script setup>
import { ref, reactive, computed, onMounted } from "vue";
import { RouterLink } from "vue-router";
import { useUserStore } from "../stores/user";
import Grid from "../components/Grid.vue";
import axios from "axios";

const userStore = useUserStore();

const boards = ref([]);
const pinData = ref(null);
const followingData = reactive({
  followerCount: 0,
  followingCount: 0,
});
const currentPage = reactive({
  isCreated: true,
  isSaved: false,
});

onMounted(() => {
  findCreatedPin();
  findSavedPin();
  findFollowData();
});

const findCreatedPin = async () => {
  await axios
    .get("api/pins.php", {
      params: {
        username: userStore.userData.username,
        action: "selectMany",
      },
    })
    .then((response) => (pinData.value = response.data.pinData))
    .catch((error) => console.log(error));
};

const findSavedPin = async () => {
  const saveResponse = await axios.get("/api/save.php", {
    params: {
      username: userStore.userData.username,
    },
  });

  if (saveResponse.data.success) {
    const pinData = {
      boardName: "All pins",
      ...saveResponse.data,
    };
    boards.value = [...boards.value, pinData];
  }

  const boardResponse = await axios.get("/api/boards.php", {
    params: {
      username: userStore.userData.username,
      action: "selectMany",
    },
  });

  if (boardResponse.data.success && boardResponse.data.boardData != null) {
    boardResponse.data.boardData.forEach((boardData) => {
      boards.value = [...boards.value, boardData];
    });
  }
};

const findFollowData = async () => {
  // retrieve follower count
  const responseFollower = await axios.get("/api/follow.php", {
    params: {
      username: userStore.userData.username,
      action: "readFollowerCount",
    },
  });

  if (responseFollower.data.success) {
    followingData.followerCount = responseFollower.data.followerCount;
  }

  // retrieve following count
  const responseFollowing = await axios.get("/api/follow.php", {
    params: {
      username: userStore.userData.username,
      action: "readFollowingCount",
    },
  });

  if (responseFollowing.data.success) {
    followingData.followingCount = responseFollowing.data.followingCount;
  }
};

const switchMode = () => {
  if (currentPage.isCreated) {
    currentPage.isCreated = false;
    currentPage.isSaved = true;
  } else if (currentPage.isSaved) {
    currentPage.isCreated = true;
    currentPage.isSaved = false;
  }
};

const fullName = computed(() => {
  return `${userStore.userData.firstName ?? ""} ${
    userStore.userData.lastName ?? ""
  }`;
});

const followText = computed(() => {
  return `${followingData.followerCount} ${
    followingData.followerCount <= 1 ? "follower" : "followers"
  } | ${followingData.followingCount} following`;
});
</script>

<template>
  <div class="mt-4 flex flex-col items-center">
    <img
      class="h-[120px] w-[120px] rounded-full object-cover"
      :src="userStore.userData.profileImage"
    />
    <div class="mt-4">
      <h1 class="text-2xl font-bold">{{ fullName }}</h1>
    </div>
    <div class="mt-1.5 text-sm text-black-3">
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
  <div v-if="currentPage.isCreated && pinData" class="mt-6">
    <Grid :pin-items="pinData"></Grid>
  </div>
  <div v-if="currentPage.isSaved" class="mt-6">
    <Grid v-if="boards" :board-items="boards"></Grid>
  </div>
</template>
