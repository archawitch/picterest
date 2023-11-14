import { createRouter, createWebHistory } from "vue-router";
import App from "../App.vue";
import HomeView from "../views/HomeView.vue";
import LoginView from "../views/auth/LoginView.vue";
import DefaultLayout from "../layouts/DefaultLayout.vue";
import AuthLayout from "../layouts/AuthLayout.vue";
import RegisterView from "../views/auth/RegisterView.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: "/",
      component: DefaultLayout, // Use DefaultLayout for main pages
      children: [
        {
          path: "Home",
          name: "home",
          component: HomeView,
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
