<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

function insertPin($username, $pin_title, $pin_description, $pin_url, $pin_tags, $pin_image_path){
    global $conn;

    $insertPinDataQuery = "CALL InsertPin (?, ?, ?, ?, ?, @pin_id)";

    // Step 1: Insert into pin table
    $stmtInsertPin = $conn->prepare($insertPinDataQuery);
    $stmtInsertPin->bind_param("sssss", $pin_title, $pin_description, $pin_url, $pin_image_path, $username);

    if ($stmtInsertPin->execute()) {
        // retrieve pinID
        $query = $conn->query('SELECT @pin_id');
        $result = $query->fetch_assoc();
        $pin_id = $result['@pin_id'];

        // Step 2: Retrieve pin_id and insert tags
        foreach ($pin_tags as $tag_name) {
            // Step 3: Insert into tag table if not duplicated
            $insertTagQuery = "CALL InsertTagAndSave (?, ?)";
            $stmtInsertTag = $conn->prepare($insertTagQuery);
            $stmtInsertTag->bind_param("is", $pin_id, $tag_name);

            if(!$stmtInsertTag->execute()){
                // Response back
                http_response_code(500);
                echo json_encode(array(
                    "success" => false,
                    "message" => "Inserted failed at tag: " . $tag_name . " Error: " . $stmtInsertTag->error
                ));
                exit();
            }
        }

        // Response back
        http_response_code(200);
        echo json_encode(array(
            "success" => true,
            "message" => "Inserted successfully"
        ));
        exit();

    } else {
        http_response_code(500);
        echo json_encode(array(
            "success" => false,
            "message" => "Inserted pin failed: " . $stmtInsertPin->error
        ));
        exit();
    }
}

// Read all users
if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $data = json_decode(file_get_contents("php://input"));

    $action = $data->action;

    // check the actions of the request
    if($action == "selectOne"){

        $pin_id = $data->pinId;

        $selectPinDataQuery = "CALL ReadPin (?)";
                                
        $stmtPinData = $conn->prepare($selectPinDataQuery);

        // Prepared statement is not correct
        if(!$stmtPinData){
            http_response_code(500);
            echo json_encode(array("error_pin_prepare" => "Error in prepared statement: " . $conn->error));
            exit();
        }

        // Bind username
        $stmtPinData->bind_param("i", $pin_id);

        // Execute the statement
        if (!$stmtPinData->execute()) {
            http_response_code(500);
            echo json_encode(array("error_pin_execute" => "Error executing statement: " . $stmt->error));
            exit();
        }

        // Bind the result variables
        $stmtPinData->bind_result($fullname, $pin_title, $pin_description, $pin_url, $pin_image_path);

        // Found pin
        if ($stmtPinData->fetch()) {

            $stmtPinData->free_result();
            $stmtPinData->close();

            $selectTagsInPinQuery = "CALL ReadTags (?)";

            $stmtTagsInPinQuery = $conn->prepare($selectTagsInPinQuery);

            // Prepared statement is not correct
            if(!$stmtTagsInPinQuery){
                http_response_code(500);
                echo json_encode(array("error_tags_prepare" => "Error in prepared statement: " . $conn->error));
                exit();
            }

            // Bind username
            $stmtTagsInPinQuery->bind_param("i", $pin_id);

            // Execute the statement
            if (!$stmtTagsInPinQuery->execute()) {
                http_response_code(500);
                echo json_encode(array("error_pin_execute" => "Error executing statement: " . $stmt->error));
                exit();
            }

            // Bind the result variables
            $stmtTagsInPinQuery->bind_result($tag_id, $tag_name);

            while($stmtTagsInPinQuery->fetch()){
                $pin_tags[] = array('tagId' => $tag_id, 'tagName' => $tag_name);
            }

            // Fetch each row and add it to the users array
            http_response_code(200);
            echo json_encode(array(
                "success" => true,
                "message" => "Retrieved successfully",
                "pinData" => array(
                    "pinId" => $pin_id,
                    "pinTitle" => $pin_title,
                    "pinDescription" => $pin_description,
                    "pinUrl" => $pin_url,
                    "pinImage" => $pin_image_path,
                    "userName" => $fullname,
                    "tags" => $pin_tags
                )));
            
        } else {
            echo json_encode(array("success" => false, "message" => "Pin not found"));
            exit();
        }
    }

    elseif ($action == "selectMany") {

        $username = $data->username;

        $selectCreatedPinDataQuery = "SELECT pinID, pin_image_path, pin_Url
                                        FROM pin
                                        WHERE username = ?";

        $stmtCreatedPinDataQuery = $conn->prepare($selectCreatedPinDataQuery);

        if(!$stmtCreatedPinDataQuery){
            http_response_code(500);
            echo json_encode(array("success" => false, "message" => "Error in prepared statement: " . $conn->error));
        }

        $stmtCreatedPinDataQuery->bind_param("s", $username);

        if(!$stmtCreatedPinDataQuery->execute()){
            http_response_code(500);
            echo json_encode(array("error_pin_execute" => "Error executing statement: " . $stmt->error));
            exit();
        }

        // Bind the result variables
        $stmtCreatedPinDataQuery->bind_result($pinId, $pin_image_path, $pin_Url);

        while($stmtCreatedPinDataQuery->fetch()){
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
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try{
        $username = $_POST["username"];
        $pin_title = $_POST["pinTitle"];
        $pin_description = $_POST["pinDescription"];
        $pin_url = $_POST["pinUrl"];
        $pin_tags = $_POST["pinTags"];
        $pin_image_path = null;

        // Check if a file was uploaded
        if (isset($_FILES['pinImage']) && $_FILES['pinImage']['error'] == 0) {
            $uploadDirForMove = '../images/pin_images/';
            $uploadDirForSave = '/backend/images/pin_images/';
            $uploadImageForMove = $uploadDirForMove . basename($_FILES['pinImage']['name']);
            $uploadImageForSave = $uploadDirForSave . basename($_FILES['pinImage']['name']);

            // Move the uploaded file to the specified directory
            $move_success = move_uploaded_file($_FILES['pinImage']['tmp_name'], $uploadImageForMove);
            if ($move_success) {
                $pin_image_path = $uploadImageForSave;

                /* -- INSERT PIN  -- */
                insertPin($username, $pin_title, $pin_description, $pin_url, $pin_tags, $pin_image_path);  

            } else {
                http_response_code(500);
                echo json_encode(array("success" => false, "message" => "Uploaded failed : " . $uploadFile));
            }
        } else {
            http_response_code(404);
            echo json_encode(array("success" => false, "message" => "No file uploaded"));
            exit();
        }

    } catch (Exception $e) {
        echo json_encode($conn->connect_error);
    }
}
// Close the database connection
$conn->close();
?>