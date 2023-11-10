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
      component: DefaultLayout, // Use DefaultLayout for home and about pages
      children: [
        {
          path: "",
          name: "Home",
          component: HomeView,
        },
      ],
    },
    {
      path: "/auth",
      component: AuthLayout, // Use AuthLayout for login and register pages
      children: [
        {
          path: "login",
          name: "Login",
          component: LoginView,
        },
        {
          path: "register",
          name: "Register",
          component: RegisterView,
        },
      ],
    },
  ],
});

export default router;
