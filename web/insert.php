<html>
<body>
<?php
$mysql_hostname = 'endpoint';
$mysql_username = 'root';
$mysql_password = 'random123';
$mysql_database = 'random';
$mysql_port = '3306';
$mysql_charset = 'UTF8';

$connect = new mysqli($mysql_hostname, $mysql_username, $mysql_password, $mysql_database, $mysql_port, $mysql_charset);

if($connect->connect_errno){
    echo '[잠시 후 다시 참여 부탁드립니다.] : '.$connect->connect_error.'';
}else{
    echo '[응모완료!]'.'<br>';
}

mysqli_query($connect,"INSERT INTO random VALUES ('$_POST[user_name]', '$_POST[user_phone]', '$_POST[user_email]', now());");
mysqli_close($connect);
echo ("<meta http-equiv='Refresh' content='1; URL=index.html'>");
?>
</body>
</html>