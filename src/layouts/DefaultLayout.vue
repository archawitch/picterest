<script setup>
import { onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthenticationStore } from "../stores/authentication";
import { useUserStore } from "../stores/user";
import Navbar from "@/components/Navbar.vue";

const router = useRouter();
const authentication = useAuthenticationStore();
const userStore = useUserStore();

onMounted(() => {});
</script>

<template>
  <div>
    <Navbar />
    <div class="content">
      <router-view></router-view>
    </div>
  </div>
</template>
