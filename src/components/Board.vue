<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { useBoardStore } from "../stores/board";
import { useNavbarStore } from "../stores/navbar";

const router = useRouter();
const boardStore = useBoardStore();
const navbarStore = useNavbarStore();

const props = defineProps({
  boardData: Object,
  from: String,
});

const isHovered = ref(false);

const goToBoard = () => {
  // store board data
  boardStore.readBoard(props.boardData);
  // reset navbar modals
  navbarStore.resetModal();
  // redirect to pin page
  router.push({
    name: "board",
    params: { id: props.boardData.boardId > 0 ? props.boardData.boardId : 0 },
  });
};
</script>

<template>
  <div class="card">
    <div
      class="relative flex items-center justify-center transition"
      @mouseenter="isHovered = true"
      @mouseleave="isHovered = false"
    >
      <button
        :class="{ 'brightness-90': isHovered }"
        class="flex w-full transition"
        @click="goToBoard()"
      >
        <div class="h-[200px] w-full rounded-2xl bg-gray-300"></div>
        <div v-if="boardData.pinData.length > 0" class="absolute flex w-full">
          <img
            :class="{
              'w-full': boardData.pinData.length === 1,
              'w-1/2': boardData.pinData.length === 2,
              'w-1/3': boardData.pinData.length === 3,
              'w-1/4': boardData.pinData.length >= 4,
              'rounded-2xl': boardData.pinData.length === 1,
              'rounded-s-2xl': boardData.pinData.length > 1,
            }"
            v-if="boardData.pinData"
            class="h-[200px] object-cover object-top"
            :src="boardData.pinData[0].pinImage"
            alt=""
          />
          <img
            v-if="boardData.pinData.length > 1"
            :class="{
              'w-1/2': boardData.pinData.length === 2,
              'w-1/3': boardData.pinData.length === 3,
              'w-1/4': boardData.pinData.length >= 4,
              'l-[1/2]': boardData.pinData.length === 2,
              'l-[1/3]': boardData.pinData.length === 3,
              'l-1/4': boardData.pinData.length >= 4,
              'rounded-e-2xl': boardData.pinData.length === 2,
            }"
            class="top-0 h-[200px] object-cover object-top"
            :src="boardData.pinData[1].pinImage"
            alt=""
          />
          <img
            v-if="boardData.pinData.length > 2"
            :class="{
              'w-1/3': boardData.pinData.length === 3,
              'w-1/4': boardData.pinData.length >= 4,
              'l-2/3': boardData.pinData.length === 3,
              'l-2/4': boardData.pinData.length >= 4,
              'rounded-e-2xl': boardData.pinData.length === 3,
            }"
            class="top-0 h-[200px] object-cover object-top"
            :src="boardData.pinData[2].pinImage"
            alt=""
          />
          <img
            v-if="boardData.pinData.length > 3"
            class="left-3/4 top-0 h-[200px] w-1/4 rounded-e-xl object-cover object-top"
            :src="boardData.pinData[3].pinImage"
            alt=""
          />
        </div>
      </button>
      <button
        @click="goToBoard()"
        :class="{ 'text-white': isHovered, 'text-transparent': !isHovered }"
        class="absolute flex items-center justify-center text-xl font-semibold transition"
      >
        See this board
      </button>
    </div>
  </div>
</template>
