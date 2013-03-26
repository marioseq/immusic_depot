<div class='royalslider-admin wrap'>
	<h2>RoyalSlider&#39;s
		<a href='<?php echo admin_url( "admin.php?page=royalslider&action=add_new" ); ?>' class='add-new-h2'>Add New</a>
	</h2>
	<?php 
		global $wpdb;
		if ($_GET['action'] == 'delete') {
			echo '<div id="message" class="updated below-h2"><p>Slider #'.$_GET['id'].' deleted.</p></div>';
		} else if($_GET['action'] == 'duplicate') {
			echo '<div id="message" class="updated below-h2"><p>Slider #'.$_GET['id'].' duplicated. New slider #' . $wpdb->insert_id . ' created.</p></div>';
		}
	?>
	<table class='royalsliders-table wp-list-table widefat fixed'>
		<thead>
			<tr>
				<th width='5%'>ID</th>
				<th width='50%'>Name</th>
				<th width='30%'>Actions</th>
				<th width='20%'>Shortcode</th>						
			</tr>
		</thead>
		<tbody>
			<?php 
				
				$prefix = $wpdb->prefix;
				$sliders = $wpdb->get_results("SELECT * FROM " . $prefix . "royalsliders ORDER BY id");
				if (count($sliders) == 0) {
					echo '<tr>'.
							 '<td colspan="100%">No RoyalSlider\'s found.</td>'.
						 '</tr>';
				} else {
					$slider_display_name;
					foreach ($sliders as $slider) {
						
						$slider_display_name = $slider->name;
						if(!$slider_display_name) {
							$slider_display_name = 'RoyalSlider #' . $slider->id . ' (no name)';
						}
						echo '<tr>'.
								'<td>' . $slider->id . '</td>'.								
								'<td>' . '<a href="' . admin_url('admin.php?page=royalslider&action=edit&id=' . $slider->id) . '" title="Edit">'.$slider_display_name.'</a>' . '</td>'.
								'<td>' . '<a href="' . admin_url('admin.php?page=royalslider&action=edit&id=' . $slider->id) . '" title="Edit this item">Edit</a> | '.									  
									  '<a id="delete-rslider" href="' . wp_nonce_url( admin_url('admin.php?page=royalslider&action=delete&id='  . $slider->id), 'royalslider_delete_nonce') . '" title="Delete slider permanently" >Delete</a> | '.
									  '<a href="' . wp_nonce_url( admin_url('admin.php?page=royalslider&action=duplicate&id='  . $slider->id), 'royalslider_duplicate_nonce') . '" title="Duplicate slider">Duplicate</a>'.
								'</td>'.
								'<td>[royalslider id="' . $slider->id . '"]</td>'.															
							'</tr>';
					}
				}
			?>
		</tbody>		 
	</table>

	
	<p>			
		<a class='button-primary' href='<?php echo admin_url( "admin.php?page=royalslider&action=add_new" ); ?>'>Create New Slider</a>       
	</p>    		
    
</div>
