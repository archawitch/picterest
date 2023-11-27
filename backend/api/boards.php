<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// Read all users
if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $action = $_GET["action"];

    // check the actions of the request
    if($action == "selectOne"){

        $board_id = $_GET["boardId"];

        $selectBoardDataQuery = "SELECT b.boardID, b.board_name, b.board_description, p.pinID, p.pin_image_path, p.pin_Url
                              FROM board b
                              INNER JOIN is_in sn
                              ON sn.boardID = b.boardID AND b.boardID = ?
                              INNER JOIN pin p
                              ON p.pinID = sn.pinID";
                                
        $stmtBoardData = $conn->prepare($selectBoardDataQuery);

        // Prepared statement is not correct
        if(!$stmtBoardData){
            http_response_code(500);
            echo json_encode(array("error_board_prepare" => "Error in prepared statement: " . $conn->error));
            exit();
        }

        // Bind username
        $stmtBoardData->bind_param("i", $board_id);

        // Execute the statement
        if (!$stmtBoardData->execute()) {
            http_response_code(500);
            echo json_encode(array("error_board_prepare" => "Error executing statement: " . $stmtBoardData->error));
            exit();
        }

        // Bind the result variables
        $stmtBoardData->bind_result($boardId, $board_name, $board_description, $pinId, $pin_image_path, $pin_Url);


        while($stmtBoardData->fetch()){
          $pinData[] = array('pinId'=>$pinId, 'pinImage'=>$pin_image_path, 'pinUrl'=>$pin_Url);
        }

        // Have results
        http_response_code(200);
        echo json_encode(array(
            "success" => true,
            "message" => "Retrieved successfully",
            "boardId" => $boardId,
            "boardName" => $board_name,
            "boardDescription" => $board_description,
            "pinData" => $pinData
        ));
        
      } elseif ($action == "selectMany") {

        $username = $_GET["username"];

        $selectCreatedBoardDataQuery = "SELECT boardID, board_name, board_description FROM board WHERE username = ?";

        $stmtCreatedBoardDataQuery = $conn->prepare($selectCreatedBoardDataQuery);

        if(!$stmtCreatedBoardDataQuery){
            http_response_code(500);
            echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
        }

        $stmtCreatedBoardDataQuery->bind_param("s", $username);


        if(!$stmtCreatedBoardDataQuery->execute()){
            http_response_code(500);
            echo json_encode(array("error_pin_execute" => "Error executing statement: " . $stmtCreatedBoardDataQuery->error));
            exit();
        }

        // Bind the result variables
        $stmtCreatedBoardDataQuery->bind_result($board_id, $board_name, $board_description);

        while($stmtCreatedBoardDataQuery->fetch()){
            $boardData[] = array('boardId'=>$board_id, 'boardName'=>$board_name, 'boardDescription'=> $board_description);
        }

        $board_result = [];
        foreach($boardData as $board){

            $selectPinInBoardDataQuery = "SELECT p.pinID, p.pin_image_path
                                FROM board b
                                INNER JOIN is_in sn
                                ON b.boardID = sn.boardID
                                INNER JOIN pin p
                                ON p.pinID = sn.pinID
                                WHERE b.boardID = ?";

            $stmtPinInBoardDataQuery = $conn->prepare($selectPinInBoardDataQuery);

            if(!$stmtPinInBoardDataQuery){
                http_response_code(500);
                echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
            }

            $stmtPinInBoardDataQuery->bind_param("i", $board["boardId"]);

            if(!$stmtPinInBoardDataQuery->execute()){
                http_response_code(500);
                echo json_encode(array("error_pin_execute" => "Error executing statement: " . $stmtPinInBoardDataQuery->error));
                exit();
            }

            // Bind the result variables
            $stmtPinInBoardDataQuery->bind_result($pinId, $pin_image_path);
            
            $count = 0;
            $pinData = [];
            while($stmtPinInBoardDataQuery->fetch()){
                $pinData[] = array('pinId'=>$pinId, 'pinImage'=>$pin_image_path);
                $count++;
            }

            $board["pinData"] = $pinData;
            
            array_push($board_result, $board);
            
            $pinData = [];
        }

        if(count($board_result) == 0) $board_result = null;

        // Have results
        http_response_code(200);
        echo json_encode(array(
            "success" => true,
            "message" => "Retrieved successfully",
            "boardData" => $board_result
        ));
            
    }
}

elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try{
        $username = $_POST["username"];
        $board_name = $_POST["boardName"];
        $board_description = $_POST["boardDescription"] != "null" ? $_POST["boardDescription"] : NULL;

        $insertBoardDataQuery = "INSERT INTO board (board_name, board_description, username) VALUES (?, ?, ?)";

        // Insert into board table
        $stmtInsertBoard = $conn->prepare($insertBoardDataQuery);
        $stmtInsertBoard->bind_param("sss", $board_name, $board_description, $username);

        $stmtInsertBoard->execute();

        if($stmtInsertBoard->affected_rows > 0){
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
            "message" => "Inserted board failed" . $stmtInsertBoard->error
          ));
        }
    } catch (Exception $e) {
        echo json_encode($conn->connect_error);
    }
}
// Close the database connection
$conn->close();

?>