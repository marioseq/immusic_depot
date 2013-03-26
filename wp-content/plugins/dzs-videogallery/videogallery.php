<?php
/*
  Plugin Name: DZS Video Gallery
  Plugin URI: http://digitalzoomstudio.net/
  Description: Creates and manages video galleries.
  Version: 3.1.3
  Author: Digital Zoom Studio
  Author URI: http://digitalzoomstudio.net/
 */
require_once('config.php');
$zs1_path = plugins_url('', __FILE__) . '/';
$zs1_items = get_option('zs1_items');

$zs1_nr_sliders = 0;
$zs1_capability = 'administrator';
$zs1_output = '';
$zs1_shortcode='videogallery';

$zs1_settings_alwaysembed="on";

$zs1_ispreview='off';
$aux = strpos($_SERVER["REQUEST_URI"], $zs1_config['page']);
if($zs1_config['ispreview']=='on' && $aux!==false)
    $zs1_ispreview='on';

if(isset($_POST['zs1_export'])){
header('Content-Type: text/plain'); 
header('Content-Disposition: attachment; filename="' . "file.txt" . '"'); 
echo serialize($zs1_items);
die();
}
if(isset ($_POST['zs1_uploadfile_confirm'])){
    //print_r( $_FILES);
    $file_data = file_get_contents($_FILES['dzs_uploadfile']['tmp_name']);
    update_option('zs1_items', unserialize($file_data));
    //print_r($file_data);
    $zs1_items = unserialize($file_data);
//print_r($file_data);
    //die();
}


add_action('admin_menu', 'zs1_admin_menu');
add_action('admin_head', 'zs1_admin_head');
add_action('init', 'zs1_init');

add_action('wp_head', 'zs1_head');
add_action('wp_ajax_zs1_ajax', 'zs1_saveItems');




if($zs1_settings_alwaysembed!="on")
add_filter('wp_print_styles', 'zs1_print_styles');


//remove_filter('the_content', 'wpautop');
//remove_filter('the_content', 'wptexturize');
//register_deactivation_hook(__FILE__, 'zs1_unnistall');




function zs1_print_styles() {
    global $zs1_path, $zs1_shortcode, $post;

    wp_enqueue_script('jquery');

    
    $pos = strpos($post->post_content, '[' . $zs1_shortcode);
    $pos_alt = strpos($post->post_content, '[' . $zs1_shortcode . '_alt');

    if($pos!==false){
            zs1_enqueue_scripts();
        if($pos_alt!=false){
            wp_enqueue_script('thickbox');
            wp_enqueue_style('thickbox');

        }
    }
}

function zs1_init() {
    global $zs1_path, $zs1_settings_alwaysembed;

    wp_enqueue_script('jquery');
    if (is_admin ()) {
        if (isset($_REQUEST['page']) && $_REQUEST['page'] == "zs1_menu") {
            wp_enqueue_script('media-upload');
            wp_enqueue_script('thickbox');
            wp_enqueue_style('thickbox');

            wp_enqueue_script('zsvideogallery-admin', $zs1_path . 'js/admin.js');

            wp_register_style('jquery.ui.all', $zs1_path . "style/base/jquery.ui.all.css");
            wp_enqueue_style('zs1_admin_style', $zs1_path . "style/admindefault/style.css");
            wp_enqueue_style('jquery.ui.all');

            wp_enqueue_script('jquery-ui-core');
            wp_enqueue_script('jquery-ui-sortable');
        }
    }else{
        if($zs1_settings_alwaysembed=="on")
            zs1_enqueue_scripts();
    }
}
function zs1_enqueue_scripts(){
    global $zs1_path, $zs1_ispreview;
        wp_enqueue_script('swfobject'); 
        wp_enqueue_script('jquery.masonry', $zs1_path . 'js/jquery.masonry.min.js');
        wp_enqueue_script('jquery.iosgallery', $zs1_path . 'js/iosgallery.js');
        wp_enqueue_script('swfaddress', $zs1_path . 'js/swfaddress.js');
        wp_enqueue_script('thickbox');
        wp_enqueue_style('thickbox');
        if($zs1_ispreview=='on'){
        wp_enqueue_script('preseter', $zs1_path . 'preseter/preseter.js');
        wp_enqueue_style('preseter', $zs1_path . 'preseter/preseter.css');
        }
}

function zs1_head() {
    global $zs1_path;
}

add_shortcode($zs1_shortcode, 'zs1_show_slider');
add_shortcode('dzs_' . $zs1_shortcode, 'zs1_show_slider');
add_shortcode('videogallery_alt', 'zs1_shortcode_alt');

function zs1_addAttr($arg1, $arg2) {
    global $zs1_output;

    if ($arg2 != "undefined" && $arg2 != '')
        $zs1_output.= $arg1 . '="' . $arg2 . '" ';
}

