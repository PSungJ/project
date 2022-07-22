<html>
<body>
<h1>Project</h1>
<?php

// 1. DB 연결 설정
$mysql_hostname = '172.17.0.2';
$mysql_username = 'root';
$mysql_password = 'It12345!';
$mysql_database = 'random';
$mysql_port = '3306';
$mysql_charset = 'UTF8';

// 2. DB 연결
$connect = new mysqli($mysql_hostname, $mysql_username, $mysql_password, $mysql_database, $mysql_port, $mysql_charset);

if($connect->connect_errno){
    echo '[연결실패..] : '.$connect->connect_error.'';
}else{
    echo '[연결성공!]'.'<br>';
}

// 3. 문자셋 지정
if(!$connect->set_charset($mysql_charset)){
    echo '[문자열 변경실패..] : '.$connect->connect_error;
}else{
    echo '[문자열 변경성공!]'.'<br>';
}

echo "<pre>";
echo print_r($connect);
echo "</pre>";

// 4. 쿼리 생성
$query = "select * from test_tb";

// 5. 쿼리 실행
$result = $connect->query($query) or die($this->_connect->error);

// 6. 결과 처리
while ($row = $result->fetch_array()){
    echo '<pre>';
    print_r($row);
    echo '</pre>';
}
// 또는
foreach($result as $row){
    echo '<pre>';
    print_r($row);
    echo '</pre>';
}

// 7. 연결 종료
$connect->close();
echo '[연결 종료...]';

?>

</body>
<html>
