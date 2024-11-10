<?php
if (!isset($_POST['email']) || !isset($_POST['password'])) {
    $response = array('status' => 'failed', 'data' => 'Missing fields');
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']);

// Check if email already exists
$sqlexists = "SELECT * FROM `tbl_admins` WHERE `admin_email` = '$email'";
$result = $conn->query($sqlexists);

if ($result->num_rows > 0) {
    $response = array('status' => 'failed', 'data' => 'Email already exists');
    sendJsonResponse($response);
    die;
}

// Insert new admin
$sqlinsert = "INSERT INTO `tbl_admins`(`admin_email`, `admin_pass`) VALUES ('$email', '$password')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
} else {
    $response = array('status' => 'failed', 'data' => 'Database error');
}
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