function zs1_show_slider($arg) {
    //print_r($arg);
    global $zs1_items;
    global $zs1_output;
    global $zs1_nr_sliders;
    global $zs1_path, $zs1_ispreview;

    $zs1_output='';
    $zs1_nr_sliders++;


    if ($zs1_items == '')
        return;

    $i = 0;
    $k = 0;

    for ($i = 0; $i < count($zs1_items); $i++) {
        if ((isset($arg['id'])) && ($arg['id'] == $zs1_items[$i][0][0]))
            $k = $i;
    }
    

    $user_feed = '';

    $yt_playlist_feed = '';
    if($zs1_items[$k][0][6]=='on' && $zs1_items[$k][0][7]!=''){
        $user_feed = $zs1_items[$k][0][7];
        if($zs1_items[$k][0][8]=='')
        $zs1_items[$k][0][6]='off';
    }
    if($zs1_items[$k][0][6]=='on' && $zs1_items[$k][0][8]!=''){
        $yt_playlist_feed = $zs1_items[$k][0][8];
        $zs1_items[$k][0][6]='on';
        $user_feed='';
    }
    
    if($zs1_ispreview=='on' && $zs1_nr_sliders<2){
        if(isset ($_GET['opt1']))
            $zs1_items[$k][0][1] = $_GET['opt1'];
        if(isset ($_GET['opt2']))
            $zs1_items[$k][0][2] = $_GET['opt2'];
        if(isset ($_GET['opt3']))
            $zs1_items[$k][0][3] = $_GET['opt3'];
        if(isset ($_GET['opt4']))
            $zs1_items[$k][0][4] = $_GET['opt4'];
        if(isset ($_GET['opt5']))
            $zs1_items[$k][0][6] = $_GET['opt5'];
        if(isset ($_GET['opt6']))
            $zs1_items[$k][0][7] = $_GET['opt6'];
    }
    

    if($user_feed!=''){
        $target_file ="http://gdata.youtube.com/feeds/api/users/".$user_feed."/uploads?v=2&alt=jsonc";
        //echo $target_file;
        $ida = file_get_contents($target_file);
        $idar = json_decode($ida);
        //print_r($idar);
        //print_r(count($idar->data->items));
        $i=1;
        if($zs1_items[$k][0][11]=='') $zs1_items[$k][0][11]=100;
        $yf_maxi = $zs1_items[$k][0][11];
        
        foreach ($idar->data->items as $ytitem){
            //print_r($ytitem);
            $zs1_items[$k][$i][0] = $ytitem->id;
            $zs1_items[$k][$i][1] = "";
            $zs1_items[$k][$i][2] = "youtube";

            $aux = $ytitem->title;
            $lb   = array("\r\n", "\n", "\r", "&" ,"-", "`", '�', "'", '-');
            $aux = str_replace($lb, ' ', $aux);
            $zs1_items[$k][$i][3] = $aux;

            $aux = $ytitem->description;
            $lb   = array("\r\n", "\n", "\r", "&" ,"-", "`", '�', "'", '-');
            $aux = str_replace($lb, ' ', $aux);
            $zs1_items[$k][$i][4] = $aux;

            $i++;
            if($i>$yf_maxi+1)
                break;
        }
        
            $zs1_items[$k][$i][0] = " ";
            $zs1_items[$k][$i][1] = " ";
            $zs1_items[$k][$i][2] = " ";
    }
    
    
    
    
    if($yt_playlist_feed!=''){
        $target_file ="http://gdata.youtube.com/feeds/api/playlists/".$yt_playlist_feed."?alt=json&start-index=1&max-results=40";
        
        /*
        $ida = file_get_contents($target_file);
        $idar = json_decode($ida);
        //print_r(count($idar->data->items));
        $i=0;
        if($zs1_items[$k][0][11]=='') {
            $zs1_items[$k][0][11]=100;
        }
        $yf_maxi = $zs1_items[$k][0][11];
        
        foreach ($idar->feed->entry as $ytitem){
            //print_r($ytitem);
            
            
            $aux = array();
            parse_str($ytitem->link[0]->href, $aux);
            //print_r($aux['http://www_youtube_com/watch?v']);
        
            $zs1_items[$k][$i][0] = $aux['http://www_youtube_com/watch?v'];
            $zs1_items[$k][$i][1] = "";
            $zs1_items[$k][$i][2] = "youtube";
            
            //$aux = $ytitem->title;
            //$lb   = array("\r\n", "\n", "\r", "&" ,"-", "`", '�', "'", '-');
            //$aux = str_replace($lb, ' ', $aux);
            //$zs1_items[$k][$i][3] = $aux;

           // $aux = $ytitem->description;
           // $lb   = array("\r\n", "\n", "\r", "&" ,"-", "`", '�', "'", '-');
            //$aux = str_replace($lb, ' ', $aux);
            //$zs1_items[$k][$i][4] = $aux;

            $i++;
            if($i>$yf_maxi+1)
                break;
        }
        
            $zs1_items[$k][$i][0] = " ";
            $zs1_items[$k][$i][1] = " ";
            $zs1_items[$k][$i][2] = " ";
        
         * 
         */
    }
    
    //http://vimeo.com/api/v2/blakewhitman/videos.json
    if(isset($zs1_items[$k][0][15]) && $zs1_items[$k][0][15]=='on'){
        $target_file ="http://vimeo.com/api/v2/".$zs1_items[$k][0][16]."/videos.json";
        $ida = file_get_contents($target_file);
        $idar = json_decode($ida);
        $i=1;
        foreach ($idar as $item){
            $zs1_items[$k][$i][0] = $item->id;
            $zs1_items[$k][$i][1] = $item->thumbnail_small;
            $zs1_items[$k][$i][2] = "vimeo";
            
            $aux = $item->title;
            $lb   = array("\r\n", "\n", "\r", "&" ,"-", "`", '�', "'", '-');
            $aux = str_replace($lb, ' ', $aux);
            $zs1_items[$k][$i][3] = $aux;

            $aux = $item->description;
            $lb   = array("\r\n", "\n", "\r", "&" ,"-", "`", '�', "'", '-');
            $aux = str_replace($lb, ' ', $aux);
            $zs1_items[$k][$i][4] = $aux;
            $i++;
        }
        
    }
    //if(isset($zs1_items[$k][0][14])&& $zs1_items[$k][0][14]!='')
    if($zs1_items[$k][0][13]=='wall'){
        
        $zs1_output.='<style>
            .dzs-gallery-container .item{ width:23%; margin-right:1%; float:left; position:relative; }
            .dzs-gallery-container .item-image{ width:100%; }
            .dzs-gallery-container h4{  color:#D26; }
            .dzs-gallery-container h4:hover{ background: #D26; color:#fff; }
            .clear { clear:both; }
            </style>';
        $zs1_output.='<div class="dzs-gallery-container">';
        
        for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
            $zs1_output.='<div class="item">';
            $zs1_output.='<a href="'.$zs1_path.'ajax.php?height='.$zs1_items[$k][0][2].'&width='.$zs1_items[$k][0][1].'&type='.$zs1_items[$k][$i][2].'&source='.$zs1_items[$k][$i][0].'" title="'.$zs1_items[$k][$i][3].'" class="thickbox"><img class="item-image" src="';
            if($zs1_items[$k][$i][1]!='')
                $zs1_output.=$zs1_items[$k][$i][1];
            else{
                if($zs1_items[$k][$i][2]=="youtube"){
                  $zs1_output.='http://img.youtube.com/vi/'.$zs1_items[$k][$i][0].'/0.jpg';
                  $zs1_items[$k][$i][1]='http://img.youtube.com/vi/'.$zs1_items[$k][$i][0].'/0.jpg';
                }
            }
            $zs1_output.='"/></a>';
            $zs1_output.='<h4>'.$zs1_items[$k][$i][3].'/<h4>';
            $zs1_output.='</div>';
        }
        $zs1_output.='<div class="clear"></div>';
        $zs1_output.='</div>';
        $zs1_output.='<div class="clear"></div>';
        $zs1_output.='<script>
            jQuery(".dzs-gallery-container").masonry({
  itemSelector: ".item"
});</script>';
    }else{

    $zs1_output = '<script type="text/javascript">';


    //VIDEOS
    $zs1_output.="var fv1='";

    

    for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
        $zs1_output.=$zs1_items[$k][$i][0];

        if ($i < count($zs1_items[$k]) - 2)
            $zs1_output.=';';
    }

    //TYPES
    $zs1_output.="';
	var fv2='";

    //TYPES
    for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
        $zs1_output.=$zs1_items[$k][$i][2];
        if ($i < count($zs1_items[$k]) - 2)
            $zs1_output.=';';
    }

    //THUMBS
    $sw1 = false;
    for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++)
        if ($zs1_items[$k][$i][1] != '')
            $sw1 = true;

    $zs1_output.="';
	var fv3='";




        for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
            $sw=false;
            $zs1_output.=$zs1_items[$k][$i][1];
            if($zs1_items[$k][$i][1]!='')
                $sw=true;
            if ($zs1_items[$k][$i][1] == '' && $zs1_items[$k][$i][2] == 'vimeo') {
                
                $imgid = $zs1_items[$k][$i][0];

                $imga = unserialize(@file_get_contents("http://vimeo.com/api/v2/video/$imgid.php"));
                $img = ($imga[0]['thumbnail_small']);

                $zs1_output.=$img;
                $zs1_items[$k][$i][1]=$img;
                $sw=true;
            }
            if ($zs1_items[$k][$i][1] == '' && $zs1_items[$k][$i][2] == 'youtube') {
                $imgid = $zs1_items[$k][$i][0];
                //$zs1_output.="http://img.youtube.com/vi/".$imgid."/2.jpg";
                $zs1_items[$k][$i][1]='http://img.youtube.com/vi/'.$zs1_items[$k][$i][0].'/0.jpg';

                $sw=true;
            }

            if ($i < count($zs1_items[$k]) - 2 && $sw==true)
                $zs1_output.=';';
        }
    




    //TITLES
    $sw1 = false;
    for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++)
        if ($zs1_items[$k][$i][3] != '')
            $sw1 = true;

    $zs1_output.="';
	var fv4='";
    if ($sw1 == true) {

        for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
            $zs1_output.=$zs1_items[$k][$i][3];

            if ($i < count($zs1_items[$k]) - 2)
                $zs1_output.=';';
        }
    }


    //MENU DESCRIPTIONS
    $sw1 = false;
    for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++)
        if ($zs1_items[$k][$i][4] != '')
            $sw1 = true;

    $zs1_output.="';
	var fv5='";
    if ($sw1 == true) {

        for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
            $zs1_output.=$zs1_items[$k][$i][4];

            if ($i < count($zs1_items[$k]) - 2)
                $zs1_output.=';';
        }
    }

    $zs1_output.="'";
    $zs1_output.=';
	var width = ' . $zs1_items[$k][0][1] . ';
		var height =' . $zs1_items[$k][0][2] . ';
		var flashvars = {
		totalWidth:width,
		totalHeight:height,
		autoplay:"' . $zs1_items[$k][0][4] . '",
		autoplayNextVideo:"on",
		menuPosition:"' . $zs1_items[$k][0][3] . '",
                youtubeFeed:"' . $zs1_items[$k][0][6] . '",
                youtubeFeed_user:"' . $zs1_items[$k][0][7] . '",
                youtubeFeed_playlistId:"' . $zs1_items[$k][0][8] . '",
               scrollbar:"' . $zs1_items[$k][0][9] . '",
		video:fv1,
		types:fv2,
		thumbs:fv3,
		titles:fv4,
		menuDescriptions:fv5';
    
    if(isset($zs1_items[$k][0][14])&& $zs1_items[$k][0][14]!='')
        $zs1_output.=',
            defaultVolume:"'.$zs1_items[$k][0][14].'"';
    
    if(isset($zs1_items[$k][0][17])&& $zs1_items[$k][0][17]!='')
        $zs1_output.=',
            suggestedQuality:"'.$zs1_items[$k][0][17].'"';
    
    if(isset($zs1_items[$k][0][18])&& $zs1_items[$k][0][18]=='on'){
        $zs1_output.=',
            designXML:"'.$zs1_path.'deploy/xml/design.xml"';
        $zs1_items[$k][0][5] = 'complete';
    }
    if(isset($zs1_items[$k][0][19])&& $zs1_items[$k][0][19]=='on'){
        $zs1_output.=',
            player_design_disable_description:"on"';
    }
    if(isset($zs1_items[$k][0][20])&& $zs1_items[$k][0][20]=='on'){
        $zs1_output.=',
            settings_deeplinking:"on"';
    }
    if(isset($zs1_items[$k][0][21]) && $zs1_items[$k][0][21]!=''){
        $zs1_output.=',
            menu_scroll_animation_time:' . $zs1_items[$k][0][21];
    }
    

    $zs1_targetswf = "deploy/preview.swf";
    if ($zs1_items[$k][0][5] == 'light')
        $zs1_targetswf = "deploy/preview_skin_overlay.swf";
    if ($zs1_items[$k][0][5] == 'rouge')
        $zs1_targetswf = "deploy/preview_skin_rouge.swf";
    if ($zs1_items[$k][0][5] == 'complete_allchars')
        $zs1_targetswf = "deploy/preview_allchars.swf";
    $c_singlequote = "'";

    //SCRIPT CONTINUE

    if (isset($zs1_items[$k][0][10]) && $zs1_items[$k][0][10] != '') {
        $zs1_output.=',
		cueFirstVideo:"off",
		thumb:"' . $zs1_items[$k][0][10] . '"';
    }
    $zs1_output.='
        };
		var params = {
			menu: "false",
			allowScriptAccess: "always",
			scale: "noscale",
			allowFullScreen: "true",
			wmode:"'.$zs1_items[$k][0][12].'",
			base:' . $c_singlequote . $zs1_path . $c_singlequote . '
		};';
    if ($zs1_items[$k][0][9] == 'on' && $zs1_items[$k][0][3] == 'down')
        $zs1_output.='
            height+=12
            ';
    if ($zs1_items[$k][0][9] == 'on' && $zs1_items[$k][0][3] == 'right')
        $zs1_output.='
            width+=12
            ';
    if (!(isset($_GET['viewAlt']) && $_GET['viewAlt'] == 'true'))
        $zs1_output.='var attributes = {}; 
            swfobject.embedSWF("' . $zs1_path . $zs1_targetswf . '", "flashcontent' . $zs1_nr_sliders . '", width, height, "9.0.0", "expressInstall.swf", flashvars, params, attributes);';
    $zs1_output.='
	jQuery(document).ready(function($){
        if(is_ios()==true || is_android()==true)
        $("#ios-vg' . $zs1_nr_sliders . '").iosgallery();
	})
        </script>
