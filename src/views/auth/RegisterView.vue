<script setup>
import { reactive, ref, watchEffect, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useAuthenticationStore } from "../../stores/authentication";
import CustomInput from "../../components/CustomInput.vue";

const router = useRouter();
const authentication = useAuthenticationStore();

const formData = reactive({
  username: "",
  password: "",
  confirmPassword: "",
});
const isValid = ref(true);

watchEffect(() => {
  isValid.value = true;

  if (formData.password !== formData.confirmPassword) {
    isValid.value = false;
  }
});

const signupClick = () => {
  // perform sign up logic

  authentication.authenticate();
  router.push({
    name: "home",
  });
};
</script>

<template>
  <div style="padding: 14px; width: 100%; height: 100vh">
    <div class="outer-container background">
      <div class="main-container">
        <div><h2 class="heading">Sign up</h2></div>
        <form @submit.stop.prevent="signupClick">
          <CustomInput
            class="input"
            label-name="Username"
            input-type="text"
            v-model="formData.username"
            :required="true" />
          <CustomInput
            class="input"
            label-name="Password"
            input-type="password"
            v-model="formData.password"
            :required="true" />
          <CustomInput
            class="input"
            label-name="Confirm password"
            input-type="password"
            v-model="formData.confirmPassword"
            :required="true" />
          <button type="submit" class="button">Sign up</button>
        </form>
        <p>
          Already have an account?
          <RouterLink to="/auth/login"><span>Log in</span></RouterLink>
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
  padding: 50px 65px;
  margin: 16px;
  background-color: #ffffff;
  border-radius: 16px;
}
.heading {
  font-size: 28px;
  font-weight: 700;
  margin: 10px 0 12px;
}
.input {
  min-width: 280px;
}
.button {
  font-family: var(--font);
  font-weight: 600;
  margin: 24px 0;
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
