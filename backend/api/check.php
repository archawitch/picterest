<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

if($_SERVER['REQUEST_METHOD'] == 'GET'){
  
  $action = $_GET["action"];

  // check if a pin is already saved by the user
  if($action == "checkSave"){

    $username = $_GET["username"];
    $pin_id = $_GET["pinId"];

    $selectSavedPinDataQuery = "SELECT count(pinID) FROM save WHERE username = ? AND pinID = ?";

    $stmtSavedPinDataQuery = $conn->prepare($selectSavedPinDataQuery);

    if(!$stmtSavedPinDataQuery){
      http_response_code(500);
      echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
    }

    $stmtSavedPinDataQuery->bind_param("si", $username, $pin_id);

    if(!$stmtSavedPinDataQuery->execute()){
        http_response_code(500);
        echo json_encode(array("error_save_execute" => "Error executing statement: " . $stmtSavedPinDataQuery->error));
        exit();
    }

    // Bind the result variables
    $stmtSavedPinDataQuery->bind_result($count);

    // Fetch the result
    $stmtSavedPinDataQuery->fetch();

    // Have results
    http_response_code(200);
    echo json_encode(array(
        "success" => true,
        "message" => "Retrieved successfully",
        "isSaved" => $count ? true : false
    ));
  } elseif($action == "checkFollow"){

    $usernameToFollow = $_GET["usernameToFollow"];
    $username = $_GET["username"];

    $selectSavedPinDataQuery = "SELECT count(*) FROM follow WHERE usernameFollowing = ? AND usernameFollower = ?";

    $stmtSavedPinDataQuery = $conn->prepare($selectSavedPinDataQuery);

    if(!$stmtSavedPinDataQuery){
      http_response_code(500);
      echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
    }

    $stmtSavedPinDataQuery->bind_param("ss", $usernameToFollow, $username);

    if(!$stmtSavedPinDataQuery->execute()){
        http_response_code(500);
        echo json_encode(array("error_save_execute" => "Error executing statement: " . $stmtSavedPinDataQuery->error));
        exit();
    }

    // Bind the result variables
    $stmtSavedPinDataQuery->bind_result($count);

    // Fetch the result
    $stmtSavedPinDataQuery->fetch();

    // Have results
    http_response_code(200);
    echo json_encode(array(
        "success" => true,
        "message" => "Retrieved successfully",
        "isFollowed" => $count ? true : false
    ));
  }
            
}

?>