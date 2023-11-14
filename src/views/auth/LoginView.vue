<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthenticationStore } from "../../stores/authentication";
import CustomInput from "../../components/CustomInput.vue";

const router = useRouter();
const authentication = useAuthenticationStore();

const formData = reactive({
  username: "",
  password: "",
});

const loginClick = () => {
  // Perform login logic here (e.g., make an API request to your PHP backend)
  // If login is successful, you can redirect the user to the home page
  // Replace this with your actual login logic
  authentication.authenticate();
  router.push({ name: "home" });
};
</script>

<template>
  <div>
    <div>
      <img height="80" src="/src/assets/images/picterest-logo.png" alt="" />
    </div>
    <div><h2>Log in to Picterest</h2></div>
    <form @submit.stop.prevent="loginClick">
      <CustomInput
        v-model="formData.username"
        label-name="Username"
        :required="true" />
      <CustomInput
        v-model="formData.password"
        label-name="Password"
        :required="true" />
      <button type="submit">Login</button>
    </form>
    <p>
      No account yet? Click here to
      <RouterLink to="/auth/register"><span>sign up</span></RouterLink>
    </p>
  </div>
</template>
