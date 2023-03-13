<?php
$data ="";
$forms_data = [];
if ($_SERVER['REQUEST_URI'] === '/')
	$data="Hello World";
    echo $data;
if ($_SERVER['REQUEST_URI'] === '/feedback') {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        include 'index.html';
        $name = $_POST['name'];
        $email = $_POST['email'];
        $message = $_POST['feedback'];
        $feedback = [
            'name' => $name,
            'email' => $email,
            'feedback' => $message,
        ];
        array_push($forms_data, $feedback);
        $data = b"Your feedback submitted successfully.";
    }
}elseif($_SERVER['REDIRECT_STATUS'] == 404){
    header($_SERVER["SERVER_PROTOCOL"] . "404 NOT FOUND");
    include "notFound.php";
}

?>
