<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthenticationStore } from "@/stores/authentication";
import { useUserStore } from "@/stores/user";
import CustomInput from "@/components/CustomInput.vue";
import axios from "axios";

const router = useRouter();
const authentication = useAuthenticationStore();
const userStore = useUserStore();

const isLoading = ref(false);
const message = reactive({ error: "", success: "" });
const formData = reactive({
  username: "",
  password: "",
  confirmPassword: "",
});

const sendRegisterRequest = async () => {
  // simulate loading screen
  await new Promise((resolve) =>
    setTimeout(() => {
      resolve();
    }, 1000),
  );

  // send user data || registration
  return await axios
    .post("/api/auth/register.php", {
      username: formData.username,
      password: formData.password,
      userType: "user",
    })
    .catch((error) => {
      isLoading.value = false;
      message.error = "* No connection";
    });
};

const signupClick = async () => {
  // check if passwords are the same
  message.error = "";
  if (formData.password !== formData.confirmPassword) {
    message.error = "* Passwords do not match.";
    return;
  }

  // turn on loading
  isLoading.value = true;

  // start fetching api
  const { data } = await sendRegisterRequest();

  // repeated user
  if (!data.success) {
    isLoading.value = false;
    message.error = "* Duplicate username";
    return;
  }

  // store user data
  userStore.addUser(data.userData);

  // authenticated
  authentication.authenticate();

  // response to the user
  message.success = "Welcome to Picterest";

  // let message displaying
  await new Promise((resolve) => {
    setTimeout(() => {
      resolve();
    }, 500);
  });

  router.push({
    name: "home",
  });
};
</script>

<template>
  <div style="padding: 14px; width: 100%; height: 100vh">
    <div
      class="flex h-full w-full items-center justify-center bg-cover p-4"
      style="background-image: url(/src/assets/images/auth-background.png)"
    >
      <div
        class="m-4 flex flex-col items-center rounded-2xl bg-white px-14 py-12"
      >
        <div><h2 class="mb-3 mt-2.5 text-3xl font-bold">Sign up</h2></div>
        <form class="w-full" @submit.stop.prevent="signupClick">
          <CustomInput
            style="min-width: 280px"
            label-name="Username"
            input-type="text"
            v-model="formData.username"
            :required="true"
          />
          <CustomInput
            style="min-width: 280px"
            label-name="Password"
            input-type="password"
            v-model="formData.password"
            :required="true"
          />
          <CustomInput
            style="min-width: 280px"
            class="mb-3"
            label-name="Confirm password"
            input-type="password"
            v-model="formData.confirmPassword"
            :required="true"
          />
          <div class="text-red-500" v-if="message.error">
            {{ message.error }}
          </div>
          <div class="flex items-center justify-center" v-if="message.success">
            {{ message.success }}&nbsp;<font-awesome-icon
              :icon="['fas', 'face-smile']"
            />
          </div>
          <button
            type="submit"
            class="mb-8 mt-3 h-[48px] w-full rounded-full bg-dark p-3 text-white transition duration-200 hover:cursor-pointer hover:bg-darken active:bg-black disabled:bg-dark"
            :disabled="isLoading"
          >
            <div class="loading" v-if="isLoading">
              <div v-for="i in [1, 2, 3]"></div>
            </div>
            <div class="font-semibold" v-if="!isLoading">Sign up</div>
          </button>
        </form>
        <p>
          Already have an account?
          <RouterLink to="/auth/login"
            ><span class="text-black underline">Log in</span></RouterLink
          >
        </p>
      </div>
    </div>
  </div>
</template>
