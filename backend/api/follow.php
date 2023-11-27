<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    
    $action = $_GET["action"];
    $username = $_GET["username"];

    if ($action == "readFollowingCount") {

        $readFollowingCountQuery = "CALL ReadFollowingCount(?)";
        $stmtFollowingCount = $conn->prepare($readFollowingCountQuery);
        $stmtFollowingCount->bind_param("s", $username);

        if (!$stmtFollowingCount->execute()) {
            http_response_code(500);
            echo json_encode(array("error" => "Error executing statement: " . $stmtFollowingCount->error));
            exit();
        }

        $stmtFollowingCount->bind_result($followingCount);
        $stmtFollowingCount->fetch();

        http_response_code(200);
        echo json_encode(array(
            "success" => true,
            "message" => "Retrieved comments successfully",
            "followingCount" => $followingCount
        ));
        
    } elseif ($action == "readFollowerCount") {

        $readFollowerCountQuery = "CALL ReadFollowerCount(?)";
        $stmtFollowerCount = $conn->prepare($readFollowerCountQuery);
        $stmtFollowerCount->bind_param("s", $username);

        if (!$stmtFollowerCount->execute()) {
            http_response_code(500);
            echo json_encode(array("error" => "Error executing statement: " . $stmtFollowerCount->error));
            exit();
        }

        $stmtFollowerCount->bind_result($followerCount);
        $stmtFollowerCount->fetch();

        http_response_code(200);
        echo json_encode(array(
            "success" => true,
            "message" => "Retrieved comments successfully",
            "followerCount" => $followerCount
        ));
    }
} elseif ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Handle follow insertion or deletion based on JSON data

    $usernameToFollow = $_POST["usernameToFollow"];
    $username = $_POST["username"];

    $insertFollowQuery = "CALL InsertFollow(?, ?)";
    $stmtInsertFollow = $conn->prepare($insertFollowQuery);
    $stmtInsertFollow->bind_param("ss", $usernameToFollow, $username);

    if (!$stmtInsertFollow->execute()) {
        http_response_code(500);
        echo json_encode(array("error" => "Error executing statement: " . $stmtInsertFollow->error));
        exit();
    }

    http_response_code(200);
    echo json_encode(array("success" => true, "message" => "Follow relationship inserted successfully"));
    
} elseif ($_SERVER['REQUEST_METHOD'] == 'DELETE') {
    // Handle follow insertion or deletion based on JSON data
    $data = json_decode(file_get_contents("php://input"));
    
    $usernameToUnfollow = $data->usernameToUnfollow;
    $username = $data->username;

    $deleteFollowQuery = "CALL DeleteFollow(?, ?)";
    $stmtDeleteFollow = $conn->prepare($deleteFollowQuery);
    $stmtDeleteFollow->bind_param("ss", $usernameToUnfollow, $username);

    if (!$stmtDeleteFollow->execute()) {
        http_response_code(500);
        echo json_encode(array("error" => "Error executing statement: " . $stmtDeleteFollow->error));
        exit();
    }

    if($stmtDeleteFollow->affected_rows > 0){
        http_response_code(200);
        echo json_encode(array("success" => true, "message" => "Follow relationship deleted successfully"));
    } else {
        http_response_code(200);
        echo json_encode(array("success" => true, "message" => "No follow relationship found"));
    }

}

// Close the database connection
$conn->close();

?>