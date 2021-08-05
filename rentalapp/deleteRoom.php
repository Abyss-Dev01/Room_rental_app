<?php
    $db = mysqli_connect('localhost', 'root', '', 'roomrental');
    if(!$db){
        echo 'Database connection failed';
    }

    $roomid = $_POST['roomid'];

    $sql = "DELETE FROM rooms WHERE roomid = '".$roomid."' ";
    $query = mysqli_query($db,$sql);

    if($query){
        echo json_encode("success");
    }
    else{
        echo json_encode("error");
    }


?>
