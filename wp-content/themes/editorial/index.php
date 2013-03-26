<?php get_header(); ?>
<?php global $woo_options; ?>
<meta name="google-site-verification" content="TqI9dri2NN7ptLCLHb-kMXvf6j2iBBBXtk5_kyqvyE8" />

	<!-- SLIDER POSTS -->
	<?php
		if ( $woo_options['woo_slider'] == 'true' ) {		
			// Load the slider.
			get_template_part( 'includes/slider' );
		}
	?>

    <div id="content" class="col-full">
    
		<div id="main" class="<?php if ( ! woo_active_sidebar( 'primary' ) ) { echo 'fullwidth'; } else { echo 'col-left'; } ?>">
		
			<?php
				// Recent News Grid and Category Switcher
				get_template_part( 'includes/recent-news' );
			?>
                
		</div><!-- /#main -->

        <?php get_sidebar(); ?>

    </div><!-- /#content -->
		
<?php get_footer(); ?>