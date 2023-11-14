<script setup>
import { onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthenticationStore } from "../stores/authentication";
import Navbar from "@/components/Navbar.vue";

const router = useRouter();
const authentication = useAuthenticationStore();

onMounted(() => {
  // check if user is authenticated or not
  if (!authentication.valid) {
    router.push({
      name: "login",
    });
  }
});
</script>

<template>
  <div>
    <Navbar />
    <div class="content">
      <router-view></router-view>
    </div>
  </div>
</template>
