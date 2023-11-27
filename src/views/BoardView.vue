<script setup>
import Grid from "../components/Grid.vue";
import { useBoardStore } from "../stores/board";

const boardStore = useBoardStore();
</script>

<template>
  <div class="mt-6 flex flex-col items-center">
    <h4 class="mb-4 text-2xl font-bold underline">
      {{ boardStore.boardData.boardName }}
    </h4>
    <p class="mb-6 text-lg">{{ boardStore.boardData.boardDescription }}</p>
    <Grid :pin-items="boardStore.boardData.pinData"></Grid>
  </div>
</template>
