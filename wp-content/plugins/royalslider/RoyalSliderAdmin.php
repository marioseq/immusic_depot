<?php


class RoyalSliderAdmin {
	/* 
	 * Slider skins:
	 * 'skinClass' => 'Skin name in admin'
	 * 
	 * Put new skins in:
	 * css/royalslider-skins/skinClass/skinClass.css
	 * 
	 * */
	var $skins = array(
			'default' => 'Default B&W',			
			'iskin' => 'iSkin',
			'minimal' => 'Minimal White'
	);
	
	
	
	
	var $main;	
	var $name = "";
	var $url = "";
	var $path = "";
	
	var $current_action;
	var $current_id;
	var $current_slider;
	var $current_slides;
	
	
	
	

	var $styles_to_load = array();
	var $scripts_to_load = array();
	
	
	
	function __construct($main) {
		$this->main = $main;
		$this->init();		
		return $this;		
	}
	
	function init() {
		$this->path = dirname( __FILE__ );
		$this->name = basename( $this->path );
		$this->url = plugins_url( "/{$this->name}/" );
		
		if (!load_plugin_textdomain($this->name,'/wp-content/languages/')) {
			load_plugin_textdomain($this->name, null, "{$this->path}/lang");
		}
		
		
		if( is_admin() ) {
			add_action('wp_ajax_royalSliderSave', array(&$this, 'save_slider') );
			
			register_activation_hook( $this->main , array(&$this, 'activate') );
			

			add_action( 'admin_init', array(&$this, 'admin_init') );
			add_action( 'admin_menu', array(&$this, 'admin_menu') );	
			
			
			
		} else {			
			add_action('wp', array(&$this, 'frontend_styles_and_scripts'));		
			add_shortcode('royalslider', array(&$this, 'shortcode') );
		}
		
			
	}
	
	
	/**
	* Activate RoyalSlider
	*/
	function activate() {
		global $wpdb;
	
		$table_name = $wpdb->prefix . 'royalsliders';
	
		if ($wpdb->get_var("SHOW TABLES LIKE '$table_name'") != $table_name) {
			$royal_sliders_sql = "CREATE TABLE " . $table_name ." (
						  id mediumint(9) NOT NULL AUTO_INCREMENT,					  
						  name tinytext NOT NULL,
						  skin tinytext NOT NULL,
						  preload_skin TINYINT(1) NOT NULL,
						  settings text NOT NULL,	
						  body text NOT NULL,							  
						  PRIMARY KEY (id)
						);";	
	
			require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
			dbDelta($royal_sliders_sql);			
		}
	
	}	
	/**
	* RoyalSlider shortcode
	*/
	function shortcode($atts, $content = null) {
		extract(shortcode_atts(array(
				"id" => '-1'
		), $atts));
		return do_shortcode($this->get_slider($id));
	}	
	/**
	 * Admin menu item
	 */
	function admin_menu() {		
		$main_page = add_menu_page( 'RoyalSlider', 'RoyalSlider', 'manage_options', 'royalslider', array(&$this, 'admin_page') );
	
		add_action( 'admin_print_styles-' . $main_page, array(&$this, 'admin_page_styles') );		
		add_action( 'admin_print_scripts-'. $main_page, array(&$this, 'admin_page_scripts') );		
	}
	function admin_init() {			
		// register styles and scripts used in admin
		wp_register_style( 'royalslider-admin-css', $this->url . 'css/royalslider-admin.css' );		
		wp_register_style( 'royalslider-frontend-css', $this->url .'css/royalslider.css' );		
		
		wp_register_style( 'royalslider-jquery-ui-css', $this->url . 'css/jquery-ui.css' );
		
		wp_register_style( 'jquery-qtip-css', $this->url .'js/qtip/jquery.qtip.css' );
		
		wp_register_script( 'royalslider-admin-js', $this->url .'js/royalslider-admin.js' );
		wp_register_script( 'jquery-url-parser', $this->url .'js/jquery.url.min.js' );
		wp_register_script( 'form2object', $this->url .'js/form2object.js' );
		
		wp_register_script( 'jquery-qtip-js', $this->url .'js/qtip/jquery.qtip.min.js' );
		
		wp_register_script( 'jquery-easing-js', $this->url .'js/jquery.easing.1.3.min.js' );
		wp_register_script( 'royalslider-js', $this->url .'js/royal-slider-7.5.min.js' );
	}
	/**
	 * Add CSS styles only to RoyalSlider admin pages
	 */
	function admin_page_styles() {				
		wp_enqueue_style( 'royalslider-jquery-ui-css' );
		wp_enqueue_style( 'jquery-qtip-css' );
		wp_enqueue_style( 'thickbox' );
		
		wp_enqueue_style( 'royalslider-admin-css' );
		wp_enqueue_style( 'royalslider-frontend-css' ); 
		
		foreach($this->skins as $skin => $skinName) {
			wp_register_style( 'royalslider-skin-' . $skin, $this->url . 'css/royalslider-skins/' . $skin . '/' . $skin . '.css' );
			wp_enqueue_style( 'royalslider-skin-' . $skin );
		}
	}

	/**
	 * Add scripts only to RoyalSlider admin pages
	 */
	function admin_page_scripts() {				
		wp_enqueue_script('jquery-ui-core');
		wp_enqueue_script('jquery-ui-sortable');
		wp_enqueue_script('jquery-ui-selectable');
		wp_enqueue_script('jquery-ui-resizable');
		wp_enqueue_script('jquery-ui-tabs');
		wp_enqueue_script('jquery-ui-dialog');		
		
		wp_enqueue_script('media-upload');
		wp_enqueue_script('thickbox');
			
		wp_enqueue_script( 'form2object' );
	
		wp_enqueue_script( 'jquery-qtip-js' );
		
		wp_enqueue_script( 'royalslider-admin-js' );
		
		wp_enqueue_script( 'jquery-easing-js' );
		
		wp_enqueue_script( 'royalslider-js' );
		
		wp_localize_script( 'royalslider-admin-js', 'royalslider_ajax_vars', array(
							'ajaxurl' => admin_url( 'admin-ajax.php' ),
							'royalslider_ajax_nonce' => wp_create_nonce( 'royalslider_ajax_nonce' ),							
							'pluginurl' => $this->url
		));	
	}
	
	function frontend_styles_and_scripts() {		
		if(!is_admin()) {
			global $posts;
			global $wpdb;
			$sliders_table = $wpdb->prefix . 'royalsliders';
			
			$matches = array();
			$pattern = get_shortcode_regex();
			
			
			// find shortcode in current post
			if (isset($posts) && !empty($posts)) {
				foreach($posts as $post) {
					preg_match_all('/' . $pattern . '/s', $post->post_content, $matches);
					foreach($matches[2] as $key => $value) {
						
						if($value == 'royalslider') {							
							
							$atts = explode(" ", $matches[3][$key]);
								
							foreach($atts as $att) {
								$a = explode("=", $att);
								if($a[0] == 'id' || $a[0] == 'ID') {
									$id = str_replace(array("\"", "'"), "", $a[1]);
									
									$id = intval($id);
									if ($id <= 0)
										die ('Incorrect ID 1006');									
								
									$slider_row =  $wpdb->get_row("SELECT * FROM $sliders_table WHERE id = $id", ARRAY_A);
									if(!in_array($slider_row['skin'], $this->styles_to_load)) {										
										array_push($this->styles_to_load, $slider_row['skin']);
									}
								}
								
							}							
						}
					}
				}
			} 
			
			// find all all sliders where preload_skins is true
			$slider_skins_preload = $wpdb->get_results("SELECT skin FROM " . $sliders_table . " WHERE preload_skin=1", ARRAY_A);	
			foreach($slider_skins_preload as $slider_skin) {
				if (!in_array($slider_skin['skin'], $this->styles_to_load)) {
					array_push($this->styles_to_load, $slider_skin['skin']);
				}
			}
			
			if(count($this->styles_to_load) > 0) {
				wp_register_style( 'royalslider-frontend-css', $this->url .'css/royalslider.css' );
				wp_enqueue_style( 'royalslider-frontend-css' );
					
				// Load only needed skins
				foreach($this->styles_to_load as $skin) {
					wp_register_style( 'royalslider-skin-' . $skin, $this->url . 'css/royalslider-skins/' . $skin . '/' . $skin . '.css' );
					wp_enqueue_style( 'royalslider-skin-' . $skin );
				}
				
				wp_register_script( 'royalslider-js', $this->url .'js/royal-slider-7.5.min.js',array("jquery"),"1.0",false);
				wp_enqueue_script( 'royalslider-js' );
				
				wp_register_script( 'jquery-easing-js', $this->url .'js/jquery.easing.1.3.min.js' );
				wp_enqueue_script( 'jquery-easing-js' );				
			}
			
		}
	}
	
	function admin_page() {
		if(!is_admin() ||  !current_user_can("manage_options"))
			die( 'Not allowed' );
		
		if (isset($_GET['action']) ) {			
			$this->current_action = $_GET['action'];		
		}
		if (isset($_GET['id']) ) {
			$this->current_id = intval($_GET['id']);
			if ($this->current_id <= 0) 
				die ('Incorrect ID 1003');			
		}
		
		
		
		
		global $wpdb;
		
		
		if($this->current_action == 'delete' || 
			$this->current_action == 'edit' || 
			$this->current_action == 'duplicate' || 
			$this->current_action == 'add_new') {			
			
			
			if($this->current_action == 'edit') {				
				include_once($this->path . '/pages/royalslider-edit-slider-page.php');
			} else if($this->current_action == 'create') {
				include_once($this->path . '/pages/royalslider-edit-slider-page.php');
			}
			else if ($this->current_action == 'delete') {
				if ( ! wp_verify_nonce( $_GET['_wpnonce'], 'royalslider_delete_nonce') ) 
					die( 'Security check 1008' );				
							
				$wpdb->query( "DELETE FROM " . $wpdb->prefix . "royalsliders WHERE id = $this->current_id" );					
				include_once($this->path . '/pages/royalslider-manage-sliders-page.php');
				
			} else if ($this->current_action == 'duplicate') {
				if ( ! wp_verify_nonce( $_GET['_wpnonce'], 'royalslider_duplicate_nonce') )
					die( 'Security check 1009' );				
				
				$sliders_table = $wpdb->prefix . 'royalsliders';				
				$slider_row = $wpdb->get_row("SELECT * FROM $sliders_table WHERE id = $this->current_id", ARRAY_A);				
			
				$wpdb->insert(
					$sliders_table,
					array(
						'name'=>$slider_row['name'],
						'settings'=>$slider_row['settings'],
						'body'=>$slider_row['body'],
						'skin'=>$slider_row['skin'],
						'preload_skin'=>$_POST['preload_skin']						
					),
					array(
						'%s',
						'%s',
						'%s',
						'%s',
						'%d'						
					)
				);			
				
				include_once($this->path . '/pages/royalslider-manage-sliders-page.php');
			} else if($this->current_action == 'add_new') {
				include_once($this->path . '/pages/royalslider-edit-slider-page.php');
			} 
		} else {
			include_once($this->path . '/pages/royalslider-manage-sliders-page.php');			
		}		
		
	}	
	
	/* returns slider html and js embed code */
	function get_slider($id) {
		$slider_html = '';
		
		
		$id = intval($id);
		if ($id <= 0)
			die ('Incorrect ID 1004');	
		
		
		global $wpdb;		
		$sliders_table = $wpdb->prefix . 'royalsliders';
		$slider_row = $wpdb->get_row("SELECT * FROM $sliders_table WHERE id = $id", ARRAY_A);						
		
				
		
		if($slider_row) {
			$slider_html .= stripslashes($slider_row['body']);
			
		} else {
			$slider_html = "<p>Slider with ID $id is not found</p>";			
		}
		
		$slider_settings = stripslashes($slider_row['settings']);
		
		$slider_js = "";
		$slider_js .= "<script type=\"text/javascript\">";
		$slider_js .= "jQuery(document).ready(function() {";
		$slider_js .= "jQuery(\"#royalslider-$id\").royalSlider(";			
		$slider_js .= $slider_settings;		
		$slider_js .= ");";
		$slider_js .= "});";
		$slider_js .= "</script>";
		
		$slider_html .= $slider_js;
		
		return $slider_html;
	}

	/* save slider to database */
	function save_slider() {
		if ( !current_user_can("manage_options") || !wp_verify_nonce( $_POST['royalslider_ajax_nonce'], 'royalslider_ajax_nonce' ) ) 
			die ( 'This action is not allowed!' );		
		
		
		global $wpdb;		
		$sliders_table = $wpdb->prefix . 'royalsliders';		
		
		if($_POST['action'] == 'royalSliderSave') {		
			if (isset($_POST['id']) ) {
				$id = intval($_POST['id']);				
			}
			
			// insert new slider
			if( $id <= 0 ) {
				
				$slider_content = $_POST['body'];			
				
				
				$wpdb->insert(
					$sliders_table,
					array(
						'name'=>$_POST['name'],
						'settings'=>$_POST['settings'],
						'body'=>$slider_content,
						'skin'=>$_POST['skin'],
						'preload_skin'=>$_POST['preload_skin']						
					),
					array(
						'%s',
						'%s',
						'%s',
						'%s',
						'%d'						
					)
				);
				$insert_id = $wpdb->insert_id;
				
				$new_content = str_replace("royalslider-no-slider-id-set", "royalslider-".$insert_id , $slider_content);
				
				$wpdb->update(
					$sliders_table,
					array( 'body'=>$new_content ),
					array( 'id' => $insert_id ),
					array( '%s' ),
					array( '%d' )
				);
				
				
				echo $insert_id;
				
			} else { // update existing slider
				$wpdb->update(
					$sliders_table,
					array(
						'name'=>$_POST['name'],
						'settings'=>$_POST['settings'],
						'body'=>$_POST['body'],
						'skin'=>$_POST['skin'],
						'preload_skin'=>$_POST['preload_skin']						
					),
					array( 'id' => $id ),
					array(
						'%s',
						'%s',
						'%s',
						'%s',
						'%d'						
					),
					array( 
						'%d' 
					)
				);				
				echo $id;
				
			}
			die();
		}		
	}	
}


?>