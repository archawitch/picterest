<template>
  <div class="grid">
    <div v-for="item in props.pinData" :key="props.pinData.id" class="item">
      <div class="content">
        <img class="pin" :src="item.image" />
      </div>
    </div>
  </div>
</template>

<!-- GridComponent.vue -->
<script setup>
import { onMounted, defineProps } from "vue";

const props = defineProps({
  pinData: Array,
});

function resizeGridItem(item) {
  const grid = document.getElementsByClassName("grid")[0];
  const rowHeight = parseInt(
    window.getComputedStyle(grid).getPropertyValue("grid-auto-rows")
  );
  const rowGap = parseInt(
    window.getComputedStyle(grid).getPropertyValue("grid-row-gap")
  );
  const rowSpan = Math.ceil(
    (item.querySelector(".content").getBoundingClientRect().height + rowGap) /
      (rowHeight + rowGap)
  );
  item.style.gridRowEnd = "span " + rowSpan;
}

function resizeAllGridItems() {
  const allItems = document.getElementsByClassName("item");
  for (var x = 0; x < allItems.length; x++) {
    resizeGridItem(allItems[x]);
  }
}

function resizeInstance(item) {
  resizeGridItem(item);
}

onMounted(() => {
  const allItems = document.getElementsByClassName("item");
  for (var x = 0; x < allItems.length; x++) {
    resizeInstance(allItems[x]);
  }
});
</script>

<style scoped>
.grid {
  display: grid;
  grid-gap: 10px;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  grid-auto-rows: 20px;
}
.item {
  background-color: #ffffff;
}
.content {
}
.pin {
  width: 100%;
}
</style>
