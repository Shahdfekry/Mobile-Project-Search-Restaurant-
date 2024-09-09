<?php

include("dbconnection.php");
$con = dbconnection();

$arr = array();

if(isset($_POST["name"])) {
  $name = $_POST['name'];
} else {
  $arr["success"] = false;
  $arr["message"] = "Name is required";
  echo json_encode($arr);
  exit(); // Stop further execution
}

if(isset($_POST["email"])) {
  $email = $_POST['email'];
} else {
  $arr["success"] = false;
  $arr["message"] = "Email is required";
  echo json_encode($arr);
  exit(); // Stop further execution
}

if(isset($_POST["id"])) {
  $id = $_POST['id'];
} else {
  $arr["success"] = false;
  $arr["message"] = "ID is required";
  echo json_encode($arr);
  exit(); // Stop further execution
}

if(isset($_POST["password"])) {
  $password = $_POST['password'];
} else {
  $arr["success"] = false;
  $arr["message"] = "Password is required";
  echo json_encode($arr);
  exit(); // Stop further execution
}

if(isset($_POST["confirm"])) {
  $confirm = $_POST['confirm'];
} else {
  $arr["success"] = false;
  $arr["message"] = "Confirmation password is required";
  echo json_encode($arr);
  exit(); // Stop further execution
}

if(isset($_POST["level"])) {
  $level = $_POST['level'];
} else {
  $arr["success"] = false;
  $arr["message"] = "Level is required";
  echo json_encode($arr);
  exit(); // Stop further execution
}

if(isset($_POST["gender"])) {
  $gender = $_POST['gender'];
} else {
  $arr["success"] = false;
  $arr["message"] = "Gender is required";
  echo json_encode($arr);
  exit(); // Stop further execution
}

// Check if email already exists
$check_query = "SELECT * FROM `signup_info` WHERE `Email` = '$email'";
$check_result = mysqli_query($con, $check_query);

if (mysqli_num_rows($check_result) > 0) {
  $arr["success"] = false;
  $arr["message"] = "Email already exists";
  echo json_encode($arr);
  exit(); // Stop further execution
}

$query = "INSERT INTO `signup_info`(`Name`, `Email`, `Gender`, `Password`, `ConfirmPassword`, `ID`, `Level`) VALUES ('$name','$email','$gender','$password','$confirm','$id','$level')";
$exe = mysqli_query($con, $query);

if($exe) {
  $arr["success"] = true;
} else {
  $arr["success"] = false;
  $arr["message"] = "Failed to insert record";
}

header('Content-Type: application/json');
echo json_encode($arr);
?>
