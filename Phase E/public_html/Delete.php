
<head><title> Delete Tuple </title></head>
<body>

<?php
include 'open.php';

//Override the PHP configuration file to display all errors
//This is useful during development but generally disabled before release
ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);

$database = $_POST['database'];
$ticker = $_POST['ticker'];
$specDate = $_POST['specDate'];
$name = $_POST['name'];

//Determine if any input was actually collected
if (empty($database)) {

   echo "Must select a database.<br><br>";

} elseif ($database == "Company") {

   if (empty($ticker) or empty($name)) {

      echo "Must specify ticker and CEO name.";

   } else {

      // Check for num rows in dbase
      $sqlCheck = "SELECT * FROM ".$database;
      $row_cnt = 0;
      $result = $conn->query($sqlCheck);
      if (!$result) {
         echo 'Could not run query.';
      } else {
         $row_cnt = mysqli_num_rows($result);
      }

      $sql = "DELETE FROM ".$database." WHERE ticker = '".$ticker."' AND name= '".$name."'";
      if (!$conn->query($sql)) {
         echo "Unsuccessful deletion.<br>";
         $error = $conn->errno . ' ' . $conn->error;
         echo $error; 
      }

      // Check num rows again
      $result = $conn->query($sqlCheck);
      if (!$result) {
         echo 'Could not run query.';
      } else {
         if (mysqli_num_rows($result) == $row_cnt) {
            echo "No rows updated. Please check that your deletion is properly formatted and fits constraints.";
         } else {
            echo "Deletion successful!";
         }
      }

   }

} elseif ($database == "MarketIndex" || $database == "Bond" || $database == "SectorETF" || $database == "OptionVolume") {

   if (empty($ticker) or empty($specDate)) {

      echo "Must specify ticker and date.";

   } else {

      // Check for num rows in dbase
      $sqlCheck = "SELECT * FROM ".$database;
      $row_cnt = 0;
      $result = $conn->query($sqlCheck);
      if (!$result) {
         echo 'Could not run query.';
      } else {
         $row_cnt = mysqli_num_rows($result);
      }

      $sql = "DELETE FROM ".$database." WHERE ticker = '".$ticker."' AND date_ = '".$specDate."'";
      if (!$conn->query($sql)) {
         echo "Unsuccessful deletion.<br>";
         $error = $conn->errno . ' ' . $conn->error;
         echo $error; 
      }

      // Check num rows again
      $result = $conn->query($sqlCheck);
      if (!$result) {
         echo 'Could not run query.';
      } else {
         if (mysqli_num_rows($result) == $row_cnt) {
            echo "No rows updated. Please check that your deletion is properly formatted and fits constraints.";
         } else {
            echo "Deletion successful!";
         }
      }

   }

} else {

   echo "Invalid database.<br><br>";
   
}

//Close the connection created in open.php
$conn->close();
?>
</body>
