<script setup>
import { ref, reactive, computed, onMounted } from "vue";
import { useUserStore } from "../stores/user";
import axios from "axios";
import { useRouter, useRoute } from "vue-router";

const route = useRoute();
const router = useRouter();
const userStore = useUserStore();

const boards = ref(null);

const comments = ref([]);

const pinData = ref(null);
const selectedBoard = ref("0");
const isSaved = ref(false);
const isFollowed = ref(false);
const commentBarDarken = ref(false);
const commentText = ref("");
const savedPinData = reactive({
  pinId: null,
  boardId: null,
  username: userStore.userData.username,
});

onMounted(async () => {
  await findPin();
  findBoards();
  findCommentData();
});

const findPin = async () => {
  await axios
    .get("/api/pins.php", {
      params: {
        pinId: route.params.id,
        action: "selectOne",
      },
    })
    .then((response) => (pinData.value = response.data.pinData))
    .catch((error) => console.log(error));

  // check if a pin is already saved or not
  checkSave();
  // check if the user follows the creator of the pin or not
  if (pinData.value.username !== userStore.userData.username) {
    checkFollow();
  }
};

const findBoards = async () => {
  await axios
    .get("/api/boards.php", {
      params: {
        username: userStore.userData.username,
        action: "selectMany",
      },
    })
    .then((response) => {
      if (response.data.boardData != null) {
        boards.value = [...response.data.boardData];
      }
    });
};

const findCommentData = async () => {
  // retrieve comment data
  const { data } = await axios.get("/api/comment.php", {
    params: {
      pinId: pinData.value.pinId,
    },
  });

  if (data.success) {
    comments.value = [...data.comments];
  }
};

const checkSave = async () => {
  const { data } = await axios.get("/api/check.php", {
    params: {
      username: userStore.userData.username,
      pinId: pinData.value.pinId,
      action: "checkSave",
    },
  });
  if (data.success && data.isSaved) {
    savedPinData.pinId = pinData.value.pinId;
    savedPinData.username = userStore.userData.username;
    isSaved.value = true;
  }
};

const checkFollow = async () => {
  const { data } = await axios.get("/api/check.php", {
    params: {
      username: userStore.userData.username,
      usernameToFollow: pinData.value.username,
      action: "checkFollow",
    },
  });
  if (data.success && data.isFollowed) {
    isFollowed.value = true;
  }
};

const savePin = async () => {
  // Perform save pin logic

  // save pin
  if (!isSaved.value) {
    const formDataForSave = new FormData();
    formDataForSave.append("pinId", pinData.value.pinId);
    formDataForSave.append("username", userStore.userData.username);
    // insert save
    const saveResponse = await axios.post("/api/save.php", formDataForSave);

    if (!saveResponse.data.success) {
      console.log(saveResponse.data);
      alert("(╥﹏╥) Failed to save");
      return;
    }

    // insert is_in if any board is selected
    if (selectedBoard.value !== "0") {
      const formDataForSaveToBoard = new FormData();
      formDataForSaveToBoard.append("pinId", pinData.value.pinId);
      formDataForSaveToBoard.append("boardId", selectedBoard.value);

      const saveToBoardResponse = await axios.post(
        "/api/is_in.php",
        formDataForSaveToBoard,
      );

      if (!saveToBoardResponse.data.success) {
        console.log(saveToBoardResponse.data);
        alert("(╥﹏╥) Failed to save");
        return;
      }
    }

    savedPinData.pinId = pinData.value.pinId;
    savedPinData.boardId = selectedBoard.value;

    isSaved.value = true;
  }
  // remove save pin
  else if (isSaved.value) {
    // insert is_in if any board is selected
    const saveToBoardResponse = await axios.delete("/api/is_in.php", {
      data: {
        pinId: savedPinData.pinId,
        username: savedPinData.username,
      },
    });

    if (!saveToBoardResponse.data.success) {
      console.log(saveToBoardResponse.data);
      alert("(╥﹏╥) Failed to save");
      return;
    }

    // insert save
    const saveResponse = await axios.delete("/api/save.php", {
      data: {
        pinId: savedPinData.pinId,
        username: savedPinData.username,
      },
    });

    if (!saveResponse.data.success) {
      console.log(saveResponse.data);
      alert("(╥﹏╥) Failed to save");
      return;
    }
    savedPinData.pinId = null;
    savedPinData.boardId = null;

    isSaved.value = false;
  }
};

const followUser = async () => {
  // Perform follow logic

  // follow
  if (!isFollowed.value) {
    const formData = new FormData();
    formData.append("usernameToFollow", pinData.value.username);
    formData.append("username", userStore.userData.username);

    const { data } = await axios.post("/api/follow.php", formData);

    // follow successfully
    if (data.success) {
      isFollowed.value = true;
    }
  } else if (isFollowed.value) {
    const { data } = await axios.delete("/api/follow.php", {
      data: {
        usernameToUnfollow: pinData.value.username,
        username: userStore.userData.username,
      },
    });

    // follow successfully
    if (data.success) {
      isFollowed.value = false;
    }
  }
};

