<?php
include_once("dbconnect.php");

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

$name = $_POST['name'];
$description = $_POST['description'];
$price = $_POST['price'];
$benefits = $_POST['benefits'];

$sql = "INSERT INTO tbl_memberships (name, description, price, benefits) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssds", $name, $description, $price, $benefits);

if ($stmt->execute()) {
    $membership_id = $stmt->insert_id;
    $response = array('status' => 'success', 'data' => array('membership_id' => $membership_id));
} else {
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>