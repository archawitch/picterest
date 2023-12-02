<script setup>
import { ref, onMounted } from "vue";
import { useRoute } from "vue-router";
import { useUserStore } from "../stores/user";
import CustomInput from "../components/CustomInput.vue";
import CustomTextarea from "../components/CustomTextarea.vue";
import axios from "axios";

const route = useRoute();

const userStore = useUserStore();

const userData = ref({ profileImage: null, password: "" });
const fileInput = ref(null);
const message = ref("");

onMounted(() => {
  findUser(route.params.username);
});

const findUser = async (username) => {
  if (username !== undefined && username !== userStore.userData.username) {
    await axios
      .get("/api/users.php", {
        params: {
          username: username,
          action: "selectOne",
        },
      })
      .then((response) => {
        if (response.data.success) {
          userData.value = {
            password: "",
            ...response.data.userData,
          };
        }
      })
      .catch((error) => console.log(error));
  } else {
    userData.value = { password: "", ...userStore.userData };
  }

  console.log(userData.value);
};

const changeProfileImage = (e) => {
  fileInput.value = e.target.files[0];

  if (fileInput.value && fileInput.value.type.startsWith("image/")) {
    const reader = new FileReader();

    reader.onload = () => {
      userData.value.profileImage = reader.result;
    };

    reader.readAsDataURL(fileInput.value);
  } else {
    // Handle non-image file types or no file selected
    userData.value.profileImage = userStore.userData.profileImage;
    fileInput.value = null;
  }
};

const saveProfile = async () => {
  // perform save profile logic
  // ...
  const formData = new FormData();
  formData.append("profileImage", fileInput.value);
  formData.append("username", userData.value.username);
  formData.append("password", userData.value.password);
  formData.append("email", userData.value.email);
  formData.append("firstName", userData.value.firstName);
  formData.append("lastName", userData.value.lastName);
  formData.append("bio", userData.value.bio);

  const { data } = await axios.post("/api/users.php", formData, {
    headers: {
      "Content-Type": "multipart/form-data",
    },
  });

  if (data.success) {
    if (
      route.params.username === undefined ||
      route.params.username === userStore.userData.username
    ) {
      userStore.userData = await axios
        .get("/api/users.php", {
          params: {
            username: userData.value.username,
            action: "selectOne",
          },
        })
        .then((response) => response.data.userData);
    }

    message.value = "( ˶ˆᗜˆ˵ ) Updated successfully";
  } else {
    message.value = "(╥﹏╥) Failed to update";
  }
};
</script>

<template>
  <div class="mt-8 flex flex-col items-center">
    <div class="w-[500px]">
      <div class="flex justify-center text-2xl font-bold">
        <h4>Edit Profile</h4>
      </div>
      <div class="mt-6 flex items-center justify-center">
        <img
          class="h-[100px] w-[100px] rounded-full object-cover"
          :src="userData.profileImage"
        />
        <label
          class="ml-5 rounded-full bg-tertiary px-5 py-2 text-sm transition hover:cursor-pointer hover:bg-secondary"
        >
          <span class="title">Change</span>
          <input
            class="hidden opacity-0 outline-none"
            type="file"
            accept="image/png, image/jpeg"
            @change="($event) => changeProfileImage($event)"
          />
        </label>
      </div>
      <div class="mt-2 flex w-full">
        <CustomInput
          class="mr-2 w-full"
          v-model="userData.firstName"
          label-name="First name"
          input-type="text"
          :required="true"
        ></CustomInput>
        <CustomInput
          class="ml-2 w-full"
          v-model="userData.lastName"
          label-name="Last name"
          input-type="text"
          :required="true"
        ></CustomInput>
      </div>
      <div class="mt-4">
        <CustomTextarea
          v-model="userData.bio"
          label-name="Description"
          rows="2"
          :required="true"
        ></CustomTextarea>
      </div>
      <div class="mt-4">
        <CustomInput
          v-model="userData.email"
          label-name="Email"
          input-type="text"
          :required="true"
        ></CustomInput>
      </div>
      <div class="mt-4">
        <CustomInput
          v-model="userData.password"
          label-name="Password"
          input-type="password"
          :required="true"
        ></CustomInput>
      </div>
      <div class="mb-20 mt-6 flex items-center">
        <div class="mr-auto text-red-500">{{ message }}</div>
        <button
          @click.stop="saveProfile"
          class="rounded-full bg-tertiary px-6 py-3 transition hover:bg-secondary"
        >
          Save
        </button>
      </div>
    </div>
  </div>
</template>
