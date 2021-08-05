<?php
    $db = mysqli_connect('localhost', 'root', '', 'roomrental');
    if(!$db){
        echo 'Database connection failed';
    }


    $sql = "SELECT roomid,image,username,address,latitude,longitude,phone,price FROM rooms WHERE username = 'dummy01' ";
    $result = mysqli_query($db,$sql);
    $count = mysqli_num_rows($result);
    $data = array();

    if($count >= 1){
        while($row = mysqli_fetch_assoc($result)){
    			$data[] = $row;
    		}
    }
    else{
        echo json_encode("error");
    }

    echo json_encode($data);

?>
