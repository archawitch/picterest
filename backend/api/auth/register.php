<?php

include_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;
    $password = $data->password;

    // Hash the password (replace this with your actual password hashing logic)
    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    $insertUserDataQuery = "INSERT INTO user (username, password) VALUES (?, ?)";

    $stmt = $conn->prepare($insertUserDataQuery);

    if($stmt){
        // Bind username
        $stmt->bind_param("ss", $username, $hashed_password);

        // Execute the statement
        $stmt->execute();
        if($stmt->affected_rows > 0){
            // Response back
            http_response_code(200);
            echo json_encode(array(
                "success" => true,
                "message" => "Logged in successfully",
                "username" => $username,
                "email" => null,
                "first_name" => null,
                "last_name" => null,
                "bio" => null,
                "profile_image" => null
            ));
        } else {
            http_response_code(500);
            echo json_encode(array("success" => false ,"message" => "User found or inserted failed", ));
        } 
    } else {
        http_response_code(500);
        echo json_encode(array("error" => "Error in prepared statement: " . $conn->error));
    }
}
// Close the database connection
$conn->close();
?>