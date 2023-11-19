<script setup>
import { ref, reactive, computed } from "vue";
import { usePinStore } from "../stores/pin";
import { useUserStore } from "../stores/user";

const pinStore = usePinStore();
const userStore = useUserStore();

const boards = reactive([
  {
    id: 1,
    name: "Board 1",
    description: "",
  },
  {
    id: 2,
    name: "Board 2",
    description: "",
  },
  {
    id: 3,
    name: "Board 3",
    description: "",
  },
]);

const tags = reactive([
  {
    id: 1,
    name: "cat",
  },
  {
    id: 2,
    name: "cat-lover",
  },
  {
    id: 3,
    name: "i-am-cat",
  },
  {
    id: 1,
    name: "cat",
  },
  {
    id: 2,
    name: "cat-lover",
  },
  {
    id: 3,
    name: "i-am-cat",
  },
]);

const comments = reactive([
  {
    name: "John Doe",
    profileImage: "/src/assets/images/dummy-images/Google.jpg",
    comment: "So lovely!",
  },
  {
    name: "Adam Smith",
    profileImage: "/src/assets/images/dummy-images/Google.jpg",
    comment: "I think so!",
  },
]);

const selectedBoard = ref("0");
const isSaved = ref(false);
const isFollowed = ref(false);
const commentBarDarken = ref(false);
const commentText = ref("");

const computedURL = computed(() => {
  if (pinStore.pinData.url !== undefined && pinStore.pinData.url !== null) {
    let url = pinStore.pinData.url;
    const firstIndex = url.split("/", 2).join("/").length;
    const lastIndex = url.split("/", 3).join("/").length;

    return `${url.slice(firstIndex + 1, lastIndex)}`;
  }

  return "";
});

const savePin = () => {
  isSaved.value = !isSaved.value;
  // Perform save pin logic
  // ...
};
const followUser = () => {
  isFollowed.value = !isFollowed.value;
  // Perform follow logic
  // ...
};
</script>

<template>
  <div
    class="flex min-h-[calc(100%-82px)] items-center justify-center bg-tertiary py-8"
  >
    <div class="flex rounded-2xl bg-white shadow">
      <div class="h-full">
        <img class="w-96 rounded-s-2xl" :src="pinStore.pinData.image" alt="" />
      </div>
      <div class="flex w-[32rem] flex-col justify-center px-10 py-6">
        <div class="flex items-center">
          <div class="mr-auto">
            <a
              class="underline"
              @click.stop="(event) => {}"
              :href="pinStore.pinData.url"
              target="_blank"
              >{{ computedURL }}</a
            >
          </div>
          <div class="pl-2 pr-4">
            <select
              class="px-2 py-2 outline-none hover:cursor-pointer"
              v-model="selectedBoard"
            >
              <option value="0">All pins</option>
              <option v-for="board in boards" :value="board.id">
                {{ board.name }}
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
          <h2 class="text-3xl">{{ pinStore.pinData.title }}</h2>
        </div>
        <div class="mt-3">
          <p>{{ pinStore.pinData.description }}</p>
        </div>
        <div class="mt-2 flex flex-wrap">
          <div v-for="tag in tags">
            <button class="mr-3 mt-2 rounded-full bg-secondary px-4">
              #{{ tag.name }}
            </button>
          </div>
        </div>
        <div class="mt-6 flex items-center">
          <img
            class="mr-4 h-[50px] w-[50px] rounded-full object-cover"
            :src="userStore.userData.profileImage"
            alt=""
          />
          <span>{{ pinStore.pinData.creatorFullName }}</span>
          <button
            @click="followUser()"
            class="ml-auto rounded-full bg-tertiary px-7 py-3"
            :class="{
              'hover:brightness-95': !isFollowed,
              'brightness-95': isFollowed,
              hidden:
                userStore.userData.username ===
                pinStore.pinData.creatorUsername,
            }"
          >
            {{ isFollowed ? "Followed" : "Follow" }}
          </button>
        </div>
        <div class="my-4">
          <h5 class="text-lg">Comments</h5>
          <div
            v-for="comment in comments"
            class="mt-3 flex flex-nowrap items-center text-sm"
          >
            <img
              class="mr-4 h-[40px] w-[40px] rounded-full object-cover"
              :src="comment.profileImage"
              alt=""
            />
            <div class="flex items-center">
              <span class="max-w-[100px] font-medium">{{ comment.name }}</span>
              &nbsp;-&nbsp;
              <span class="max-w-[300px]">{{ comment.comment }}</span>
            </div>
          </div>
        </div>
        <hr />
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
              class="w-full bg-transparent pr-4 text-black-3 outline-none"
              v-model="commentText"
            />
            <button class="text-sm font-semibold text-gray-500">Add</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
