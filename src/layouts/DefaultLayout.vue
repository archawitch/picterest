<script setup>
import { useRouter } from "vue-router";
import Navbar from "@/components/Navbar.vue";

const router = useRouter();
</script>

<template>
  <div>
    <Navbar />
    <div class="content">
      <router-view></router-view>
    </div>
  </div>
</template>
