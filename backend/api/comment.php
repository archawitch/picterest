<?php

include_once './config.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $pin_id = $_GET["pinId"];

    $selectCommentsQuery = "CALL ReadCommentsByPinID(?)";

    $stmtComments = $conn->prepare($selectCommentsQuery);

    if (!$stmtComments) {
        http_response_code(500);
        echo json_encode(array("error_comments_prepare" => "Error in prepared statement: " . $conn->error));
        exit();
    }

    // Bind pin ID
    $stmtComments->bind_param("i", $pin_id);

    // Execute the statement
    if (!$stmtComments->execute()) {
        http_response_code(500);
        echo json_encode(array("error_comments_execute" => "Error executing statement: " . $stmtComments->error));
        exit();
    }

    // Bind the result variables
    $stmtComments->bind_result($commentID, $fullname, $profile_image_path, $text, $date_commented);

    while ($stmtComments->fetch()) {
        $comments[] = array('commentID' => $commentID, 'fullname' => $fullname, "profileImage" => $profile_image_path, 'text' => $text, 'date_commented' => $date_commented);
    }

    // Have results
    http_response_code(200);
    echo json_encode(array(
        "success" => true,
        "message" => "Retrieved comments successfully",
        "comments" => $comments
    ));
}

// Insert one comment
elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $username = $_POST["username"];
    $pin_id = $_POST["pinId"];
    $text = $_POST["text"];

    $insertCommentQuery = "CALL InsertComment(?, ?, ?)";

    $stmtInsertComment = $conn->prepare($insertCommentQuery);

    if (!$stmtInsertComment) {
        http_response_code(500);
        echo json_encode(array("error_insert_comment_prepare" => "Error in prepared statement: " . $conn->error));
        exit();
    }

    // Bind parameters
    $stmtInsertComment->bind_param("sis", $username, $pin_id, $text);

    // Execute the statement
    if (!$stmtInsertComment->execute()) {
        http_response_code(500);
        echo json_encode(array("error_insert_comment_execute" => "Error executing statement: " . $stmtInsertComment->error));
        exit();
    }

    // Inserted successfully
    http_response_code(200);
    echo json_encode(array(
        "success" => true,
        "message" => "Comment inserted successfully"
    ));
}
// Close the database connection
$conn->close();
?>