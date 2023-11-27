<script setup>
import { ref, reactive, computed } from "vue";
import { useUserStore } from "../stores/user";
import { useRouter } from "vue-router";
import axios from "axios";
import { onMounted } from "vue";

const router = useRouter();
const userStore = useUserStore();

const boards = ref([
  {
    boardId: 0,
    boardName: "All pins",
  },
]);

const formData = reactive({
  tags: [""],
  image: null,
  title: null,
  description: null,
  url: null,
});

const selectedBoard = ref("0");
const inputTags = ref("");
const fileInput = ref(null);

onMounted(() => {
  findBoards();
});

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
        console.log(boards.value);
      }
    });
};

const showImage = (e) => {
  fileInput.value = e.target.files[0];

  if (fileInput.value && fileInput.value.type.startsWith("image/")) {
    const reader = new FileReader();

    reader.onload = () => {
      formData.image = reader.result;
    };

    reader.readAsDataURL(fileInput.value);
  } else {
    // Handle non-image file types or no file selected
    fileInput.value = null;
    formData.image = null;
  }
};

const uploadPin = async () => {
  // Perform upload pin logic

  // Validate input
  if (fileInput.value === null) {
    alert("No input image");
    return;
  }

  const formDataForInsert = new FormData();
  formDataForInsert.append("pinImage", fileInput.value);
  formDataForInsert.append("pinTitle", formData.title);
  formDataForInsert.append("pinDescription", formData.description);
  formDataForInsert.append("pinUrl", formData.url);
  formDataForInsert.append(
    "pinTags",
    formData.tags.length !== 0 ? formData.tags : null,
  );
  formDataForInsert.append("username", userStore.userData.username);
  const { data } = await axios.post("/api/pins.php", formDataForInsert);

  if (!data.success) {
    console.log(data);
    alert("(╥﹏╥) Failed to save");
  }

  // save pin
  const formDataForSave = new FormData();
  formDataForSave.append("pinId", data.pinId);
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
    formDataForSaveToBoard.append("pinId", data.pinId);
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

  router.push({ name: "profile" });
};

formData.tags = computed(() => {
  let tags = inputTags.value
    .replace(/ /g, "")
    .toLowerCase()
    .split(",")
    .filter((tag) => tag.trim().length !== 0);

  if (tags.length <= 1) {
    return tags;
  }

  return Array.from(new Set(tags));
});

const fullName = computed(() => {
  return `${userStore.userData.firstName ?? ""} ${
    userStore.userData.lastName ?? ""
  }`;
});
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
            v-for="tag in formData.tags"
            >#{{ tag }}</span
          >
        </div>
        <div class="mb-6 ml-auto flex">
          <select
            v-model="selectedBoard"
            class="mr-4 px-2 outline-none hover:cursor-pointer"
          >
            <option value="0" selected>All pins</option>
            <option v-for="board in boards" :value="board.boardId">
              {{ board.boardName }}
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
            :class="{ hidden: formData.image }"
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
            :class="{ hidden: !formData.image }"
            class="flex h-full w-full cursor-pointer flex-col items-center justify-center rounded-xl text-sm text-black-2"
          >
            <img
              class="w-[252px] rounded-xl"
              v-if="formData.image"
              :src="formData.image"
              alt="preview image"
            />
            <div class="flex items-center pt-4">
              <font-awesome-icon
                class="mr-2 text-base"
                :icon="['fas', 'circle-up']"
              />
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
              class="mb-1 w-full px-2 text-2xl text-black-1 outline-none"
              type="text"
              placeholder="Add Title"
              v-model="formData.title"
            />
            <hr class="mb-12" />
            <input
              class="mb-1 w-full px-2 text-black-1 outline-none"
              type="text"
              placeholder="Add Description"
              v-model="formData.description"
            />
            <hr class="mb-6" />
            <input
              class="mb-1 w-full px-2 text-black-1 outline-none"
              type="text"
              placeholder="Add Tags"
              v-model="inputTags"
            />
            <hr class="mb-6" />
            <input
              class="mb-1 w-full px-2 text-black-1 outline-none"
              type="text"
              placeholder="Add URL"
              v-model="formData.url"
            />
            <hr class="mb-8" />
            <div class="flex items-center">
              <img
                class="mr-4 h-[50px] w-[50px] rounded-full object-cover"
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
