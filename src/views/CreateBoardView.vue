<script setup>
import { reactive } from "vue";
import CustomInput from "@/components/CustomInput.vue";
import CustomTextarea from "@/components/CustomTextarea.vue";

const boardData = reactive({
  name: null,
  description: null,
});

const createBoard = () => {
  // Perform create board logic
  // ...
};
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
      <div class="ml-auto mt-4">
        <button
          @click.stop="createBoard"
          class="rounded-full bg-tertiary px-6 py-2 text-black-0 transition hover:bg-secondary"
        >
          Create
        </button>
      </div>
    </div>
  </div>
</template>
