<?php
include_once("dbconnect.php");

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'Only POST method allowed');
    sendJsonResponse($response);
    die();
}

// Debug: Print received POST data
error_log("Received POST data: " . print_r($_POST, true));

if (empty($_POST)) {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'No data received');
    sendJsonResponse($response);
    die();
}

$required_fields = ['membership_name', 'amount', 'transaction_id', 'payment_status', 'purchase_date'];
$missing_fields = [];

foreach ($required_fields as $field) {
    if (!isset($_POST[$field])) {
        $missing_fields[] = $field;
    }
}

if (!empty($missing_fields)) {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'Missing required fields: ' . implode(', ', $missing_fields));
    sendJsonResponse($response);
    die();
}

$membership_name = $_POST['membership_name'];
$amount = floatval($_POST['amount']); // Convert to float
$transaction_id = $_POST['transaction_id'];
$payment_status = $_POST['payment_status'];
$purchase_date = $_POST['purchase_date'];

// Debug: Print processed values
error_log("Processed values:");
error_log("membership_name: $membership_name");
error_log("amount: $amount");
error_log("transaction_id: $transaction_id");
error_log("payment_status: $payment_status");
error_log("purchase_date: $purchase_date");

$sql = "INSERT INTO tbl_payments (membership_name, amount, transaction_id, payment_status, purchase_date) 
        VALUES (?, ?, ?, ?, ?)";

try {
    $stmt = $conn->prepare($sql);
    if ($stmt === false) {
        throw new Exception("Prepare failed: " . $conn->error);
    }
    
    $stmt->bind_param("sdsss", $membership_name, $amount, $transaction_id, $payment_status, $purchase_date);
    
    if ($stmt->execute()) {
        $payment_id = $stmt->insert_id;
        $response = array('status' => 'success', 'data' => array(
            'payment_id' => $payment_id,
            'membership_name' => $membership_name,
            'amount' => $amount,
            'transaction_id' => $transaction_id,
            'payment_status' => $payment_status,
            'purchase_date' => $purchase_date
        ));
    } else {
        throw new Exception("Execute failed: " . $stmt->error);
    }
} catch (Exception $e) {
    error_log("Database error: " . $e->getMessage());
    $response = array('status' => 'failed', 'data' => null, 'error' => $e->getMessage());
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

sendJsonResponse($response);
?>