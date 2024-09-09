
<?php

// Include the database connection file
include("dbconnection.php");

// Establish the database connection
$con = dbconnection();

// Check if connection is successful
if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}

// Check if restaurant ID is provided
if (isset($_GET['restaurantId'])) {
    $restaurantId = $_GET['restaurantId'];

    // Fetch products for the specified restaurant
    $products_sql = "SELECT * FROM products WHERE RestaurantID = $restaurantId";
    $products_result = mysqli_query($con, $products_sql);

    if (mysqli_num_rows($products_result) > 0) {
        $products = array();
        while ($product_row = mysqli_fetch_assoc($products_result)) {
            // Construct product object
            $product = array(
                
                'name' => $product_row['Name'] ?? '', // Handle null name
                'description' => $product_row['Description'] ?? '', // Handle null description
                'price' => (double)$product_row['Price'] ?? 0.0 // Handle null price
            );
            $products[] = $product;
        }
        // Return JSON response
        echo json_encode($products);
    } else {
        echo json_encode(array("message" => "No products found for the specified restaurant ID"));
    }
} else {
    echo json_encode(array("message" => "Restaurant ID is not provided"));
}

mysqli_close($con);
?>
