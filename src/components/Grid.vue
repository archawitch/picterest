<script setup>
import MasonryWall from "@yeger/vue-masonry-wall";
import Pin from "./Pin.vue";
import Board from "./Board.vue";

const props = defineProps({
  pinItems: Array,
  boardItems: Array,
  from: String,
});
</script>

<template>
  <div v-if="pinItems" class="w-full px-4 pb-4">
    <MasonryWall
      :items="pinItems"
      :ssr-columns="1"
      :column-width="250"
      :gap="16"
    >
      <template #default="{ item, index }">
        <Pin :pin-data="item" :from="from"></Pin>
      </template>
    </MasonryWall>
  </div>
  <div v-if="boardItems" class="px-4 pb-4">
    <MasonryWall
      :items="boardItems"
      :ssr-columns="1"
      :column-width="250"
      :gap="16"
    >
      <template #default="{ item, index }">
        <Board :board-data="item"></Board>
        <div class="my-2 flex justify-center">{{ item.name }}</div>
      </template>
    </MasonryWall>
  </div>
</template>