<div id="flashcontent' . $zs1_nr_sliders . '">
    <style>object{ outline:0; }
    .ios-vg{ position:relative; overflow:hidden; }
.ios-vg .videos { position:relative;  padding-left:0; padding:0!important; margin:0!important; border:0!important; }
.ios-vg .videos li { list-style:none;  margin:0important; padding:0 0 0 0!important; padding-left:0; border:0important;  }
.ios-vg .videos-menu { position:absolute; height:100%; overflow-x:hidden; overflow-y:auto; width:200px; top:0; right:0px; margin:0important; padding:0 0 0 0!important; padding-left:0; border:0important;   }
.ios-vg .videos-menu li { list-style:none; width:200px; height:50px; position:relative; background:#333; color:#eee; border-bottom:1px solid #787878; cursor:pointer;}
.ios-vg .videos-menu li:hover {  background:#444; }
.ios-vg .videos-menu li.selected {  background:#555; }
.ios-vg .videos-menu li.selected:hover {  background:#555; }
.ios-vg .videos-menu li > .the-title { position:absolute; left:50px; top:5px; width:150px;  color:#09F; font-weight:bold;  }
.ios-vg .videos-menu li > .the-content { position:absolute; left:50px; top:25px; width:150px; }
.ios-vg .videos-menu li > .the-thumb { position:absolute; left:5px; top:5px; width:40px; height:40px; }
.clearfix {display:block;}
.clearfix:after {content: ".";	display: block;	clear: both;visibility: hidden;line-height: 0;height: 0;}
    </style>
<div class="alternate-content">
<div id="ios-vg' . $zs1_nr_sliders . '" class="ios-vg" style="width:' . $zs1_items[$k][0][1] . 'px; height:' . $zs1_items[$k][0][2] . 'px;">
<ul class="videos">';
$vw = ($zs1_items[$k][0][1] - 200);
if($zs1_items[$k][0][3]=='none'){
    $vw = $zs1_items[$k][0][1];
    $zs1_output.='<style>#ios-vg' . $zs1_nr_sliders . ' .videos-menu{ display:none; }</style>';
}

    for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
        if ($zs1_items[$k][$i][2] == "video")
            $zs1_output.='<li style="width:' . ($vw) . 'px; height:' . ($zs1_items[$k][0][2]) . 'px;"><video width="' . ($vw) . '" height="' . $zs1_items[$k][0][2] . '" controls="" webkit-playsinline><source src="' . $zs1_items[$k][$i][0] . '" /></video></li>';
        if ($zs1_items[$k][$i][2] == "youtube")
            $zs1_output.='<li style="width:' . ($vw) . 'px; height:' . ($zs1_items[$k][0][2]) . 'px;"><iframe width="' . ($vw) . '" height="' . $zs1_items[$k][0][2] . '" src="http://www.youtube.com/embed/' . $zs1_items[$k][$i][0] . '" frameborder="0" allowfullscreen></iframe></li>';
        if ($zs1_items[$k][$i][2] == "vimeo")
            $zs1_output.='<li style="width:' . ($vw) . 'px; height:' . ($zs1_items[$k][0][2]) . 'px;"><iframe src="http://player.vimeo.com/video/' . $zs1_items[$k][$i][0] . '?portrait=0&amp;color=ffffff" width="' . ($vw) . '" height="' . ($zs1_items[$k][0][2]) . '" frameborder="0"></iframe></li>';
        if ($zs1_items[$k][$i][2] == "audio")
            $zs1_output.='<li style="width:' . ($vw) . 'px; height:' . ($zs1_items[$k][0][2]) . 'px;"><audio width="' . ($vw) . '" height="' . $zs1_items[$k][0][2] . '" src="' . $zs1_items[$k][$i][0] . '"></audio></li>';
        if ($zs1_items[$k][$i][2] == "image")
            $zs1_output.='<li style="width:' . ($vw) . 'px; height:' . ($zs1_items[$k][0][2]) . 'px;"><img width="' . ($vw) . '" height="' . $zs1_items[$k][0][2] . '" src="' . $zs1_items[$k][$i][0] . '"/></li>';
        if ($zs1_items[$k][$i][2] == "inline")
            $zs1_output.=$zs1_items[$k][$i][0];
    }
    $zs1_output.='</ul>';
    $zs1_output.='<ul class="videos-menu">';
    for ($i = 1; $i < count($zs1_items[$k]) - 1; $i++) {
        $zs1_output.='<li';
        if($i==1) $zs1_output.=' class="selected"';
        $zs1_output.='><img class="the-thumb" src="' . $zs1_items[$k][$i][1] . '"><div class="the-title">' . $zs1_items[$k][$i][3] . '</div><div class="the-content">' . $zs1_items[$k][$i][4] . '</div></li>';
    }
    $zs1_output.='</ul>';
$zs1_output.='</div>
</div>
<div class="clearfix">&nbsp;</div>
</div>';


    }




    return $zs1_output;
}

function zs1_shortcode_alt($arg) {
    //print_r($arg);
    global $zs1_items;
    global $zs1_output;
    global $zs1_nr_sliders;
    global $zs1_path;

    $zs1_nr_sliders++;


    if ($zs1_items == '')
        return;

    $i = 0;
    $k = 0;


    $current_urla = explode("?", dzs_curr_url());
    $current_url = $current_urla[0];

    $zs1_output = '';
    $zs1_output .= '
<style type="text/css">
.submenu{
margin:0;
padding:0;
list-style-type:none;
list-style-position:outside;
position:relative;
z-index:32;
}

.submenu a{
display:block;
padding:5px 15px;
background-color: #28211b;
color:#fff;
text-decoration:none;
}

.submenu li ul a{
display:block;
width:200px;
height:auto;
}

.submenu li{
float:left;
position:static;
width: auto;
}

.submenu ul, .submenu ul ul{
position:absolute;
width:200px;
top:auto;
display:none;
list-style-type:none;
list-style-position:outside;
}
.submenu ul li{
position:relative;
}

.submenu a:hover{
background-color:#555;
color:#eee;
}

.submenu li:hover ul, .submenu li li:hover ul{
display:block;
}
</style>';

    $zs1_output .= '<ul class="submenu">';
    if (isset($zs1_items))
        for ($k = 0; $k < count($zs1_items); $k++) {
            $zs1_output.='<li><a href="#">' . $zs1_items[$k][0][0] . '</a>';

            if (isset($zs1_items[$k]) && count($zs1_items[$k]) > 1) {

                $zs1_output.='<ul>';
                for ($i = 1; $i < count($zs1_items[$k]); $i++) {
                    if (isset($zs1_items[$k][$i][1]))
                        $zs1_output.='<li><a href="' . $current_url . '?zs1_movie=' . $zs1_items[$k][$i][0] . '&zs1_thumb=' . $zs1_items[$k][$i][1] . '&zs1_type=' . $zs1_items[$k][$i][2] . '&zs1_title=' . $zs1_items[$k][$i][3] . '">' . $zs1_items[$k][$i][3] . '</a>';
                }
                $zs1_output.='</ul>';
            }
            $zs1_output.='</li>';
        }


    $k = 0;
    $i = 1;
    $zs1_output .= '</ul>
<div class="clearfix"></div>
<br>';

    if (isset($_REQUEST['zs1_movie'])) {
        $zs1_output.='<div id="hiddenModalContent" style="display:none">
<p><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="' . $zs1_items[$k][0][1] . '" height="' . $zs1_items[$k][0][2] . '">
        <param name="movie" value="' . $zs1_path . 'deploy/preview.swf?video=' . $_REQUEST['zs1_movie'] . '&types=' . $_REQUEST['zs1_type'] . '" />
        <param name="allowFullScreen" value="true"/>
        <param name="allowScriptAccess" value="always"/>
        <param name="wmode" value="opaque"/>
        <object type="application/x-shockwave-flash" data="' . $zs1_path . 'deploy/preview.swf?video=' . $_REQUEST['zs1_movie'] . '&types=' . $_REQUEST['zs1_type'] . '" width="' . $zs1_items[$k][0][1] . '" height="' . $zs1_items[$k][0][2] . '" allowFullScreen="true" allowScriptAccess="always" wmode="opaque">
        <video width="300" height="200" src="' . $zs1_items[$k][$i][0] . '"></video></object>
</object></p>
</div>';
        $inline_thumb = '<img width="320" height="240" src="' . $_REQUEST['zs1_thumb'] . '" alt="You can set a image here via the Thumb field."/>';
        if ($_REQUEST['zs1_type'] == "youtube")
            $inline_thumb = '<img width="320" height="240" src="http://img.youtube.com/vi/' . $_REQUEST['zs1_movie'] . '/0.jpg" alt="You can set a image here via the Thumb field."/>';

        $zs1_output.='<a href="#TB_inline?height=' . ($zs1_items[$k][0][2] + 10) . '&width=' . ($zs1_items[$k][0][1] + 10) . '&inlineId=hiddenModalContent&modal=false" title="' . $_REQUEST['zs1_title'] . '" class="thickbox">' . $inline_thumb . '</a>
';
    }



    return $zs1_output;
}

//on ADMIN HEAD
function zs1_admin_head() {


    global $zs1_path;
?>
    <script>window.zs1_path= "<?php echo $zs1_path; ?>";</script>

<?php
}

//on ADMIN MENU
function zs1_admin_menu() {
    global $zs1_capability;

    $zs1_page = add_options_page('DZS Zoom Video Gallery', 'DZS Video Gallery', $zs1_capability, 'zs1_menu', 'zs1_menu_function');
}

function zs1_menu_function() {
    global $zs1_path;
    global $zs1_items;
    //print_r($zs1_items);
?>
    <noscript>You need Javascript enabled to see the admin panel.</noscript>
    <div class="wrap">
        <h2>Zoom Video Gallery Admin Panel <img alt="" style="visibility: visible;" id="main-ajax-loading" src="<?php bloginfo('wpurl'); ?>/wp-admin/images/wpspin_light.gif"></h2>

        <div class="import-export-db-con">
            <div class="the-toggle"></div>
            <div class="the-content-mask" style="overflow:hidden; height: 0px; position:relative;">
                <div class="arrow-up"></div>
            <div class="the-content">
                <h3>Export Database</h3>
        <form action="" method="POST"><input type="submit" name="zs1_export" value="Export"/></form>
                <h3>Import Database</h3>
        <form enctype="multipart/form-data" action="" method="POST">
<input type="hidden" name="MAX_FILE_SIZE" value="100000" />
File Location: <input name="dzs_uploadfile" type="file" /><br />
<input type="submit" name="zs1_uploadfile_confirm" value="Import" />
</form>
        </div>
        </div>
            </div>
        
        <button class="button-secondary action kb-button-help-bot">Help!</button>
        <a href="<?php echo $zs1_path; ?>deploy/designer/index.php" target="_blank" class="button-secondary action">Go to Designer Center</a>
        <br />
        <br />

        <table class="widefat widefat-fixed"><thead><tr><th class="manage-column column-title column-title-fixed">Title [ ID ]</th><th>Edit</th><th>Duplicate</th><th>Delete</th></tr></thead>
            <tbody class="zs-tbody">
            </tbody></table>

        <br />

        <button class="button-secondary action kb-button-add-slider">Add Gallery</button><br />

        <br />
        <div class="zs-slider-container">
        </div><!--end slider-container-->

        <p><button class="button-primary action kb-button-save">Save Settings</button><img alt="" style="visibility: hidden;" id="save-ajax-loading" src="<?php bloginfo('wpurl'); ?>/wp-admin/images/wpspin_light.gif"></p>
    </div>

    <script type="text/javascript">
        jQuery(document).ready(function($) {

            //in admin-main.js
            jQuery('.kb-button-save').click(zs_sendGallery);
            dzs_ready();

            zs_addSliders(<?php if ($zs1_items != "")
        echo (count($zs1_items)); ?>);


                jQuery('.kb-button-add-slider').click(function(){
                    zs_addSliders(1);
                })
                jQuery('.kb-button-help-bot').click(function(){

                    tb_show("Ken Burns - Readme","<?php echo $zs1_path; ?>readme/index.html?width=650&height=700",null);
                })



<?php
    $i = 0;

    if ($zs1_items != "") {


        for ($i = 0; $i < count($zs1_items); $i++) {
            echo "zs_addItems(" . $i . "," . (count($zs1_items[$i]) - 2) . ");";
        }
    }
?>

        setTimeout(zs1_checkItemHandler,1000);


    });



    function zs1_checkItemHandler(){

        jQuery('#main-ajax-loading').css('visibility', 'hidden');
<?php
    $i = 0;
    $j = 0;
    $k = 0;

    if ($zs1_items != "") {


        for ($i = 0; $i < count($zs1_items); $i++) {
            echo "zs_checkSlider(" . $i . ", '" . $zs1_items[$i][0][0] . "');\n";
            for ($j = 0; $j < count($zs1_items[$i]); $j++) {
                for ($k = 0; $k < count($zs1_items[$i][$j]); $k++) {


                    $aux = $zs1_items[$i][$j][$k];
                    $aux = str_replace("\n", " ", $aux);
                    echo "zs_checkItem(" . $i . "," . $j . "," . $k . ",'" . $aux . "');\n";
                }
            }
        }//end for i

        echo "zs_showSlider(0)";
    }
?>
    }





    </script>
<?php
}

function zs1_saveItems() {
    global $wpdb; // this is how you get access to the database

    $i = 0;
    $j = 0;
    $k = 0;


    $mainOptionsArray = array();
    $secondaryOptionsArray = array();

    $arrayTemp = $_POST['arrayMain'];
    $arraySliders = explode('&.', $arrayTemp);



    for ($i = 0; $i < count($arraySliders); $i++) {
        $secondaryOptionsArray = array();
        $arrayItemsAux = explode('&;', $arraySliders[$i]);

        for ($j = 0; $j < count($arrayItemsAux); $j++) {
            $arraySettingsAux = explode('&,', $arrayItemsAux[$j]);
            array_push($secondaryOptionsArray, $arraySettingsAux);
        }//end j

        array_push($mainOptionsArray, $secondaryOptionsArray);
    }//end i

    print_r($mainOptionsArray);

    if ($mainOptionsArray[0][0][0] == '')
        update_option('zs1_items', '');
    else
        update_option('zs1_items', $mainOptionsArray);


    die();
}

function zs1_unnistall() {
    update_option('zs1_items', '');
}
if(!function_exists('dzs_curr_url')){
function dzs_curr_url() {
    if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on'){
        $page_url .= "https://";
    }else{
        $page_url = 'http://';
    }
    if ($_SERVER["SERVER_PORT"] != "80") {
        $page_url .= $_SERVER["SERVER_NAME"] . ":" . $_SERVER["SERVER_PORT"] . $_SERVER["REQUEST_URI"];
    } else {
        $page_url .= $_SERVER["SERVER_NAME"] . $_SERVER["REQUEST_URI"];
    }
    return $page_url;
}
}
require_once("widget.php");

$zs1 = new DZSVideoGallery();
class DZSVideoGallery{
    function __construct(){
        add_shortcode('vimeo', array($this, 'vimeo_func'));
        add_shortcode('youtube', array($this, 'youtube_func'));
        add_shortcode('video', array($this, 'video_func'));
    }
    function vimeo_func($atts) {
        $func_output='';
        $w=400;
        if(isset($atts['width'])) $w=$atts['width'];
        $h=300;
        if(isset($atts['height'])) $h=$atts['height'];
        $func_output.='<iframe src="http://player.vimeo.com/video/'.$atts['id'].'?title=0&amp;byline=0&amp;portrait=0" width="'.$w.'" height="'.$h.'" frameborder="0"></iframe>';
        return $func_output;
    }
    
    function youtube_func($atts) {
        $func_output='';
        $w=400;
        if(isset($atts['width'])) $w=$atts['width'];
        $h=300;
        if(isset($atts['height'])) $h=$atts['height'];
        $func_output.='<object width="'.$w.'" height="'.$h.'"><param name="movie" value="http://www.youtube.com/v/'.$atts['id'].'?version=3&amp;hl=en_US"></param><param name="wmode" value="transparent"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/'.$atts['id'].'?version=3&amp;hl=en_US" type="application/x-shockwave-flash" width="'.$w.'" height="'.$h.'" allowscriptaccess="always" wmode="transparent" allowfullscreen="true"></embed></object>';
        return $func_output;
    }
    function video_func($atts) {
        global $zs2_path;
        $func_output='';
        $w=400;
        if(isset($atts['width'])) $w=$atts['width'];
        $h=300;
        if(isset($atts['height'])) $h=$atts['height'];
        $source=$zs2_path.'deploy/preview.swf?video='.$atts['source'];
        if(isset($atts['type'])) $source.='&types='.$atts['type'];
        if(isset($atts['audioimage'])) $source.='&audioImages='.$atts['audioimage'];
        $func_output.='<object width="'.$w.'" height="'.$h.'">
            <param name="movie" value="'.$source.'"></param>
            <param name="allowFullScreen" value="true"></param>
            <param name="allowscriptaccess" value="always"></param>
            <param name="wmode" value="opaque"></param>
            <embed src="'.$source.'" type="application/x-shockwave-flash" width="'.$w.'" height="'.$h.'" allowscriptaccess="always" allowfullscreen="true" wmode="opaque">
            </embed></object>';

        return $func_output;


    }
}

if($zs1_ispreview=='on')
add_filter( 'the_content', 'zs1_add_preview' );

function zs1_add_preview($content){
    $aux = '<div class="preseter"><div class="the-icon"></div>
    <div class="the-content"><h3>Preseter</h3>
    <div class="sidenote">Just a few of the options of the real gallery, that you can customise to see how it looks, right here in the preview!</div>
    <form method="GET">
    <div class="setting">
    <div class="alabel">Width:</div>
    <input type="text" name="opt1" value="900"/>
    </div>
    <div class="setting">
    <div class="alabel">Height:</div>
    <input type="text" name="opt2" value="300"/>
    </div>
    <div class="setting">
    <div class="alabel">Menu Position:</div>
    <div class="select-wrapper"><span>down</span><select name="opt3" class="textinput short"><option>down</option><option>right</option><option>up</option><option>left</option><option>none</option></select></div>
    </div>
    <div class="setting">
    <div class="alabel">Autoplay:</div>
    <div class="select-wrapper"><span>on</span><select name="opt4" class="textinput short"><option>on</option><option>off</option></select></div>
    </div>
    <div class="setting">
    <div class="alabel">YouTube Feed:</div>
    <div class="select-wrapper"><span>off</span><select name="opt5" class="textinput short"><option>off</option><option>on</option></select></div>
    </div>
    <div class="setting">
    <div class="alabel">YouTube Feed User:</div>
    <input type="text" name="opt6" value="digitalzoomstudio"/>
    </div>
    <input type="submit" class="button-primary send-btn" value="Submit"/>
    </form>
    </div><!--end the-content-->
    </div><!--end preseter-->';
    
    $content = $aux . $content;
    return $content;
}