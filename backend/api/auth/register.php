<?php

include_once '../config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try{
        $data = json_decode(file_get_contents("php://input"));
        $username = $data->username;
        $password = $data->password;
        $user_type = "user";
        $profile_image = "/backend/images/profile_images/default-profile-image.png";

        // Hash the password (replace this with your actual password hashing logic)
        $hashed_password = password_hash($password, PASSWORD_DEFAULT);

        $insertUserDataQuery = "INSERT INTO user (username, password, user_type, profile_image_path) VALUES (?, ?, ?, ?)";

        $stmt = $conn->prepare($insertUserDataQuery);

        if($stmt){
            // Bind username
            $stmt->bind_param("ssss", $username, $hashed_password, $user_type, $profile_image);

            // Execute the statement
            $stmt->execute();
            if($stmt->affected_rows > 0){
                // Response back
                http_response_code(200);
                echo json_encode(array(
                    "success" => true,
                    "message" => "Registered successfully",
                    "userData" => array(
                        "username" => $username,
                        "userType" => $user_type,
                        "email" => null,
                        "firstName" => null,
                        "lastName" => null,
                        "bio" => null,
                        "profileImage" => $profile_image
                    )
                ));
            } else {
                echo json_encode(array("success" => false ,"message" => "User found or inserted failed"));
            } 
        } else {
            http_response_code(500);
            echo json_encode(array("error" => "Error in prepared statement: " . $conn->error));
        } 
    } catch (Exception $e) {
        echo json_encode($conn->connect_error);
    }
}
// Close the database connection
$conn->close();
?>