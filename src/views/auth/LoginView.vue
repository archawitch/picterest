<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthenticationStore } from "../../stores/authentication";
import CustomInput from "../../components/CustomInput.vue";
import GridComponent from "../../components/GridComponent.vue";

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
  <div style="padding: 14px; width: 100%; height: 100vh">
    <div class="outer-container background">
      <div class="main-container">
        <div>
          <img height="50" src="/src/assets/images/picterest-logo.png" alt="" />
        </div>
        <div><h2 class="heading">Log in to Picterest</h2></div>
        <form @submit.stop.prevent="loginClick">
          <CustomInput
            v-model="formData.username"
            label-name="Username"
            :required="true" />
          <CustomInput
            v-model="formData.password"
            label-name="Password"
            :required="true" />
          <button type="submit" class="button">Login</button>
        </form>
        <p>
          No account yet? Click here to
          <RouterLink to="/auth/register"><span>sign up</span></RouterLink>
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
form {
  width: 100%;
}
a {
  color: black;
}
.background {
  background-image: url("/src/assets/images/login-background.png");
  background-size: cover;
  max-width: 100%;
}
.outer-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 16px;
  width: 100%;
  height: 100%;
}
.main-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 50px 60px;
  margin: 16px;
  background-color: #ffffff;
  border-radius: 16px;
}
.heading {
  font-weight: 700;
  margin: 10px 0 12px;
}
.button {
  font-family: var(--font);
  font-weight: 600;
  margin: 24px 0 32px;
  padding: 12px;
  width: 100%;
  background-color: var(--bg-black);
  color: white;
  border-radius: 20px;
  transition: background-color 0.3s;
}
.button:hover {
  cursor: pointer;
  background-color: #2a2a2a;
}
.button:active {
  background-color: black;
}
</style>
