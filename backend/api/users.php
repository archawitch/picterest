<?php
include_once './config.php';

// Read all users
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;

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

// Update user
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents("php://input"));

    $username = $data->username;
    $password = $data->password;
    $email = $data->email;
    $first_name = $data->first_name;
    $last_name = $data->last_name;
    $bio = $data->bio;
    $profile_image = null;

    // Hash original password
    $hashed_password = !empty($password) ? password_hash($password, PASSWORD_DEFAULT) : null;

    // Check if a file was uploaded
    if (isset($_FILES['profile_image']) && $_FILES['profile_image']['error'] == 0) {
        $uploadDir = '../images/profile_images';
        $uploadFile = $uploadDir . basename($_FILES['profile_image']['name']);

        // Move the uploaded file to the specified directory
        if (move_uploaded_file($_FILES['profile_image']['tmp_name'], $uploadFile)) {
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