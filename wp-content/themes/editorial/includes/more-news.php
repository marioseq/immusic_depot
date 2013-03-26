<?php 
	add_filter( 'excerpt_length', 'woo_more_news_excerpt_length' ); // Change the "more news" post excerpt length.

	global $woo_options, $wp_query, $post, $exclude_from_morenews;
	$woo_slider_tags = $woo_options['woo_homepage_tags'];
	$woo_slider_entries = $woo_options['woo_homepage_morenews_totalposts'];
	$per_row = 6;
	$image_width = 40;
	$image_height = 40;
	$image_align = 'alignleft';
	$display_images = 'true';
	
	// Make sure the dynamic values override our defaults, if available.
	foreach ( array( 'image_width' => 'woo_morenews_thumb_w', 'image_height' => 'woo_morenews_thumb_h', 'image_align' => 'woo_morenews_thumb_align', 'display_images' => 'woo_morenews_display_image' ) as $k => $v ) {
		if ( isset( $woo_options[$v] ) && $woo_options[$v] != '' ) {
			${$k} = $woo_options[$v];
		}
	}
	
	// Arguments for getting the posts for the more news section.
	$args = array( 'posts_per_page' => 6 );
	
	if ( is_numeric( $woo_slider_entries ) && $woo_slider_entries > 0 ) {
		$args['posts_per_page'] = $woo_slider_entries;
	}
	
	if ( ( $woo_slider_tags != '' ) && ( isset( $woo_slider_tags ) ) ) {
	
		$slide_tags_array = explode( ',', $woo_slider_tags ); // Tags to be shown
		
	    foreach ( $slide_tags_array as $tags ) { 
			$tag = get_term_by( 'name', trim( $tags ), 'post_tag', 'ARRAY_A' );
			if ( $tag['term_id'] > 0 )
				$tag_array[] = $tag['term_id'];
		}
		
		if ( ! empty( $tag_array ) ) {
		
			$args['tag__in'] = $tag_array;
		
		}
	
	}
	
	if ( is_single() ) {
		$args['post__not_in'] = array( $post->ID );
	}
	
	if ( is_front_page() && is_array( $exclude_from_morenews ) ) {
		$args['post__not_in'] = $exclude_from_morenews;
	}
	
	$saved = $wp_query;
	
	query_posts( $args );
?>
<?php
	if ( have_posts() ) { $count = 0;
?>
<div id="more-news" class="col-full">
<?php
	$date_format = get_option( 'date_format' );
	
	while ( have_posts() ) { the_post(); $count++;
	$post_class = '';
	if ( $count % $per_row == 0 ) { $post_class = 'last'; }
?>
	<div <?php post_class( $post_class ); ?>>
			
		<?php woo_post_meta( 'more-news' ); ?>
    		        
		<h2 class="title"><a title="<?php the_title_attribute(); ?>" rel="bookmark" href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2>
    		        
		<?php
			if ( $display_images == 'true' ) {
				woo_image( 'width='.$woo_options[ 'woo_morenews_thumb_w' ].'&height='.$woo_options[ 'woo_morenews_thumb_h' ].'&class=thumbnail '.$woo_options[ 'woo_morenews_thumb_align' ]);
			}
		?>        		        
		
		<div class="entry">
			<?php the_excerpt(); ?>
		</div>
    		                             
	</div><!-- /.post -->
<?php
		if ( $count % $per_row == 0 ) {
			echo '<div class="fix"></div>' . "\n";
		}
	} // End WHILE Loop
?>	
	<div class="fix"></div>

</div><!-- /#more-news -->
<?php
	} // End IF ( have_posts() ) Statement
	
	remove_filter( 'excerpt_length', 'woo_more_news_excerpt_length' ); // Reset the post excerpt length.
?>