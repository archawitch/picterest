<?php
include_once '../config.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;
    $password = $data->password;

    $selectUserDataQuery = "SELECT username, password, email, first_name, last_name, bio, 
                                        profile_image_path FROM user 
                                        WHERE username = ?";

    $stmt = $conn->prepare($selectUserDataQuery);

    if($stmt){
        // Bind username
        $stmt->bind_param("s", $username);

        // Execute the statement
        $stmt->execute();

        // Bind the result variables
        $stmt->bind_result($username, $hashed_password, $email, $first_name, $last_name, $bio, $profile_image_path);

        // User found
        if($stmt->fetch()){

            // Verify password
            if(password_verify($password, $hashed_password)){
                http_response_code(200);
                echo json_encode(array(
                    "success" => true,
                    "message" => "Logged in successfully",
                    "username" => $username,
                    "email" => $email,
                    "first_name" => $first_name,
                    "last_name" => $last_name,
                    "bio" => $bio,
                    "profile_image" => $profile_image_path
                ));
            } else {
                http_response_code(401);
                echo json_encode(array("success" => false ,"message" => "Logging in failed"));
            }

        } else {
            http_response_code(401);
            echo json_encode(array("success" => false ,"message" => "User not found"));
        }
    } else {
        http_response_code(500);
        echo json_encode(array("error" => "Error in prepared statement: " . $conn->error));
    }
}

// Close the database connection
$conn->close();
?>