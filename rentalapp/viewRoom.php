<?php
    $db = mysqli_connect('localhost', 'root', '', 'roomrental');
    if(!$db){
        echo 'Database connection failed';
    }


    $sql = ("SELECT roomid,image,username,address,phone,price FROM rooms");
    $query = mysqli_query($db,$sql);
  	$list = array();

  	if($query){
  		while($row = mysqli_fetch_assoc($query)){
  			$list[] = $row;
  		}
  	}

  	echo json_encode($list);

?>
