<script setup>
import Navbar from "@/components/Navbar.vue";
import { useAuthenticationStore } from "../stores/authentication";
import { onMounted } from "vue";
import { useRouter } from "vue-router";

const router = useRouter();
const authenticationStore = useAuthenticationStore();

onMounted(() => {
  if (!authenticationStore.valid) {
    router.push({ name: "login" });
  }
});
</script>

<template>
  <div class="content h-screen">
    <Navbar />
    <router-view></router-view>
  </div>
</template>
