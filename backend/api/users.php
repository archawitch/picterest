<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

include_once './config.php';

// Read users
if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $data = json_decode(file_get_contents("php://input"));

    $action = $data->action;

    // check the actions of the request
    if($action == "selectOne"){

        $username = $data->username;

        $selectUserDataQuery = "SELECT username, email, first_name, last_name, bio, profile_image_path
                                    FROM user
                                WHERE username = ?";
                                
        $stmt = $conn->prepare($selectUserDataQuery);

        // Prepared statement is not correct
        if(!$stmt){
            http_response_code(500);
            echo json_encode(array("error" => "Error in prepared statement: " . $conn->error));
            exit();
        }

        // Bind username
        $stmt->bind_param("s", $username);

        // Execute the statement
        if (!$stmt->execute()) {
            http_response_code(500);
            echo json_encode(array("error" => "Error executing statement: " . $stmt->error));
            exit();
        }

        // Bind the result variables
        $stmt->bind_result($username, $email, $first_name, $last_name, $bio, $profile_image_path);

        // Check if user not found
        if ($stmt->fetch()) {
            // Fetch each row and add it to the users array
            http_response_code(200);
            echo json_encode(array(
                "success" => true,
                "message" => "Logged in successfully",
                "userData" => array(
                    "username" => $username,
                    "email" => $email,
                    "firstName" => $first_name,
                    "lastName" => $last_name,
                    "bio" => $bio,
                    "profileImage" => $profile_image_path
                )));
            
        } else {
            echo json_encode(array("success" => false, "message" => "User not found", "username" => $username));
            exit();
        }
    }

    elseif ($action == "selectAll") {

        $selectUserDataQuery = "SELECT username, concat(first_name, ' ', last_name) as fullname, email, profile_image_path 
                                FROM user";

        $selectUserDataResult = $conn->query($selectUserDataQuery);

        if ($selectUserDataResult && $selectUserDataResult->num_rows > 0) {
        
            $users = array();

            // Fetch each row and add it to the users array
            while ($user = $selectUserDataResult->fetch_assoc()) {
                $users[] = array(
                    "username" => $user['username'],
                    "fullname" => $user['fullname'],
                    "email" => $user['email'],
                    "profile_image" => $user['profile_image_path'],
                );
            }

            // Return user data
            echo json_encode(array(
                "success" => true,
                "message" => "Retrieved successfully",
                "user" => $users
            ));
        } else {
            // Not found any users
            echo json_encode(array("success" => false ,"message" => "User not found"));
        }
    }
}

// Update user
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));

    $username = $_POST["username"];
    $password = $_POST["password"];
    $email = $_POST["email"];
    $first_name = $_POST["firstName"];
    $last_name = $_POST["lastName"];
    $bio = $_POST["bio"];
    $profile_image = null;

    // Hash original password
    $hashed_password = !empty($password) ? password_hash($password, PASSWORD_DEFAULT) : null;

    // Check if a file was uploaded
    if (isset($_FILES['profileImage']) && $_FILES['profileImage']['error'] == 0) {
        $uploadDir = '../images/profile_images';
        $uploadFile = $uploadDir . basename($_FILES['profileImage']['name']);

        // Move the uploaded file to the specified directory
        if (move_uploaded_file($_FILES['profileImage']['tmp_name'], $uploadFile)) {
            $profile_image = $uploadFile;
        } else {
            http_response_code(500);
            echo json_encode(array("success" => false, "message" => "Uploaded failed"));
            exit();
        }
    } 
    
    // Declare the update query
    $updateUserDataQuery = "UPDATE user SET";

    // Build the SET clause conditionally
    $updateUserDataQuery .= !empty($hashed_password) ? " password = ?," : "";
    $updateUserDataQuery .= !empty($email) ? " email = ?," : "";
    $updateUserDataQuery .= !empty($first_name) ? " first_name = ?," : "";
    $updateUserDataQuery .= !empty($last_name) ? " last_name = ?," : "";
    $updateUserDataQuery .= !empty($bio) ? " bio = ?," : "";
    $updateUserDataQuery .= !empty($profile_image) ? " profile_image_path = ?," : "";

    // Remove the trailing comma if any
    $updateUserDataQuery = rtrim($updateUserDataQuery, ",");

    // Add the WHERE clause
    $updateUserDataQuery .= " WHERE username = ?";

    // Use a prepared statement
    $stmt = $conn->prepare($updateUserDataQuery);


    // Check if the prepared statement is successful
    if ($stmt) {
        // Bind parameters
        if (!empty($hashed_password) || !empty($email) || !empty($first_name) || !empty($last_name) || !empty($bio) || !empty($profile_image)) {
            $types = "";
            $values = array();

            if (!empty($hashed_password)) {
                $types .= "s";
                $values[] = $hashed_password;
            }
            if (!empty($email)) {
                $types .= "s";
                $values[] = $email;
            }
            if (!empty($first_name)) {
                $types .= "s";
                $values[] = $first_name;
            }
            if (!empty($last_name)) {
                $types .= "s";
                $values[] = $last_name;
            }
            if (!empty($bio)) {
                $types .= "s";
                $values[] = $bio;
            }
            if (!empty($profile_image)) {
                $types .= "s";
                $values[] = $profile_image;
            }

            // Add the WHERE parameter
            $types .= "s";
            $values[] = $username;

            // Bind parameters
            $stmt->bind_param($types, ...$values);
        }

        // Execute the statement
        $stmt->execute();

        // Check for success
        if ($stmt->affected_rows > 0) {
            http_response_code(200);
            echo json_encode(array("success" => true, "message" => "Updated successfully"));
        } else {
            http_response_code(404);
            echo json_encode(array("success" => false, "message" => "No matching username found"));
        }

        // Close the statement
        $stmt->close();
    } else {
        http_response_code(500); // Internal Server Error
        echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
    }               
} 

// Delete user
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;

    // Declare the delete query
    $deleteUserDataQuery = "DELETE FROM user WHERE username = ?";

    // Use a prepared statement
    $stmt = $conn->prepare($deleteUserDataQuery);

    // Check if the prepared statement is successful
    if($stmt){

        $stmt->bind_param("s", $username);

        // Execute the statement
        $stmt->execute();

        // Check for success
        if ($stmt->affected_rows > 0) {
            http_response_code(200); // OK
            echo json_encode(array("success" => true, "message" => "Deleted successfully"));
        } else {
            http_response_code(404); // OK
            echo json_encode(array("success" => false, "message" => "User not found or deletion failed"));
        }
    } else {
        http_response_code(500); // Internal Server Error
        echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
    }
}

// Close the database connection
$conn->close();
?>