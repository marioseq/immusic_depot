<div class="postbox">	
	<div class="handlediv" title="<?php _e('Toggle view', 'royalslider'); ?>"></div>			
	<h3 class="hndle">
		<span>General Options</span>
	</h3>
	<div class="inside">
		<!--  <table>
			<tbody>
				<tr>
					<td><label for="width"></label></td>
					<td><input id="width" name="width" type="text" value="600" size="10" />		
				</tr>
			</tbody>
		</table>	-->	
		
		<!-- Width and height -->
		<div class="fields-group">			
			
			<div class="field-row">
				<label for="slider-width" data-help="Slider width. Value can be set in percent (e.g. 100%)."><?php _e('Width', 'royalslider'); ?></label>
				<input id="slider-width" name="width" type="text" value="800" size="5" />	
				<span class="unit">px</span>				
			</div>
			
			
			<div class="field-row">
				<label for="slider-height" data-help="Slider height. Value can be set in percent (e.g. 100%)."><?php _e('Height', 'royalslider'); ?></label>
				<input id="slider-height" name="height" type="text" value="300" size="5" />	
				<span class="unit">px</span>				
			</div>	
		</div>
		
		<!-- Skin -->
		<div class="fields-group">
			<div class="field-row">				
				<label for="skin" data-help="Skin for current slider"><?php _e('Skin', 'royalslider'); ?></label>	
				<select id="skin" name="skin" >
				<?php 
					foreach($this->skins as $skin => $skinName) {
						echo '<option value="' . $skin . '">' . $skinName . '</option>';
					}
				?>			
				</select>
			</div>
			<div class="field-row">			
				<label for="preload-skin" data-help="Check this if you embed slider outside post or page. Slider files will be embedded to every page."><?php _e('Preload skin', 'royalslider'); ?></label>
				<input id="preload-skin" name="preloadSkin" type="checkbox" value="false" />			
			</div>
		</div>
		
		<!-- Lazy loading -->
		<div class="fields-group">
			<div class="field-row group-leader">			
				<label for="lazy-loading" data-help="Preload images only when user need it"><?php _e('Lazy loading', 'royalslider'); ?></label>
				<input id="lazy-loading" name="lazyLoading" type="checkbox" value="true" checked />			
			</div>
			<div class="field-row">			
				<label for="preload-nearby" data-help="Preload next and previous image after current is loaded"><?php _e('Preload nearby', 'royalslider'); ?></label>
				<input id="preload-nearby" name="preloadNearbyImages" type="checkbox" value="true" checked />			
			</div>
		</div>				
			
		<!-- Slideshow -->
		<div class="fields-group">
			<div class="field-row group-leader">			
				<label for="slideshow" data-help="Enable slideshow"><?php _e('Slideshow', 'royalslider'); ?></label>
				<input id="slideshow" name="slideshowEnabled" type="checkbox" value="false"/>			
			</div>
			<div class="field-row">
				<label for="delay" data-help="Time before next slide is shown"><?php _e('Delay', 'royalslider'); ?></label>
				<input id="delay" name="slideshowDelay" type="text" value="5000" size="5" />	
				<span class="unit">ms</span>		
			</div>
			<div class="field-row">			
				<label for="pause-on-hover" data-help="Pause slideshow if mouse is over slider"><?php _e('Pause on hover', 'royalslider'); ?></label>
				<input id="pause-on-hover" name="slideshowPauseOnHover" type="checkbox" value="true" checked="checked"/>			
			</div>
			<div class="field-row">			
				<label for="auto-start" data-help="Auto start slideshow"><?php _e('Auto start', 'royalslider'); ?></label>
				<input id="auto-start" name="slideshowAutoStart" type="checkbox" value="true" checked/>			
			</div>
		</div>
		
		
		
		
		
		<!-- Keyboard navigation -->
		<div class="fields-group">
			<div class="field-row">			
				<label for="keyboardnav" data-help="Enable keyboard arrows(left and right) navigation"><?php _e('Keyboard nav', 'royalslider'); ?></label>
				<input id="keyboardnav" name="keyboardNavEnabled" type="checkbox" value="false"/>			
			</div>	
			<div class="field-row">			
				<label for="mouse-drag" data-help="Enable slide dragging using mouse on non-touch devices"><?php _e('Mouse drag', 'royalslider'); ?></label>
				<input id="mouse-drag" name="dragUsingMouse" type="checkbox" value="true" checked/>			
			</div>	
			<div class="field-row">
				<label for="slide-spacing" data-help="Spacing between slides"><?php _e('Slide spacing', 'royalslider'); ?></label>
				<input id="slide-spacing" name="slideSpacing" type="text" value="0" size="5" />	
				<span class="unit">px</span>				
			</div>	
			<div class="field-row">
				<label for="start-slide-index" data-help="Start slide index (&ldquo;0&rdquo; is the first slide)"><?php _e('Start slide', 'royalslider'); ?></label>
				<input id="start-slide-index" name="startSlideIndex" type="text" value="0" size="5" />								
			</div>
			
			<div class="field-row">			
				<label for="image-align-center" data-help="Align images to the center of slide"><?php _e('Align to center', 'royalslider'); ?></label>
				<input id="image-align-center" name="imageAlignCenter" type="checkbox" value="false"/>			
			</div>
			<div class="field-row">				
				<label for="image-scale-mode" data-help="Resizes images to fit or fill slider area(on client side). Use it if size of your slider is dynamic."><?php _e('Image Scale Mode', 'royalslider'); ?></label>	
				<select id="image-scale-mode" name="imageScaleMode" >
					<option value="none" selected>None</option>
					<option value="fill">Fill area</option>	
					<option value="fit">Fit into area</option>				
				</select>
			</div>			
		</div>
	</div>
