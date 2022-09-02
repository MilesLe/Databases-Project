
<head><title> Insert Tuple </title></head>
<body>

<?php
include 'open.php';

//Override the PHP configuration file to display all errors
//This is useful during development but generally disabled before release
ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);

$database = $_POST['database'];
$tuple = $_POST['tuple'];

//Determine if any input was actually collected
if (empty($database) or empty($tuple)) {

   echo "Empty input detected.<br><br>";

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

   // Insert into dbase
   $sql = "INSERT INTO ".$database." VALUES ".$tuple;
   if (!$conn->query($sql)) {
      echo "Insertion error. Make sure the attributes are all included and correctly formatted.<br>";
      $error = $conn->errno . ' ' . $conn->error;
      echo $error;
   }

   // Check num rows again
   $result = $conn->query($sqlCheck);
   if (!$result) {
      echo 'Could not run query.';
   } else {
      if (mysqli_num_rows($result) == $row_cnt) {
         echo "No rows updated. Please check that your insertion is properly formatted and fits constraints.";
      } else {
         echo "Insertion successful!";
      }
   }
}

//Close the connection created in open.php
$conn->close();
?>
</body>
