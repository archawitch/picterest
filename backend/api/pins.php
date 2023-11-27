<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

// Read created pins or one pin by id
if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $action = $_GET["action"];

    // check the actions of the request
    if($action == "selectOne"){

        $pin_id = $_GET["pinId"];

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
        $stmtPinData->bind_result($fullname, $username, $profile_image_path, $pin_title, $pin_description, $pin_url, $pin_image_path);

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
                    "fullname" => $fullname,
                    "username" => $username,
                    "profileImage" => $profile_image_path,
                    "tags" => $pin_tags
                )));
            
        } else {
            echo json_encode(array("success" => false, "message" => "Pin not found"));
            exit();
        }
    }

    elseif ($action == "selectMany") {

        $username = $_GET["username"];

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

elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try{
        $username = $_POST["username"];
        $pin_title = $_POST["pinTitle"] != "null" ? $_POST["pinTitle"] : NULL;
        $pin_description = $_POST["pinDescription"] != "null" ? $_POST["pinDescription"] : NULL;
        $pin_url = $_POST["pinUrl"] != "null" ? $_POST["pinUrl"] : NULL;
        $pin_tags = $_POST["pinTags"] != "null" ? explode(',', $_POST["pinTags"]) : array();
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

                $insertPinDataQuery = "CALL InsertPin (?, ?, ?, ?, ?, @pin_id)";

                // Insert into pin table
                $stmtInsertPin = $conn->prepare($insertPinDataQuery);
                $stmtInsertPin->bind_param("sssss", $pin_title, $pin_description, $pin_url, $pin_image_path, $username);

                if ($stmtInsertPin->execute()) {
                    // Retrieve pinID
                    $query = $conn->query('SELECT @pin_id');
                    $result = $query->fetch_assoc();
                    $pin_id = $result['@pin_id'];

                    // Insert tags
                    foreach ($pin_tags as $tag_name) {
                        // Insert into tag table if not duplicated
                        $insertTagQuery = "CALL InsertTagAndSave (?, ?)";
                        $stmtInsertTag = $conn->prepare($insertTagQuery);
                        $stmtInsertTag->bind_param("is", $pin_id, $tag_name);

                        if(!$stmtInsertTag->execute()){
                            // Failed
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
                        "message" => "Inserted successfully",
                        "pinId" => $pin_id
                    ));

                } else {
                    http_response_code(500);
                    echo json_encode(array(
                        "success" => false,
                        "message" => "Inserted pin failed: " . $stmtInsertPin->error
                    ));
                    exit();
                }

            } else {
                http_response_code(500);
                echo json_encode(array("success" => false, "message" => "Uploaded failed : " . $uploadFile));
            }
        } else {
            http_response_code(404);
            echo json_encode(array("success" => false, "message" => "No file uploaded"));
        }

    } catch (Exception $e) {
        echo json_encode($conn->connect_error);
    }
}
// Close the database connection
$conn->close();

?>