</div>	

<div class="postbox">	
	<div class="handlediv" title="<?php _e('Toggle view', 'royalslider'); ?>"></div>			
	<h3 class="hndle">
		<span>User Interface Options</span>
	</h3>
	<div class="inside">		
		<!-- Transition Speed -->
		<div class="fields-group">	
			<div class="field-row">
				<label for="slide-transition-type" data-help="<?php _e('Slide transition type', 'royalslider'); ?>"><?php _e('Transition type', 'royalslider'); ?></label>	
				<select id="slide-transition-type" name="slideTransitionType" >
					<option value="move" selected>Move</option>	
					<option value="fade">Fade</option>									
				</select>
			</div>		
			<div class="field-row">
				<label for="slide-transition-speed" data-help="<?php _e('Slide transition speed', 'royalslider'); ?>"><?php _e('Transition speed', 'royalslider'); ?></label>
				<input id="slide-transition-speed" name="slideTransitionSpeed" type="text" value="400" size="5" />	
				<span class="unit">ms</span>		
			</div>
			<div class="field-row">
				<label for="slide-transition-easing" data-help="<?php _e('Slide transition easing (not applied to mobile devices)', 'royalslider'); ?>"><?php _e('Transition ease', 'royalslider'); ?></label>	
				<select id="slide-transition-easing" name="slideTransitionEasing" >
					<option value="easeInOutSine" selected>Sine-in-out</option>	
					<option value="easeInOutQuart">Quart-in-out</option>
					<option value="easeInOutCirc">Circ-in-out</option>									
					<option value="easeOutSine">Sine-out</option>
					<option value="easeOutQuart">Quart-out</option>	
					<option value="easeOutCirc">Circ-out</option>										
					<option value="linear">Linear</option>				
				</select>
			</div>
		</div>
		
		
		<!-- Arrows navigation -->
		<div class="fields-group">
			<div class="field-row group-leader">
				<label for="arrows" data-help="<?php _e('Show or not navigation arrows', 'royalslider'); ?>"><?php _e('Arrows', 'royalslider'); ?></label>
				<input id="arrows" name="directionNavEnabled" type="checkbox" value="true" checked="checked"/>
			</div>
			<div class="field-row">
				<label for="arrows-auto-hide" data-help="<?php _e('Auto hide navigation arrows when mouse leaves slider area', 'royalslider'); ?>"><?php _e('Arrows auto-hide', 'royalslider'); ?></label>
				<input id="arrows-auto-hide" name="directionNavAutoHide" type="checkbox" value="false"/>
			</div>	
			<div class="field-row">
				<label for="hide-arrow-on-last-slide" data-help="<?php _e('Disable right arrow on last slide and left on first slide (always true for touch devices)', 'royalslider'); ?>"><?php _e('Disable last arrow', 'royalslider'); ?></label>
				<input id="hide-arrow-on-last-slide" name="hideArrowOnLastSlide" type="checkbox" value="true" checked/>
			</div>
		</div>
		
		<!-- Bullet navigation -->
		<div class="fields-group">
			<label for="control-nav" data-help="<?php _e('Enable thumbnails or bullets for control navigation', 'royalslider'); ?>"><?php _e('Control nav', 'royalslider'); ?></label>	
			<select id="control-nav" name="controlNavigationType" >
				<option value="bullets" selected>Bullets</option>
				<option value="thumbnails">Thumbnails</option>
				<option value="none">None</option>				
			</select>
		</div>
		
	</div>
</div>	

