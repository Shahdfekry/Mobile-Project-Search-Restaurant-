<?php

include("dbconnection.php"); 
$con = dbconnection(); 

$arr = array(); 

// Check if email and password are provided in the request
if(isset($_POST["email"]) && isset($_POST["password"])) {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Prepare SQL statement to retrieve user with given email and password
    $query = "SELECT * FROM `signup_info` WHERE `Email` = '$email' AND `Password` = '$password'";
    $result = mysqli_query($con, $query);

    // Check if any row is returned
    if(mysqli_num_rows($result) > 0) {
        $arr["success"] = true;
    } else {
        $arr["success"] = false;
        $arr["message"] = "Invalid email or password";
    }
} else {
    $arr["success"] = false;
    $arr["message"] = "Email and password are required";
}

header('Content-Type: application/json');

echo json_encode($arr);

mysqli_close($con);
?>
