<script setup>
import { useNavbarStore } from "../stores/navbar";

const navbarStore = useNavbarStore();
</script>

<template>
  <nav>
    <router-link to="/">
      <button></button>
      <button
        class="button"
        :class="{ active: navbarStore.isHomePage }"
        :disabled="navbarStore.isHomePage">
        Home
      </button>
    </router-link>
    <router-link to="/auth/login">Login</router-link>
  </nav>
</template>

<style scoped>
.active {
  background-color: var(--bg-black);
  color: white;
}
</style>
