<script setup>
import { ref, reactive, computed } from "vue";
import { useUserStore } from "../stores/user";

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

const data = reactive({ tags: [""], image: null });
const selectedBoard = ref("0");
const inputTags = ref("");

data.tags = computed(() => {
  let tags = inputTags.value
    .replace(/ /g, "")
    .split(",")
    .filter((tag) => tag.trim().length !== 0);

  if (tags.length <= 1) {
    return tags;
  }

  return Array.from(new Set(tags));
});

const fullName = computed(() => {
  return `${userStore.userData.fname} ${userStore.userData.lname}`;
});

const showImage = (e) => {
  const file = e.target.files[0];

  if (file && file.type.startsWith("image/")) {
    const reader = new FileReader();

    reader.onload = () => {
      data.image = reader.result;
    };

    reader.readAsDataURL(file);
  } else {
    // Handle non-image file types or no file selected
    data.image = null;
  }
};

const uploadPin = () => {
  // Perform upload pin logic
  // ...
};
</script>

<template>
  <div
    class="flex min-h-[calc(100%-82px)] items-center justify-center bg-tertiary py-8"
  >
    <div class="flex flex-col rounded-2xl bg-white p-8 shadow">
      <div class="flex items-start">
        <div class="flex w-[450px] flex-wrap">
          <span
            class="mb-4 mr-2 rounded-full bg-secondary px-4 py-2"
            v-for="tag in data.tags"
            >#{{ tag }}</span
          >
        </div>
        <div class="mb-6 ml-auto flex">
          <select
            v-model="selectedBoard"
            class="mr-4 px-2 outline-none hover:cursor-pointer"
          >
            <option value="0" selected>All pins</option>
            <option v-for="board in boards" :value="board.id">
              {{ board.name }}
            </option>
          </select>
          <button
            @click.stop="uploadPin"
            class="rounded-lg bg-dark px-4 py-2 text-white"
          >
            Save
          </button>
        </div>
      </div>
      <div class="flex w-[600px] items-center">
        <div class="flex h-full w-[220px] flex-col items-center justify-center">
          <label
            :class="{ hidden: data.image }"
            class="flex h-[400px] w-full cursor-pointer flex-col items-center justify-center rounded-xl border bg-secondary p-5 text-sm text-black-3"
          >
            <font-awesome-icon
              class="mb-3 text-xl"
              :icon="['fas', 'circle-up']"
            />
            <span class="title">Click to upload</span>
            <input
              class="hidden opacity-0 outline-none"
              type="file"
              accept="image/png, image/jpeg"
              @change="showImage"
            />
          </label>
          <label
            :class="{ hidden: !data.image }"
            class="flex h-full w-full cursor-pointer flex-col items-center justify-center rounded-xl text-sm text-black-3"
          >
            <img
              class="w-[252px] rounded-xl"
              v-if="data.image"
              :src="data.image"
              alt="preview image"
            />
            <div class="pt-4">
              <font-awesome-icon class="mr-2" :icon="['fas', 'arrow-up']" />
              <span>reupload</span>
              <input
                class="hidden opacity-0 outline-none"
                type="file"
                accept="image/png, image/jpeg"
                @change="showImage"
              />
            </div>
          </label>
        </div>
        <div class="w-[380px]">
          <div class="pb-4 pl-8 pr-0 pt-8">
            <input
              class="mb-1 ml-2 text-2xl text-black-1 outline-none"
              type="text"
              placeholder="Add Title"
              v-model="data.title"
            />
            <hr class="mb-12" />
            <input
              class="mb-1 ml-2 text-black-1 outline-none"
              type="text"
              placeholder="Add Description"
              v-model="data.description"
            />
            <hr class="mb-6" />
            <input
              class="mb-1 ml-2 text-black-1 outline-none"
              type="text"
              placeholder="Add Tags"
              v-model="inputTags"
            />
            <hr class="mb-6" />
            <input
              class="mb-1 ml-2 text-black-1 outline-none"
              type="text"
              placeholder="Add URL"
              v-model="data.url"
            />
            <hr class="mb-8" />
            <div class="flex items-center">
              <img
                class="h[40px] mr-4 w-[40px]"
                :src="userStore.userData.profileImage"
                alt=""
              />
              <span>{{ fullName }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
