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
const message = reactive({});
const formData = reactive({
  username: "",
  password: "",
});

const sendLoginRequest = async () => {
  // simulate loading screen
  await new Promise((resolve) =>
    setTimeout(() => {
      resolve();
    }, 1000),
  );
  // fetch user data
  return await axios.post("/api/auth/login.php", {
    username: formData.username,
    password: formData.password,
  });
};

const loginClick = async () => {
  // turn on loading
  isLoading.value = true;

  // start fetching api
  const { data } = await sendLoginRequest();

  // store user data
  userStore.addUser(data.userData);

  // user not found
  if (!data.success) {
    isLoading.value = false;
    message.error = "* Username or password is not correct.";
    return;
  }

  // authenticate user
  authentication.authenticate();

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
        <div>
          <img
            class="w-14"
            src="/src/assets/images/picterest-logo.png"
            alt=""
          />
        </div>
        <div>
          <h2 class="mb-3 mt-2.5 text-2xl font-bold">Log in to Picterest</h2>
        </div>
        <form class="w-full" @submit.stop.prevent="loginClick">
          <CustomInput
            style="min-width: 280px"
            v-model="formData.username"
            label-name="Username"
            input-type="text"
            :required="true"
          />
          <CustomInput
            style="min-width: 280px"
            class="mb-3"
            v-model="formData.password"
            label-name="Password"
            input-type="password"
            :required="true"
          />
          <div class="text-red-500" v-if="message.error">
            {{ message.error }}
          </div>
          <button
            type="submit"
            class="duration-00 mb-8 mt-3 h-[48px] w-full rounded-full bg-dark p-3 text-white transition hover:cursor-pointer hover:bg-darken active:bg-black disabled:bg-dark"
            :disabled="isLoading"
          >
            <div class="loading" v-if="isLoading">
              <div v-for="i in [1, 2, 3]"></div>
            </div>
            <div class="font-semibold" v-if="!isLoading">Log in</div>
          </button>
        </form>
        <p>
          No account yet? Click here to
          <RouterLink to="/auth/register"
            ><span class="text-black underline">sign up</span></RouterLink
          >
        </p>
      </div>
    </div>
  </div>
</template>
