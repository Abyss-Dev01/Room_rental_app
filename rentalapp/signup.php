<?php
    $db = mysqli_connect('localhost', 'root', '', 'roomrental');
    if(!$db){
        echo 'Database connection failed';
    }

    $username = $_POST['username'];
    $password = $_POST['password'];

    $sql = "INSERT INTO users(username, password) VALUES ('".$username."','".$password."') ";
    $query = mysqli_query($db,$sql);

    if($query){
        echo json_encode("success");
    }
    else{
        echo json_encode("error");
    }

?>
