<?php
/*
Template Name: Sitemap
*/
?>
<?php get_header(); ?>
    
    <?php if ( $woo_options['woo_breadcrumbs_show'] == 'true' ) { ?>
	    <div id="breadcrumbs">
	    	<?php woo_breadcrumbs(); ?>
	    </div><!--/#breadcrumbs -->
	<?php } ?>
    
    <div id="content" class="page col-full">
    
		<div id="main" class="<?php if ( ! woo_active_sidebar( 'primary' ) ) { echo 'fullwidth'; } else { echo 'col-left'; } ?>">  

	        <div <?php post_class(); ?>>
	        
			    <h1 class="title"><?php the_title(); ?></h1>
	        	
	        	<div class="entry">
	            
		            <?php
		            	if ( have_posts() ) { the_post();
		            		the_content();
		            	}
		            ?>  

					<div class="fl" style="width:48%">												  
	            	<h3><?php _e( 'Pages', 'woothemes' ); ?></h3>
	            	<ul>
	           	    	<?php wp_list_pages( 'depth=0&sort_column=menu_order&title_li=' ); ?>		
	            	</ul>
	            	</div>				
	    
					<div class="fr" style="width:48%">												  	    
		            <h3><?php _e( 'Categories', 'woothemes' ); ?></h3>
		            <ul>
	    	            <?php wp_list_categories( 'title_li=&hierarchical=0&show_count=1' ); ?>	
	        	    </ul>
	        	    </div>
	        	    <div class="fix"></div>
			        
			        <h3><?php _e( 'Posts per category', 'woothemes' ); ?></h3>
			        <?php
			    
			            $cats = get_categories();
			            foreach ( $cats as $cat ) {
			    
			            query_posts( 'cat='.$cat->cat_ID);
			
			        ?>
	        
	        			<h4><?php echo $cat->cat_name; ?></h4>
			        	<ul>	
	    	        	    <?php while ( have_posts() ) { the_post(); ?>
	        	    	    <li style="font-weight:normal !important;"><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a> - <?php _e( 'Comments', 'woothemes' ); ?> (<?php echo $post->comment_count; ?>)</li>
	            		    <?php } ?>
			        	</ul>
	    
	    		    <?php } ?>
	    		
	    		</div><!-- /.entry -->
	    						
	        </div><!-- /.post -->                    
	                
        </div><!-- /#main -->

        <?php get_sidebar(); ?>

    </div><!-- /#content -->
		
<?php get_footer(); ?>