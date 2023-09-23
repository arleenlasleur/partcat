<?php
if(isset($_GET['save'])){
  $json = file_get_contents('php://input');
  $pjson = json_decode($json);
  if($pjson !=null && $adv_arr!==false){
    $json="var data=".$json.";";
    if(file_put_contents("data.json", $json, LOCK_EX)===strlen($json)) echo "0";  // ok
     else echo "1";  // write error
  }else echo "2";    // incorrect JSON
}else{
  header("Cache-control: no-cache");
  header("Expires: 0");
  header("Pragma: no-cache");
  $json_fallback = "var data=[[\"MCU\",\"Atmega8\",\"TQFP32\",\"\",2,4,4,15]];";
  if(file_exists("data.json")) $json = file_get_contents("data.json"); else $json = $json_fallback;
  $html = file_get_contents("cat.html");  /* !! ERROR UNHANDLED !! */
  // $html = base64_decode("");
  $html = str_replace($json_fallback,$json,$html);
  $html = str_replace("127.0.0.1:1995",$_SERVER['PHP_SELF'],$html);
  echo $html;
}
?>