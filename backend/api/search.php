<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

if($_SERVER['REQUEST_METHOD'] == 'GET'){

  $data = json_decode(file_get_contents("php://input"));

  $query = $data->query;
  
  $selectPinResultQuery = "CALL SearchPins (?)";

  $stmtPinResultQuery = $conn->prepare($selectPinResultQuery);

  if(!$stmtPinResultQuery){
    http_response_code(500);
    echo json_encode(array("error_pin_prepare" => "Error in prepared statement: " . $conn->error));
    exit();
  }

  // Bind username
  $stmtPinResultQuery->bind_param("s", $query);

  // Execute the statement
  if (!$stmtPinResultQuery->execute()) {
    http_response_code(500);
    echo json_encode(array("error_pin_execute" => "Error executing statement: " . $stmt->error));
    exit();
  }

  // Bind the result variables
  $stmtPinResultQuery->bind_result($pinId, $pin_image_path, $pin_Url);
  
  while($stmtPinResultQuery->fetch()){
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

// Close the database connection
$conn->close();

?>