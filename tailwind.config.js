/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        "black-0": "#black",
        "black-1": "#333333",
        "black-2": "#555555",
        "black-3": "#757575",
      },
      backgroundColor: {
        dark: "#313131",
        darken: "#2a2a2a",
        secondary: "#ebebeb",
        tertiary: "#efefef",
      },
    },
  },
  plugins: [],
};
