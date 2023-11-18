import { createRouter, createWebHistory } from "vue-router";
import AuthLayout from "../layouts/AuthLayout.vue";
import DefaultLayout from "../layouts/DefaultLayout.vue";
import {
  LoginView,
  RegisterView,
  HomeView,
  PinView,
  BoardView,
  CreatePinView,
  CreateBoardView,
  EditProfileView,
  ManageUserView,
  ProfileView,
} from "../views";

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
          path: "/board/:id",
          name: "board",
          component: BoardView,
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
        {
          path: "/edit-profile/:username",
          name: "edit-profile-admin",
          component: EditProfileView,
        },
        {
          path: "/manage-user",
          name: "manage-user",
          component: ManageUserView,
        },
        {
          path: "/profile",
          name: "profile",
          component: ProfileView,
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
