<?php

// Include the database connection file
include("dbconnection.php");

// Establish the database connection
$con = dbconnection();

// Check if connection is successful
if (!$con) {
    die("Connection failed: " . mysqli_connect_error());
}


$sql = "SELECT * FROM resturant";

$result = mysqli_query($con, $sql);

if (mysqli_num_rows($result) > 0) {
  
    while ($row = mysqli_fetch_assoc($result)) {
     
        $arr[] = $row;
    }
} else {
    echo "No resturants found";
}

echo json_encode($arr);
mysqli_close($con);
?>

