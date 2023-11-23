import "./style.css";
import "./assets/css/main.css";

import { createApp } from "vue";
import { createPinia } from "pinia";
import piniaPluginPersistedstate from "pinia-plugin-persistedstate";
import App from "./App.vue";
import router from "./router";
import axios from "axios";

if (import.meta.env.DEV) {
  axios.defaults.baseURL = "http://localhost/picterest/backend/";
}

// Masonry Layouts
import MasonryWall from "@yeger/vue-masonry-wall";

// FontAwesome
import { library } from "@fortawesome/fontawesome-svg-core";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";
import { fas } from "@fortawesome/free-solid-svg-icons";
import { far } from "@fortawesome/free-regular-svg-icons";
import { fab } from "@fortawesome/free-brands-svg-icons";

library.add(fas, far, fab);

const app = createApp(App);
const pinia = createPinia();

pinia.use(piniaPluginPersistedstate);
app.use(router);
app.use(pinia);
app.use(MasonryWall);

app.component("font-awesome-icon", FontAwesomeIcon).mount("#app");
