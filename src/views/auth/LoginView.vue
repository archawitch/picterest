<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { useAuthenticationStore } from "@/stores/authentication";
import { useUserStore } from "@/stores/user";
import CustomInput from "@/components/CustomInput.vue";

const router = useRouter();
const authentication = useAuthenticationStore();
const userStore = useUserStore();

const isLoading = ref(false);
const formData = reactive({
  username: "",
  password: "",
});
const userData = ref({});

const fetchAPI = async () => {
  return {
    username: "adam",
    password: "adam",
    fname: "Adam",
    lname: "Smith",
    email: "example@mail.com",
    profileImage: "/src/assets/images/dummy-images/Google.jpg",
    bio: "I am a cat lover.",
    ok: true,
    status: 200,
    userType: "admin",
  };
};

const sendAPIRequest = async () => {
  try {
    await new Promise((resolve) => setTimeout(resolve, 1000));

    // fetching api
    const response = await fetchAPI();

    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }

    return response;
  } catch {
    throw new Error(`Error fetching data: ${error.message}`);
  }
};

const loginClick = async () => {
  // perform sign up logic
  // turn on loading
  isLoading.value = true;

  // start fetching api
  userData.value = await sendAPIRequest();

  // store user data
  userStore.addUser(userData.value);

  // authenticated
  authentication.authenticate(userData.value);
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
        class="m-4 flex flex-col items-center rounded-2xl bg-white px-16 py-12"
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
            v-model="formData.password"
            label-name="Password"
            input-type="password"
            :required="true"
          />
          <button
            type="submit"
            class="duration-00 mb-8 mt-6 h-[48px] w-full rounded-full bg-dark p-3 text-white transition hover:cursor-pointer hover:bg-darken active:bg-black disabled:bg-dark"
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
