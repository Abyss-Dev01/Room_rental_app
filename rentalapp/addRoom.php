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

    $sql = "INSERT INTO rooms(roomid, image, address, latitude, longitude, phone, price, username) VALUES ('".$roomid."','".$image."','".$address."','".$latitude."','".$longitude."','".$phone."','".$price."','".$username."') ";
    $query = mysqli_query($db,$sql);

    if($query){
        echo json_encode("success");
    }
    else{
        echo json_encode("error");
    }


?>
