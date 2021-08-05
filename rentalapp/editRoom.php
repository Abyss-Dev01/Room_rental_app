<?php
    $db = mysqli_connect('localhost', 'root', '', 'roomrental');
    if(!$db){
        echo 'Database connection failed';
    }

    $roomid = $_POST['roomid'];
    $username = $_POST['username'];
    $image = $_POST['image'];
    $address = $_POST['address'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $phone = $_POST['phone'];
    $price = $_POST['price'];

    $sql = "UPDATE rooms SET image ='".$image."', address = '".$address."', latitude = '".$latitude."', longitude = '".$longitude."', phone = '".$phone."', price = '".$price."' WHERE roomid = ''".$roomid."''  ";
    $query = mysqli_query($db,$sql);

    if($query){
        echo json_encode("success");
    }
    else{
        echo json_encode("error");
    }


?>
