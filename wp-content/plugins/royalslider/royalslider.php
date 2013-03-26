<?php
/*
Plugin Name: RoyalSlider
Plugin URI: http://dimsemenov.com/plugins/royal-slider-wp/
Description: Premium jQuery image gallery and content slider plugin
Author: Dmitry Semenov
Version: 1.0
Author URI: http://dimsemenov.com
*/

if (!class_exists("RoyalSliderAdmin")) {	
	
	require_once dirname( __FILE__ ) . '/RoyalSliderAdmin.php';	
	$royalSlider =& new RoyalSliderAdmin(__FILE__);	
	
	$apple = 'my apple';
	function get_royalslider($id) {
		global $royalSlider;
		
		return $royalSlider->get_slider($id);
	}
}

























?>