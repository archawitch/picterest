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
  <div>
    <div><h2>Sign up</h2></div>
    <form @submit.stop.prevent="signupClick">
      <CustomInput
        label-name="Username"
        v-model="formData.username"
        :required="true" />
      <CustomInput
        label-name="Password"
        v-model="formData.password"
        :required="true" />
      <CustomInput
        label-name="Confirm password"
        v-model="formData.confirmPassword"
        :required="true" />
      <button type="submit">Sign up</button>
    </form>
    <p>
      Already have an account?
      <RouterLink to="/auth/login"><span>Log in</span></RouterLink>
    </p>
  </div>
</template>
