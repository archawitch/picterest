<script setup>
import Navbar from "@/components/Navbar.vue";
</script>

<template>
  <div>
    <Navbar />
    <div class="content">
      <router-view></router-view>
    </div>
  </div>
</template>
