<?php 
if( !defined( 'ABSPATH') && !defined('WP_UNINSTALL_PLUGIN') )
	exit();

global $wpdb;
$sliders_table = $wpdb->prefix . 'royalsliders';
$wpdb->query( "DROP TABLE $sliders_table" );

?>