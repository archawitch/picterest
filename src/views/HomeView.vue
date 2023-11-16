<script setup>
import imageData from "../assets/json/dummy-images.json";
import arrayShuffle from "array-shuffle";
import GridComponent from "../components/GridComponent.vue";
</script>

<template>
  <GridComponent
    :pin-items="arrayShuffle(imageData.items)"
    from="home"
  ></GridComponent>
  <div class="mb-4"></div>
</template>
