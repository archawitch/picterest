<?php

include_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;
    $password = $data->password;

    $insertUserDataQuery = "INSERT INTO user (username, password) VALUES ('$username', '$password')";
    $insertUserDataResult = $conn->query($insertUserDataQuery);

    if ($insertUserDataResult) {
      // Authentication successful
        $selectUserDataQuery = "SELECT * FROM user WHERE username = '$username' AND password = '$password'" ;
        $selectUserDataResult = $conn->query($selectUserDataQuery);

        $user = $selectUserDataResult->fetch_assoc();
        
        // Return user data
        echo json_encode(array(
            "success" => true,
            "message" => "Registration successful",
            "user" => array(
                "username" => $user['username'],
                "password" => $user['password'],
                "email" => $user['email'],
                "first_name" => $user['first_name'],
                "last_name" => $user['last_name'],
                "profile_image" => $user['profile_image'],
                "bio" => $user['bio'],
            )
        ));
    } else {
        http_response_code(400);
        echo json_encode(array("success" => false ,"message" => "Registration failed"));
    }
}
?>