<div class='royalslider-admin wrap'>
	<h2 id="edit-slider-text">Edit RoyalSlider<?php 
		if($_GET['id'] > -1) {
			echo ' #' . $_GET['id'];
		}
	?></h2>
	<div id="poststuff" class="metabox-holder has-right-sidebar">

		<div id="side-info-column" class="options-sidebar">
			<div class="postbox action actions-holder">								
				<a class="alignleft button-secondary button80" id="preview-slider" href="#">Preview Slider</a>
				
					<div id="save-progress" class="waiting ajax-saved" style="background-image: url(<?php echo esc_url( admin_url( 'images/wpspin_light.gif' ) ); ?>)" >
					</div>
					<a class="alignright button-primary button80" id="save-slider" href="#">Save Slider</a>		
				
				<br class="clear">				
			</div>
			
						
			<div id="royalslider-options" class="meta-box-sortables ui-sortable"><?php include('royalslider-sidebar-options.php');  ?></div>		
		</div>
		<div class="sortable-slides-body">								
			<div class="sortable-slides-container">
				<div id="titlediv">
					<div id="titlewrap">						
						<input type="text" name="title" size="40" maxlength="255" placeholder="Type slider name here" id="title" />
					</div>
				</div>

				<div id="sortable-slides-boxes" class="meta-box-sortables ui-sortable">
					
					<form id="slides">
					<?php						
						
						if ($this->current_action == 'edit') {							
							
							if(isset($_GET['id'])) {
								$id = intval($_GET['id']);
								if ($id <= 0)
									die ('Incorrect ID 1007');
							}
								
							global $wpdb;
							$sliders_table = $wpdb->prefix . 'royalsliders';
								
							$slider = $wpdb->get_row("SELECT * FROM $sliders_table WHERE id = $id", ARRAY_A);
								
							echo '<div id="royal-slider-data" data-preload-skin="' . $slider['preload_skin'] . '" data-skin="'. $slider['skin'] .'" data-name="' . $slider['name'] . '" data-id="' . $id . '" style="display:none">';
							echo stripslashes($slider['body']);
							echo '</div>';
							echo '<div id="royal-slider-settings-data"  style="display:none">' . stripslashes($slider['settings']) . '</div>';
							
						} else {							
							echo '<div id="royal-slider-data" style="display:none">'; 
							echo '<div id="myGallery1" class="royalSlider default"><ul class="royalSlidesContainer"><li class="royalSlide"></li></ul></div>';
							echo '</div>';
						}
							
                    ?>
                    </form>
                   
				</div> 
				<p>
					<a id="add-new-slide-button" class="alignleft button-secondary button80" href="#">Add a New Slide</a>	
				</p>
			</div>
		</div>
	</div>
</div>