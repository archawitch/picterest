<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// Insert one (when user clicks on 'save')
if($_SERVER['REQUEST_METHOD'] == 'POST'){

  $pin_id = $_POST["pinId"];
  $board_id = $_POST["boardId"];
  
  $insertIsInQuery = "INSERT INTO is_in (pinID, boardID) VALUES (?, ?)";

  $stmtInsertIsInQuery = $conn->prepare($insertIsInQuery);

  if(!$stmtInsertIsInQuery){
    http_response_code(500);
    echo json_encode(array("error_isin_prepare" => "Error in prepared statement: " . $conn->error));
    exit();
  }

  // Bind values
  $stmtInsertIsInQuery->bind_param("ii", $pin_id, $board_id);

  // Execute the statement
  if (!$stmtInsertIsInQuery->execute()) {
    http_response_code(500);
    echo json_encode(array("error_isin_execute" => "Error executing statement: " . $stmtInsertIsInQuery->error));
    exit();
  }

  if($stmtInsertIsInQuery->affected_rows > 0){
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
      "message" => "Inserted failed" . $stmtInsertIsInQuery->error
    ));
  }
}

// Delete is_in
elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"));
    $pin_id = $data->pinId;
    $username = $data->username;

    // Declare the delete query
    $deleteIsInDataQuery = "DELETE FROM is_in
                            WHERE pinID in
                            (SELECT pinID FROM save WHERE username = ?) and pinID = ?";

    // Use a prepared statement
    $stmt = $conn->prepare($deleteIsInDataQuery);

    // Check if the prepared statement is successful
    if($stmt){

        $stmt->bind_param("si", $username, $pin_id);

        // Execute the statement
        $stmt->execute();

        // Check for success
        http_response_code(200); // OK
        echo json_encode(array("success" => true, "message" => "Deleted successfully"));
    } else {
        http_response_code(500); // Internal Server Error
        echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
    }
}

// Close the database connection
$conn->close();

?>