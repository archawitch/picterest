<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import CustomInput from "../../components/CustomInput.vue";

const usernameText = ref("");
const passwordText = ref("");

const router = useRouter();

const login = () => {
  // Perform login logic here (e.g., make an API request to your PHP backend)
  // If login is successful, you can redirect the user to the home page
  // Replace this with your actual login logic
  // Access the global router instance from app.js
  alert(usernameText.value);
  //router.push("/");
};
</script>

<template>
  <div>
    <div>
      <img height="80" src="/src/assets/images/picterest-logo.png" alt="" />
    </div>
    <div><h2>Log in to Picterest</h2></div>
    <form @submit.stop.prevent="login">
      <CustomInput
        v-model="usernameText"
        label-name="Username"
        place-holder-text="username"
        :is-required="true" />
      <CustomInput
        v-model="passwordText"
        label-name="Password"
        place-holder-text="password"
        :is-required="true" />
      <button type="submit">Login</button>
    </form>
    <p>
      No account yet? Click here to
      <RouterLink to="/auth/register"><span>sign up</span></RouterLink>
    </p>
  </div>
</template>
