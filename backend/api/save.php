<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

if($_SERVER['REQUEST_METHOD'] == 'GET'){

  $username = $_GET["username"];

  $selectSavedPinDataQuery = "SELECT p.pinID, p.pin_image_path, p.pin_Url
                              FROM user u
                              INNER JOIN save s
                              ON u.username = s.username AND u.username = ?
                              INNER JOIN pin p
                              ON p.pinID = s.pinID";

  $stmtSavedPinDataQuery = $conn->prepare($selectSavedPinDataQuery);

  if(!$stmtSavedPinDataQuery){
      http_response_code(500);
      echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
  }

  $stmtSavedPinDataQuery->bind_param("s", $username);

  if(!$stmtSavedPinDataQuery->execute()){
      http_response_code(500);
      echo json_encode(array("error_pin_execute" => "Error executing statement: " . $stmtSavedPinDataQuery->error));
      exit();
  }

  // Bind the result variables
  $stmtSavedPinDataQuery->bind_result($pinId, $pin_image_path, $pin_Url);

  $pinData = [];
  while($stmtSavedPinDataQuery->fetch()){
      $pinData[] = array('pinId'=>$pinId, 'pinImage'=>$pin_image_path, 'pinUrl'=>$pin_Url);
  }

  // Have results
  http_response_code(200);
  echo json_encode(array(
      "success" => true,
      "message" => "Retrieved successfully",
      "pinData" => $pinData
  ));
            
}

// Insert one (when user clicks on 'save')
elseif($_SERVER['REQUEST_METHOD'] == 'POST'){

  $pin_id = $_POST["pinId"];
  $username = $_POST["username"];
  
  $insertSaveQuery = "INSERT INTO save (pinID, username) VALUES (?, ?)";

  $stmtInsertSaveQuery = $conn->prepare($insertSaveQuery);

  if(!$stmtInsertSaveQuery){
    http_response_code(500);
    echo json_encode(array("error_isin_prepare" => "Error in prepared statement: " . $conn->error));
    exit();
  }

  // Bind values
  $stmtInsertSaveQuery->bind_param("is", $pin_id, $username);

  // Execute the statement
  if (!$stmtInsertSaveQuery->execute()) {
    http_response_code(500);
    echo json_encode(array("error_isin_execute" => "Error executing statement: " . $stmtInsertSaveQuery->error));
    exit();
  }

  if($stmtInsertSaveQuery->affected_rows > 0){
    // Response back
    http_response_code(200);
    echo json_encode(array(
        "success" => true,
        "message" => "Inserted successfully"
    ));
    } else {
      // Response back
      http_response_code(500);
      echo json_encode(array(
      "success" => false,
      "message" => "Inserted failed" . $stmtInsertSaveQuery->error
    ));
  }
}

// Delete save
elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"));
    $pin_id = $data->pinId;
    $username = $data->username;

    // Declare the delete query
    $deleteSaveDataQuery = "DELETE FROM save WHERE pinId = ? and username = ?";

    // Use a prepared statement
    $stmt = $conn->prepare($deleteSaveDataQuery);

    // Check if the prepared statement is successful
    if($stmt){

        $stmt->bind_param("is", $pin_id, $username);

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