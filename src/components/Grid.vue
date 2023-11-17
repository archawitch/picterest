<script setup>
import MasonryWall from "@yeger/vue-masonry-wall";
import Pin from "./Pin.vue";

const props = defineProps({
  pinItems: Array,
  from: String,
});
</script>

<template>
  <div class="px-4">
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
</template>
