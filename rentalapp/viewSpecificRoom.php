<?php
    $db = mysqli_connect('localhost', 'root', '', 'roomrental');
    if(!$db){
        echo 'Database connection failed';
    }

    $roomid = $_POST['roomid'];

    $sql = ("SELECT roomid,image,username,address,phone,price FROM rooms WHERE roomid = '".$roomid."' ");
    $query = mysqli_query($db,$sql);
  	$list = array();

  	if($query){
  		while($row = mysqli_fetch_assoc($query)){
  			$list[] = $row;
  		}
  	}

  	echo json_encode($list);

?>
