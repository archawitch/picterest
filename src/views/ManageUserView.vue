<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useUserStore } from "../stores/user";
import axios from "axios";

const router = useRouter();
const userStore = useUserStore();

const usernameForRoute = ref(null);
const users = ref(null);
const message = ref(null);

onMounted(() => {
  findUsers();
});

const findUsers = async () => {
  await axios
    .get("/api/users.php", {
      params: {
        action: "selectAll",
      },
    })
    .then((response) => {
      if (response.data.success) {
        users.value = response.data.userData;
        console.log(response.data);
      }
    })
    .catch((error) => console.log(error));
};

const editUser = (username) => {
  usernameForRoute.value = username;
  router.push({
    name: "edit-profile-admin",
    params: { username: usernameForRoute.value },
  });
};

const deleteUser = async (username) => {
  // delete admin is forbidden
  if (username === userStore.userData.username) {
    alert("Cannot delete this account.");
    return;
  }

  if (confirm(`Are you sure to delete ${username}?`)) {
    usernameForRoute.value = username;

    // perform delete user
    // ...

    const { data } = await axios.delete("/api/users.php", {
      data: {
        username: userStore.userData.username,
        usernameToDelete: username,
      },
    });

    if (data.success) {
      users.value = users.value.filter(
        (user) => user.username !== usernameForRoute.value,
      );
      message.value =
        "( ˶ˆᗜˆ˵ ) user: [" + usernameForRoute.value + "] deleted.";
    } else {
      message.value = "(╥﹏╥) Failed to delete";
    }
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
          <img
            class="h-[70px] w-[70px] rounded-full object-cover"
            :src="user.profileImage"
          />
        </div>
        <div class="w-[250px] px-8">
          {{ user.fullname }}
        </div>
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
      <div class="mt-4 text-red-500">{{ message }}</div>
    </div>
  </div>
</template>
