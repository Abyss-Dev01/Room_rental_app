<?php

  $db = mysqli_connect('localhost', 'root', '', 'roomrental');
  if(!$db){
      echo 'Database connection failed';
  }

  $username = $_POST['username'];

?>
