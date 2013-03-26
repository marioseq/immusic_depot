<?php
//
//
//
//
//// parse current file path

$zs1_path = 'http';
if ($_SERVER["HTTPS"] == "on") {$zs1_path .= "s";}
$zs1_path .= "://";

$zs1_path.=$_SERVER['SERVER_NAME'];

$info = pathinfo($_SERVER['PHP_SELF']);
$zs1_path.=$info['dirname'] . '/';
//$zs1_path.=$info['basename'];




// print info

//print_r($info);
$w =  $_GET['width']-10;
$h =  $_GET['height']-40;



//if($_GET['type']=='normal'){
    echo '<p><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="' .$w . '" height="' . $h . '">
        <param name="movie" value="' . dirname(__FILE__) . '/deploy/preview.swf?video=' . $_GET['source'] . '&types=' . $_GET['type'] . '" />
        <param name="allowFullScreen" value="true"/>
        <param name="allowScriptAccess" value="always"/>
        <param name="wmode" value="opaque"/>
        <object type="application/x-shockwave-flash" data="' . $zs1_path . 'deploy/preview.swf?video=' . $_GET['source'] . '&types=' . $_GET['type'] . '" width="' . $w . '" height="' . $h . '" allowFullScreen="true" allowScriptAccess="always" wmode="opaque">
        <video width="300" height="200" src="' . $zs1_items[$k][$i][0] . '"></video></object>
</object></p>';
//}
?>