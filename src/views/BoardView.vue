<script setup>
import Grid from "../components/Grid.vue";
import { useBoardStore } from "../stores/board";
const boardStore = useBoardStore();
</script>

<template>
  <div class="mt-6 flex flex-col items-center">
    <h4 class="mb-6 text-2xl font-bold underline">
      {{ boardStore.boardData.name }}
    </h4>
    <Grid :pin-items="boardStore.boardData.pins"></Grid>
  </div>
</template>
