<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Database connection
include_once("dbconnect.php");

// Pagination setup
$page = isset($_GET['pageno']) ? $_GET['pageno'] : 1;
$results_per_page = 4;
$offset = ($page - 1) * $results_per_page;

try {
    
    
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    } 

    // Count total products
    $total_products_query = "SELECT COUNT(*) AS total FROM products";
    $total_result = $conn->query($total_products_query);
    $total_row = $total_result->fetch_assoc();
    $total_products = $total_row['total'];


    $total_pages = ceil($total_products / $results_per_page);

    
    $query = "SELECT product_id, product_name, product_description, product_price, product_quantity, product_image  
              FROM products 
              LIMIT $offset, $results_per_page";
    
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        $products = [];
        while ($row = $result->fetch_assoc()) {
            $products[] = $row;
        }

        $response = [
            'status' => 'success',
            'numberofresult' => $total_products,
            'numofpage' => $total_pages,
            'data' => [
                'products' => $products
            ]
        ];
    } else {
        $response = [
            'status' => 'error',
            'message' => 'No products found'
        ];
    }

   
    $conn->close();

   
    echo json_encode($response);

} catch (Exception $e) {
    
    $response = [
        'status' => 'error',
        'message' => $e->getMessage()
    ];
    echo json_encode($response);
}
?>