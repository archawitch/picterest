<script setup>
import { ref, computed } from "vue";
import { useRouter } from "vue-router";
import { usePinStore } from "../stores/pin";
import { useUserStore } from "../stores/user";
import { useNavbarStore } from "../stores/navbar";
import axios from "axios";

const router = useRouter();
const pinStore = usePinStore();
const userStore = useUserStore();
const navbarStore = useNavbarStore();

const props = defineProps({
  pinData: Object,
  from: String,
});

const showPinDetail = ref(false);
const isSaved = ref(false);

const savePin = async () => {
  // Perform save pin logic
  if (!isSaved.value) {
    // save data to the database
    const formDataForInsert = new FormData();
    formDataForInsert.append("pinId", props.pinData.pinId);
    formDataForInsert.append("username", userStore.userData.username);
    const { data } = await axios.post("/api/save.php", formDataForInsert);

    if (!data.success) {
      console.log(data);
      alert("(╥﹏╥) Failed to save");
    }

    isSaved.value = true;
  } else if (isSaved.value) {
    // remove data from the database
    const { data } = await axios.delete("/api/save.php", {
      data: {
        username: userStore.userData.username,
        pinId: props.pinData.pinId,
      },
    });

    if (!data.success) {
      console.log(data);
      alert("(╥﹏╥) Failed to save");
    }

    isSaved.value = false;
  }
};

const goToPin = () => {
  // store pin data
  pinStore.readPin(props.pinData);
  // reset navbar modals
  navbarStore.resetModal();
  // redirect to pin page
  router.push({
    name: "pin",
    params: { id: props.pinData.pinId },
  });
};

const computedUrl = computed(() => {
  if (props.pinData.pinUrl !== undefined && props.pinData.pinUrl !== null) {
    let url = props.pinData.pinUrl;
    if (url.includes("http")) {
      const firstIndex = url.split("/", 2).join("/").length;
      return `${url.slice(firstIndex + 1, url.length)}`;
    } else {
      return url;
    }
  }

  return "";
});
</script>

<template>
  <div class="card flex items-center justify-center">
    <button
      class="relative w-full transition hover:brightness-90"
      @mouseover="showPinDetail = true"
      @mouseleave="showPinDetail = false"
      @click="goToPin()"
    >
      <button
        v-if="from === 'home'"
        @click.stop="savePin()"
        class="absolute right-4 top-4 z-10 rounded-full bg-dark px-5 py-3 transition hover:bg-darken"
        :class="{
          'bg-transparent': !showPinDetail,
          'text-transparent': !showPinDetail,
          'bg-dark': showPinDetail && !isSaved,
          'hover:bg-darken': showPinDetail && !isSaved,
          'bg-darken': showPinDetail && isSaved,
          'text-white': showPinDetail,
        }"
      >
        {{ !isSaved ? "Save" : "Saved!" }}
      </button>
      <a
        @click.stop=""
        class="absolute bottom-4 left-4 z-10 text-4xl"
        :class="{
          'text-transparent': !showPinDetail,
          'text-gray-400': showPinDetail,
        }"
        v-if="pinData.pinUrl"
        :href="'https://' + computedUrl"
        target="_blank"
        ><font-awesome-icon
          class="transition hover:brightness-[75%] hover:duration-300"
          :icon="['fas', 'square-arrow-up-right']"
      /></a>
      <img class="w-full rounded-2xl" :src="pinData.pinImage" alt="" />
    </button>
  </div>
</template>
