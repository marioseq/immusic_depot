<?php
	global $post, $woo_options;
	
		$settings = array( 'tag' => '', 'number' => 4 );
		$query_args = array(
							'post_type' => 'post', 
							'suppress_filters' => true
							);
		
		// Load our settings from the "Theme Options".
		foreach ( $settings as $k => $v ) {
			if ( isset( $woo_options['woo_header_left_headlines_' . $k] ) ) {
				$settings[$k] = $woo_options['woo_header_left_headlines_' . $k];
			}
		}
		
		$query_args['numberposts'] = $settings['number'];
		
		if ( $settings['tag'] != '' ) {
			$query_args['tag'] = $settings['tag'];
		}
		
		$headlines = get_posts( $query_args );
		
		$saved_post = $post;
		
		if ( count( $headlines ) > 0 ) {
	?>
	
	<ul id="headlines">
	<?php
			$date_format = get_option( 'date_format' );
			foreach ( $headlines as $post ) {
				setup_postdata( $post );
				
				$categories_obj = get_the_category( $post->ID );
				$prepared_categories = array();
				$the_category = '';
				
				if ( count( $categories_obj ) && ! is_wp_error( $categories_obj ) ) {
					foreach ( $categories_obj as $c ) {
						$prepared_categories[] = '<a href="' . get_term_link( $c->slug, 'category' ) . '">' . apply_filters( 'esc_attr', $c->name ) . '</a>';
					}
					
					$the_category = $prepared_categories[0];
				}
	?>
		<li class="headline-id-<?php echo $post->ID; ?>">
			<span class="meta"><?php the_time( $date_format ); ?></span>
			<span class="headline-title"><a href="<?php the_permalink( $post->ID ); ?>" title="<?php the_title_attribute(); ?>"><?php the_title(); ?></a></span>
			<span class="category"><?php echo $the_category; ?></span>
			<span class="comments"><?php comments_popup_link( '0', '1', '%' ); ?></span>
		</li>
	<?php
			}
	?>
	</ul>
<?php
		}
		
		$post = $saved_post;
?>