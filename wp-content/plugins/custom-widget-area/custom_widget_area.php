<?php
/**
Plugin Name: Custom Widget Area
Plugin URI: http://wordpress.opensourcedevelopers.net/downloads/
Description: A simple plugin to create custom widget area.
Author: Shakti Kumar
Version: 1.1
Author URI: http://opensourcedevelopers.net/
 */
 
register_sidebar( array(
		'name' => __( 'Header Widget Area', 'Business' ),
		'id' => 'header-area',
		'description' => __( 'The header widget area', 'Business' ),
		'before_widget' => '<li id="%1$s" class="widget-container %2$s">',
		'after_widget' => '</li>',
		'before_title' => '<h3 class="widget-title">',
		'after_title' => '</h3>',
	) );
