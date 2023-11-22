<?php
include_once './config.php';

// Read all users
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;

    $selectUserDataQuery = "SELECT username, concat(first_name, ' ', last_name) as fullname, email, profile_image FROM user";
    $selectUserDataResult = $conn->query($selectUserDataQuery);

    if ($selectUserDataResult && $selectUserDataResult->num_rows > 0) {
      
        $users = array();

        // Fetch each row and add it to the users array
        while ($user = $selectUserDataResult->fetch_assoc()) {
            $users[] = array(
                "username" => $user['username'],
                "fullname" => $user['fullname'],
                "email" => $user['email'],
                "profile_image" => $user['profile_image'],
            );
        }

        // Return user data
        echo json_encode(array(
            "success" => true,
            "message" => "Logging in successful",
            "user" => $users
        ));
    } else {
        // Not found any users
        echo json_encode(array("success" => true ,"message" => "No users"));
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
    $profile_image = $data->profile_image;

    $updateUserDataQuery = "UPDATE user SET";

    // Build the SET clause conditionally
    $updateUserDataQuery .= !empty($password) ? " password = '$password'," : "";
    $updateUserDataQuery .= !empty($email) ? " email = '$email'," : "";
    $updateUserDataQuery .= !empty($first_name) ? " first_name = '$first_name'," : "";
    $updateUserDataQuery .= !empty($last_name) ? " last_name = '$last_name'," : "";
    $updateUserDataQuery .= !empty($bio) ? " bio = '$bio'," : "";
    $updateUserDataQuery .= !empty($profile_image) ? " profile_image = '$profile_image'," : "";

    // Remove the trailing comma if any
    $updateUserDataQuery = rtrim($updateUserDataQuery, ",");

    // Add the WHERE clause
    $updateUserDataQuery .= " WHERE username = '$username'";

    $updateUserDataResult = $conn->query($updateUserDataQuery);

    if ($updateUserDataResult) {
        // Return a response
        echo json_encode(array(
            "success" => true,
            "message" => "Updated successfully"
        ));
    } else {
        http_response_code(401);
        echo json_encode(array("success" => false ,"message" => "Updated failed"));
    }
}

// Delete user
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"));
    $username = $data->username;

    $deleteUserDataQuery = "DELETE FROM user WHERE username = '$username'";
    $deleteUserDataResult = $conn->query($deleteUserDataQuery);

    if ($deleteUserDataResult) {
        // Return a response
        echo json_encode(array(
            "success" => true,
            "message" => "Deleted successfully",
            "user" => $users
        ));
    } else {
        http_response_code(401);
        echo json_encode(array("success" => false ,"message" => "Deleted failed"));
    }
}
?>