<div class="postbox">	
	<div class="handlediv" title="<?php _e('Toggle view', 'royalslider'); ?>"></div>			
	<h3 class="hndle">
		<span>Image Generation Options (TimThumb)</span>
	</h3>
	<div class="inside">
		<div class="fields-group">
			<div class="field-row group-leader">			
				<label for="auto-generate-images" data-help="Auto-generate and crop images to slider size"><?php _e('Generate images', 'royalslider'); ?></label>
				<input id="auto-generate-images" name="auto-generate-images" type="checkbox" value="false" />			
			</div>
		</div>
		<!-- Auto-generate thumbnails -->
		<div class="fields-group">
			<div class="field-row group-leader">			
				<label for="auto-generate-thumbs" data-help="Auto-generate thumbs for slides where custom thumbnail path is not set"><?php _e('Generate thumbs', 'royalslider'); ?></label>
				<input id="auto-generate-thumbs" name="auto-generate-thumbs" type="checkbox" value="false" />			
			</div>			
			<div class="field-row">
				<label for="thumb-width" data-help="Thumbnail width that should be auto-generated."><?php _e('Thumb Width', 'royalslider'); ?></label>
				<input id="thumb-width" name="thumb-width" type="text" value="60" size="5" />	
				<span class="unit">px</span>				
			</div>
			<div class="field-row">
				<label for="thumb-height" data-help="Thumbnail height that should be auto-generated."><?php _e('Thumb Height', 'royalslider'); ?></label>
				<input id="thumb-height" name="thumb-height" type="text" value="60" size="5" />	
				<span class="unit">px</span>				
			</div>
		</div>
	</div>
</div>


<div class="postbox">	
	<div class="handlediv" title="<?php _e('Toggle view', 'royalslider'); ?>"></div>			
	<h3 class="hndle">
		<span>Animated Block Options</span>
	</h3>
	<div class="inside">		
		<!-- Caption Animation Enabled -->
		<div class="fields-group">			
			<div class="field-row group-leader">
				<label for="caption-animation"  data-help="<?php _e('Enable/disable animation of all blocks', 'royalslider'); ?>"><?php _e('Blocks anim.', 'royalslider'); ?></label>
				<input id="caption-animation" name="captionAnimationEnabled" type="checkbox" value="true" checked="checked"/>
			</div>
			<div class="field-row">
				<label for="fade-effect" data-help="<?php _e('Enable fade effect for captions by default', 'royalslider'); ?>"><?php _e('Fade effect', 'royalslider'); ?></label>
				<input id="fade-effect" name="captionShowFadeEffect" type="checkbox" value="true" checked="checked"/>
			</div>
			<div class="field-row">
				<label for="move-effect" data-help="<?php _e('Move effect for captions by default', 'royalslider'); ?>"><?php _e('Move effect', 'royalslider'); ?></label>	
				<select id="move-effect" name="captionShowMoveEffect">								
					<option value="movetop" selected>Move from top</option>
					<option value="moveright">Move from right</option>
					<option value="movebottom">Move from bottom</option>	
					<option value="moveleft">Move from left</option>
					<option value="none">None</option>					
				</select>
			</div>
			<div class="field-row">
				<div class="field-row">
					<label for="caption-move-offset" data-help="<?php _e('Distance for move effect by default', 'royalslider'); ?>"><?php _e('Move distance', 'royalslider'); ?></label>
					<input id="caption-move-offset" name="captionMoveOffset" type="text" value="20" size="5" />	
					<span class="unit">px</span>
				</div>	
			</div>
			<div class="field-row">
				<div class="field-row">
					<label for="caption-show-speed" data-help="<?php _e('Default caption item show duration', 'royalslider'); ?>"><?php _e('Show duration', 'royalslider'); ?></label>
					<input id="caption-show-speed" name="captionShowSpeed" type="text" value="400" size="5" />	
					<span class="unit">ms</span>
				</div>	
			</div>
			<div class="field-row">
				<label for="caption-show-easing" data-help="<?php _e('Default caption item show easing (not applied to mobile devices)', 'royalslider'); ?>"><?php _e('Show ease', 'royalslider'); ?></label>	
				<select id="caption-show-easing" name="captionShowEasing" >
					<option value="easeInOutSine" selected>Sine-in-out</option>	
					<option value="easeInOutQuart">Quart-in-out</option>
					<option value="easeInOutCirc">Circ-in-out</option>									
					<option value="easeOutSine">Sine-out</option>
					<option value="easeOutQuart">Quart-out</option>	
					<option value="easeOutCirc">Circ-out</option>										
					<option value="linear">Linear</option>				
				</select>
			</div>
			<div class="field-row">
				<div class="field-row">
					<label for="caption-show-delay" data-help="<?php _e('Delay between captions animation', 'royalslider'); ?>"><?php _e('Show delay', 'royalslider'); ?></label>
					<input id="caption-show-delay" name="captionShowDelay" type="text" value="200" size="5" />	
					<span class="unit">ms</span>
				</div>	
			</div>
			
		</div>
	</div>
</div>	