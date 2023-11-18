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
  // store pin data
  boardStore.readBoard(props.boardData);
  // reset navbar modals
  navbarStore.resetModal();
  // redirect to pin page
  router.push({
    name: "board",
    params: { id: props.boardData.id },
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
        <img
          :class="{
            'w-full': boardData.pins[1] === undefined,
            'w-1/2': boardData.pins[1] !== undefined,
            'w-1/3': boardData.pins[2] !== undefined,
            'w-1/4': boardData.pins[3] !== undefined,
            'rounded-2xl': boardData.pins[1] === undefined,
            'rounded-s-2xl': boardData.pins[1] !== undefined,
          }"
          class="h-[200px] object-cover object-top"
          :src="boardData.pins[0].image"
          alt=""
        />
        <img
          v-if="boardData.pins[1]"
          :class="{
            'w-1/2': boardData.pins[2] === undefined,
            'w-1/3': boardData.pins[2] !== undefined,
            'w-1/4': boardData.pins[3] !== undefined,
            'l-[1/2]': boardData.pins[2] === undefined,
            'l-[1/3]': boardData.pins[2] !== undefined,
            'l-1/4': boardData.pins[3] !== undefined,
            'rounded-e-2xl': boardData.pins[2] === undefined,
          }"
          class="top-0 h-[200px] object-cover object-top"
          :src="boardData.pins[1].image"
          alt=""
        />
        <img
          v-if="boardData.pins[2]"
          :class="{
            'w-1/3': boardData.pins[3] === undefined,
            'w-1/4': boardData.pins[3] !== undefined,
            'l-2/3': boardData.pins[3] === undefined,
            'l-2/4': boardData.pins[3] !== undefined,
            'rounded-e-2xl': boardData.pins[3] === undefined,
          }"
          class="top-0 h-[200px] object-cover object-top"
          :src="boardData.pins[2].image"
          alt=""
        />
        <img
          v-if="boardData.pins[3]"
          class="left-3/4 top-0 h-[200px] w-1/4 rounded-e-xl object-cover object-top"
          :src="boardData.pins[3].image"
          alt=""
        />
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
