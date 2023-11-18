<script setup>
import { ref, reactive } from "vue";
import { useRouter } from "vue-router";

const users = reactive([
  {
    username: "adam",
    password: "adam",
    fname: "Adam",
    lname: "Smith",
    email: "example@mail.com",
    profileImage: "/src/assets/images/user/default-profile-image.png",
    bio: "I am a cat lover.",
    userType: "admin",
  },
  {
    username: "john",
    password: "doe",
    fname: "John",
    lname: "Doe",
    email: "example123@mail.com",
    profileImage: "/src/assets/images/user/default-profile-image.png",
    bio: "I am a cat lover.",
    userType: "user",
  },
  {
    username: "john_wick",
    password: "john",
    fname: "John",
    lname: "Wick",
    email: "ex@mail.com",
    profileImage: "/src/assets/images/user/default-profile-image.png",
    bio: "I am a cat lover.",
    userType: "user",
  },
  {
    username: "andrea",
    password: "andrea",
    fname: "Andrea",
    lname: "Onana",
    email: "exampleonanaygyg@mail.com",
    profileImage: "/src/assets/images/user/default-profile-image.png",
    bio: "I am god.",
    userType: "user",
  },
]);

let usernameForRoute = null;
const router = useRouter();

const editUser = (username) => {
  usernameForRoute = username;
  router.push({
    name: "edit-profile-admin",
    params: { username: usernameForRoute },
  });
};

const deleteUser = (username) => {
  if (confirm(`Are you sure to delete ${username}?`)) {
    usernameForRoute = username;

    // perform delete user
    // ...

    console.log(usernameForRoute + " deleted.");
    usernameForRoute = null;
  }
};
</script>

<template>
  <div class="mt-8 flex flex-col items-center">
    <div class="mb-16">
      <div class="flex justify-center pb-6 text-2xl font-bold">
        <h4>User List</h4>
      </div>
      <div
        class="flex flex-wrap items-center justify-start py-3"
        v-for="user in users"
        :key="user.username"
      >
        <div class="pr-8">
          <img class="w-[70px]" :src="user.profileImage" />
        </div>
        <div class="w-[200px] px-8">{{ user.fname }} {{ user.lname }}</div>
        <div class="flex-grow pl-8 pr-20">{{ user.email }}</div>
        <div class="flex items-center">
          <button
            @click.stop.prevent="editUser(user.username)"
            class="mr-2 rounded-full bg-dark px-6 py-3 text-sm text-white hover:bg-darken"
          >
            Edit
          </button>
          <button
            @click.stop.prevent="deleteUser(user.username)"
            class="ml-2 rounded-full bg-tertiary px-6 py-3 text-sm hover:bg-secondary"
          >
            Delete
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
