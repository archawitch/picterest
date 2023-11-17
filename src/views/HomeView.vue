<script setup>
import imageData from "../assets/json/dummy-images.json";
import arrayShuffle from "array-shuffle";
import Grid from "../components/Grid.vue";
import { useNavbarStore } from "../stores/navbar";
import { onMounted } from "vue";
import { onUnmounted } from "vue";

const navbarStore = useNavbarStore();

onMounted(() => {
  navbarStore.addCreateActive();
});

onUnmounted(() => {
  navbarStore.removeCreateActive();
});
</script>

<template>
  <Grid :pin-items="arrayShuffle(imageData.items)" from="home"></Grid>
  <div class="mb-4"></div>
</template>