const addComment = async () => {
  const formData = new FormData();
  formData.append("username", userStore.userData.username);
  formData.append("pinId", pinData.value.pinId);
  formData.append("text", commentText.value);
  const { data } = await axios.post("/api/comment.php", formData);

  if (data.success) {
    await findCommentData();
    commentText.value = "";
  }
};

const tagClick = (tagName) => {
  router.push({ name: "home", query: { q: tagName } });
};

const computedUrl = computed(() => {
  if (pinData.value.pinUrl !== undefined && pinData.value.pinUrl !== null) {
    let url = pinData.value.pinUrl;
    if (url.includes("http")) {
      const firstIndex = url.split("/", 2).join("/").length;
      return `${url.slice(firstIndex + 1, url.length)}`;
    } else {
      return url;
    }
  }
  return "";
});
</script>

<template>
  <div
    class="flex min-h-[calc(100%-82px)] items-center justify-center bg-tertiary py-8"
  >
    <div v-if="pinData" class="flex rounded-2xl bg-white shadow">
      <div class="h-full">
        <img class="w-96 rounded-s-2xl" :src="pinData.pinImage" alt="" />
      </div>
      <div class="flex w-[32rem] flex-col justify-center px-10 py-6">
        <div class="flex items-center">
          <div class="mr-auto">
            <a
              class="underline"
              @click.stop="(event) => {}"
              :href="'https://' + computedUrl"
              target="_blank"
              v-if="computedUrl"
              >Visit site</a
            >
          </div>
          <div class="pl-2 pr-4">
            <select
              class="px-2 py-2 outline-none hover:cursor-pointer"
              v-model="selectedBoard"
            >
              <option value="0">All pins</option>
              <option v-for="board in boards" :value="board.boardId">
                {{ board.boardName }}
              </option>
              <span class="ml-1"
                ><font-awesome-icon
                  :icon="['fas', 'chevron-down']"
                  class="text-gray-600"
              /></span>
            </select>
          </div>
          <button
            @click="savePin()"
            class="rounded-full bg-dark px-5 py-3 text-white transition"
          >
            {{ isSaved ? "Saved!" : "Save" }}
          </button>
        </div>
        <div class="mt-4">
          <h2 class="text-3xl" v-if="pinData.pinTitle">
            {{ pinData.pinTitle }}
          </h2>
        </div>
        <div class="mt-3">
          <p v-if="pinData.pinDescription">{{ pinData.pinDescription }}</p>
        </div>
        <div v-if="pinData.tags" class="mt-2 flex flex-wrap">
          <div v-for="tag in pinData.tags">
            <button
              @click.prevent="tagClick(tag.tagName)"
              class="mr-3 mt-2 rounded-full bg-secondary px-4"
            >
              #{{ tag.tagName }}
            </button>
          </div>
        </div>
        <div class="mt-6 flex items-center">
          <img
            class="mr-4 h-[50px] w-[50px] rounded-full object-cover"
            :src="pinData.profileImage"
            alt=""
          />
          <span>{{ pinData.fullname }}</span>
          <button
            @click="followUser()"
            class="ml-auto rounded-full bg-tertiary px-7 py-3"
            :class="{
              'hover:brightness-95': !isFollowed,
              'brightness-95': isFollowed,
            }"
            v-if="userStore.userData.username !== pinData.username"
          >
            {{ isFollowed ? "Followed" : "Follow" }}
          </button>
        </div>
        <div v-if="comments.length > 0" class="mt-4">
          <h5 class="text-lg">Comments</h5>
          <div
            v-for="comment in comments"
            class="mt-3 flex flex-nowrap items-center text-sm"
          >
            <div class="mr-4 flex min-w-[40px]">
              <img
                class="h-[40px] w-[40px] rounded-full object-cover"
                :src="comment.profileImage"
                alt=""
              />
            </div>
            <div class="">
              <div class="inline font-medium">{{ comment.fullname }}</div>
              &nbsp;-&nbsp;{{ comment.text }}
            </div>
          </div>
        </div>
        <hr class="mt-6" />
        <div class="mt-4 flex w-full items-center">
          <div class="pr-2">
            <img
              class="mr-4 h-[48px] w-[48px] rounded-full object-cover"
              :src="userStore.userData.profileImage"
              alt=""
            />
          </div>
          <div
            :class="{
              'bg-secondary': commentBarDarken,
              'bg-tertiary': !commentBarDarken,
            }"
            class="flex w-full items-center rounded-full px-7 py-3 transition"
          >
            <input
              @focus="commentBarDarken = true"
              @blur="commentBarDarken = false"
              type="text"
              placeholder="Add a comment"
              class="w-full bg-transparent pr-4 text-black-2 outline-none"
              v-model="commentText"
            />
            <button
              class="text-sm font-semibold text-gray-500"
              @click.stop.prevent="addComment"
            >
              Add
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
