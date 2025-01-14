<?php
include_once("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $response = array('status' => 'failed', 'data' => null, 'error' => 'Only POST method allowed');
    sendJsonResponse($response);
    die();
}

try {
    $sql = "SELECT * FROM tbl_payments ORDER BY purchase_date DESC";
    $result = $conn->query($sql);

    if ($result) {
        $payments = array();
        while ($row = $result->fetch_assoc()) {
            $payments[] = array(
                'payment_id' => $row['payment_id'],
                'membership_name' => $row['membership_name'],
                'amount' => $row['amount'],
                'transaction_id' => $row['transaction_id'],
                'payment_status' => $row['payment_status'],
                'purchase_date' => $row['purchase_date']
            );
        }
        $response = array('status' => 'success', 'data' => $payments);
    } else {
        $response = array('status' => 'failed', 'data' => null, 'error' => 'Failed to fetch payments');
    }
} catch (Exception $e) {
    $response = array('status' => 'failed', 'data' => null, 'error' => $e->getMessage());
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

sendJsonResponse($response);
?>