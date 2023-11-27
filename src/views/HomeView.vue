<script setup>
//import imageData from "../assets/json/dummy-images.json";
import { ref, watch, onMounted, onUnmounted } from "vue";
import { useNavbarStore } from "../stores/navbar";
import { useUserStore } from "../stores/user";
import { useRoute } from "vue-router";
import Grid from "../components/Grid.vue";
import axios from "axios";
import arrayShuffle from "array-shuffle";

const route = useRoute();
const navbarStore = useNavbarStore();
const userStore = useUserStore();

const imageData = ref([]);

onMounted(() => {
  navbarStore.addCreateActive();
  sendAPI(route.query.q ?? "");
});

onUnmounted(() => {
  navbarStore.removeCreateActive();
});

const sendAPI = async (query) => {
  axios
    .get("/api/search.php", {
      params: { query: query, username: userStore.userData.username },
    })
    .then((response) => {
      imageData.value = response.data.pinData;
    })
    .catch((error) => console.log(error));
};

// when input changes, retrieves data from the backend
watch(
  () => route.query.q,
  () => {
    sendAPI(route.query.q ?? "");
  },
);
</script>

<template>
  <Grid
    v-if="imageData"
    :pin-items="arrayShuffle(imageData)"
    from="home"
  ></Grid>
  <div class="mb-4"></div>
</template>
