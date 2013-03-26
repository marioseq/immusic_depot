<?php

/*-----------------------------------------------------------------------------------*/
/* Start WooThemes Functions - Please refrain from editing this section */
/*-----------------------------------------------------------------------------------*/

// Set path to WooFramework and theme specific functions
$functions_path = get_template_directory() . '/functions/';
$includes_path = get_template_directory() . '/includes/';

// WooFramework
require_once ($functions_path . 'admin-init.php' );			// Framework Init

// Theme specific functionality
require_once ($includes_path . 'theme-options.php' ); 		// Options panel settings and custom settings
require_once ($includes_path . 'theme-functions.php' ); 	// Custom theme functions
require_once ($includes_path . 'theme-plugins.php' );		// Theme specific plugins integrated in a theme
require_once ($includes_path . 'theme-actions.php' );		// Theme actions & user defined hooks
require_once ($includes_path . 'theme-comments.php' ); 		// Custom comments/pingback loop
require_once ($includes_path . 'theme-js.php' );			// Load javascript in wp_head
require_once ($includes_path . 'sidebar-init.php' );		// Initialize widgetized areas
require_once ($includes_path . 'theme-widgets.php' );		// Theme widgets
require_once ($includes_path . 'woo-column-generator/woo-column-generator.php' ); // Button to generate content columns

/*-----------------------------------------------------------------------------------*/
/* You can add custom functions below */
/*-----------------------------------------------------------------------------------*/
remove_filter( 'the_content', 'wpautop' );
remove_filter( 'the_excerpt', 'wpautop' );
remove_filter( 'comment_text', 'wpautop', 30 );

/*-----------------------------------------------------------------------------------*/
/* Don't add any code below here or the sky will fall down */
/*-----------------------------------------------------------------------------------*/
?>