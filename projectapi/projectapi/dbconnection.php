<?php
function dbconnection()
{
   $con=mysqli_connect('localhost','root','','project');

   return $con;
}
?>