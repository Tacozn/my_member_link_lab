<?php
function testPaymentAPI() {
    $url = 'http://localhost/memberlink/api/store_payment.php';
    
    // Test Case 1: Valid POST Request
    $validData = array(
        'membership_name' => 'Premium',
        'amount' => '99.99',
        'transaction_id' => 'TX'.time(),
        'payment_status' => 'completed',
        'purchase_date' => date('Y-m-d H:i:s')
    );
    
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $validData);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    
    $response = curl_exec($ch);
    echo "Test 1 - Valid POST:\n";
    echo $response . "\n\n";
    
    // Test Case 2: GET Request (Should fail)
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    $response = curl_exec($ch);
    echo "Test 2 - GET Request:\n";
    echo $response . "\n\n";
    
    // Test Case 3: Missing Fields
    $invalidData = array(
        'membership_name' => 'Premium'
    );
    
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $invalidData);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    
    $response = curl_exec($ch);
    echo "Test 3 - Missing Fields:\n";
    echo $response . "\n\n";
    
    curl_close($ch);
}

testPaymentAPI();
?>