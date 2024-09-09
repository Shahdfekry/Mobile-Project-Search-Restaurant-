<?php


include("dbconnection.php");


$con = dbconnection();

if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}


if (isset($_GET['productName'])) {
    $productName = $_GET['productName'];

    $search_sql = "SELECT DISTINCT r.Name AS RestaurantName, r.Longitude, r.Latitude, r.Distance, r.ID
    FROM products p 
    INNER JOIN resturant r ON p.RestaurantID = r.ID 
    WHERE p.Name LIKE '%$productName%'";

$search_result = mysqli_query($con, $search_sql);

if ($search_result) {
$restaurants = array();
while ($row = mysqli_fetch_assoc($search_result)) {
$restaurant = array(
'id' => isset($row['ID']) ? $row['ID'] : '',
'name' => $row['RestaurantName'],
'longitude' => $row['Longitude'],
'latitude' => $row['Latitude'],
'distance' => $row['Distance']
);
$restaurants[] = $restaurant;
}

echo json_encode($restaurants);
}else {
        echo json_encode(array("message" => "No restaurants found for the specified product"));
    }
} else {
    echo json_encode(array("message" => "Product name is not provided"));
}

mysqli_close($con);
?>
