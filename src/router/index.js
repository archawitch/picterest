import { createRouter, createWebHistory } from "vue-router";
import DefaultLayout from "../layouts/DefaultLayout.vue";
import AuthLayout from "../layouts/AuthLayout.vue";
import LoginView from "../views/auth/LoginView.vue";
import RegisterView from "../views/auth/RegisterView.vue";
import HomeView from "../views/HomeView.vue";
import PinView from "../views/PinView.vue";
import CreatePinView from "../views/CreatePinView.vue";
import CreateBoardView from "../views/CreateBoardView.vue";
import EditProfileView from "../views/EditProfileView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      component: DefaultLayout, // Use DefaultLayout for main pages
      children: [
        {
          path: "/home",
          name: "home",
          component: HomeView,
        },
        {
          path: "/pin/:id",
          name: "pin",
          component: PinView,
        },
        {
          path: "/create-pin",
          name: "create-pin",
          component: CreatePinView,
        },
        {
          path: "/create-board",
          name: "create-board",
          component: CreateBoardView,
        },
        {
          path: "/edit-profile",
          name: "edit-profile",
          component: EditProfileView,
        },
      ],
      redirect: "/auth/login",
    },
    {
      path: "/auth",
      component: AuthLayout, // Use AuthLayout for auth pages
      children: [
        {
          path: "login",
          name: "login",
          component: LoginView,
        },
        {
          path: "register",
          name: "register",
          component: RegisterView,
        },
      ],
    },
  ],
});

export default router;
