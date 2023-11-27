<script setup>
import { ref, reactive, watch } from "vue";
import CustomInput from "@/components/CustomInput.vue";
import CustomTextarea from "@/components/CustomTextarea.vue";
import axios from "axios";
import { useUserStore } from "../stores/user";

const userStore = useUserStore();

const message = ref(null);
const boardData = reactive({
  name: null,
  description: null,
});

// retrieve created boards
const createBoard = async () => {
  // Perform create board logic

  // Validate user's input
  if (boardData.name === null) {
    message.value = "What is your board name?";
    return;
  }

  // Insert board
  const formData = new FormData();
  formData.append("boardName", boardData.name);
  formData.append("boardDescription", boardData.description);
  formData.append("username", userStore.userData.username);

  const { data } = await axios.post("/api/boards.php", formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  });

  if (data.success) {
    message.value = "Your board has been created.";
  } else {
    message.value = data.message;
  }
};

// reset response message
watch([() => boardData.name, () => boardData.description], () => {
  message.value = "";
});
</script>

<template>
  <div
    class="flex min-h-[calc(100%-82px)] items-center justify-center bg-tertiary py-8"
  >
    <div
      class="flex w-[700px] flex-col justify-center rounded-2xl bg-white px-20 py-14 shadow"
    >
      <div class="flex justify-center">
        <h4 class="text-2xl font-bold">Create Board</h4>
      </div>
      <CustomInput
        class="mt-8"
        v-model="boardData.name"
        label-name="Name"
        input-type="text"
        :required="true"
      ></CustomInput>
      <CustomTextarea
        class="mt-6"
        v-model="boardData.description"
        label-name="Description"
        rows="2"
        :required="true"
      ></CustomTextarea>
      <div class="mt-4 flex items-center">
        <div class="text-red-500" v-if="message">{{ message }}</div>
        <button
          @click.stop="createBoard"
          class="ml-auto rounded-full bg-tertiary px-6 py-2 text-black-0 transition hover:bg-secondary"
        >
          Create
        </button>
      </div>
    </div>
  </div>
</template>
