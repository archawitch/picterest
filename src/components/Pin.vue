<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { usePinStore } from "../stores/pin";
import { useNavbarStore } from "../stores/navbar";

const router = useRouter();
const pinStore = usePinStore();
const navbarStore = useNavbarStore();

const props = defineProps({
  pinData: Object,
  from: String,
});

const showPinDetail = ref(false);
const isSaved = ref(false);

const savePin = () => {
  // Perform save pin logic
  if (!isSaved.value) {
    isSaved.value = true;
    // save data to the database
    // ...
  } else if (isSaved) {
    isSaved.value = false;
    // remove data from the database
    // ...
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
    params: { id: props.pinData.id },
  });
};
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
        @click.stop="savePin()"
        v-if="from === 'home'"
        class="absolute right-4 top-4 z-10 rounded-full bg-dark px-5 py-3 text-white transition hover:bg-darken"
        :class="{
          hidden: !showPinDetail,
          block: showPinDetail,
          'bg-dark': !isSaved,
          'hover:bg-darken': !isSaved,
          'bg-darken': isSaved,
        }"
      >
        {{ !isSaved ? "Save" : "Saved!" }}
      </button>
      <a
        v-if="
          pinData.url !== undefined && pinData.url !== null && from === 'home'
        "
        @click.stop=""
        class="absolute bottom-4 left-4 z-10 text-4xl"
        :class="{
          hidden: !showPinDetail,
          block: showPinDetail,
        }"
        :href="pinData.url"
        target="_blank"
        ><font-awesome-icon
          class="text-gray-400 transition hover:brightness-[75%] hover:duration-300"
          :icon="['fas', 'square-arrow-up-right']"
      /></a>
      <img class="w-full rounded-2xl" :src="pinData.image" alt="" />
    </button>
  </div>
</template>
