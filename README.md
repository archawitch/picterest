# Picterest

Picterest is a web application that allows users to discover, create, and save images, fostering creativity and inspiration. It is inspired by the popular application Pinterest, but with only basic functionality.

## Tech Stack

- Vue.js
- PHP
- MySQL
- Tailwind CSS

## Prerequisites

- Node.js
- MAMP

## Installation

1. Open a terminal and clone this repository into the htdocs folder under your MAMP directory.

   ```
   # Clone the repository to the htdocs folder
   cd path/to/MAMP/htdocs
   git clone https://github.com/archawitch/picterest.git

   # Install required dependencies
   cd picterest
   npm install
   ```

2. Open MAMP and set the Apache port to 80. Alternatively, if you prefer to use another port, you will need to update the configuration in [vite.config.js](vite.config.js) with your desired port.
3. Open your browser and navigate to [phpMyAdmin](http://localhost/phpMyAdmin5/). (if you don't set the Apache port to 80, you will need to append ":your_port_no" to the end of "localhost")
4. Import a SQL script from [picterest.sql](backend/picterest.sql) to create a database for the app.

## Usage

1. Open MAMP and click "Start Servers".
2. Open a terminal in your project directory and run `npm run dev`.
3. Then, you can log in to the app using the username and password "brother", or sign up for a new user account.

## Screenshots

#### Login/Register page

<img src="https://github.com/archawitch/Picterest/assets/106484702/b02f981c-43f2-4851-96b5-a25df0761ac1">
<img src="https://github.com/archawitch/Picterest/assets/106484702/a9d8327c-67c8-45c6-a4cd-a929d1ee5478">

#### Home page

<img src="https://github.com/archawitch/Picterest/assets/106484702/281bc001-fb2f-4e2c-befb-d83153313c84">

#### Pin page

<img src="https://github.com/archawitch/Picterest/assets/106484702/bc4a19b5-ccd1-445e-9844-cafbec356be4">

#### Board page

<img src="https://github.com/archawitch/Picterest/assets/106484702/c2a23aff-db91-48ff-975c-6c724d419026">

#### Create pin/Create board page

<img src="https://github.com/archawitch/Picterest/assets/106484702/644113e4-5250-496f-acfe-9a657921a38d">
<img src="https://github.com/archawitch/Picterest/assets/106484702/b2d949ee-6a7b-4f7d-8dc0-5eca5fbd3f11">

#### Profile page

<img src="https://github.com/archawitch/Picterest/assets/106484702/c81073bc-1b14-477c-bdfb-374cef6f4694">
<img src="https://github.com/archawitch/Picterest/assets/106484702/17578698-8508-430f-a961-ff06d66ef739">

#### Edit profile page

<img src="https://github.com/archawitch/Picterest/assets/106484702/8adff753-f242-4d78-ad12-67a1357f396e">

#### Manage user page (for admin)

<img src="https://github.com/archawitch/Picterest/assets/106484702/fcb274cb-6b34-4755-9c35-3ebc8437b981">

## Contributors

- [Archawit Changtor](https://github.com/archawitch)
- [Wisarakorn Boonpathomrojkul](https://github.com/nine749)
