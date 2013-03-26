<?php
/*
Plugin Name: WP PHP widget
Plugin URI: http://www.wpxue.com/wp-php-widget
Description: WP PHP widget adds a new widget called PHP Widget, which will allow you to include PHP code, you can have Text, HTML, Javascript, Flash and/or PHP code ,wordpress template tags as content or title in this widget.<br/> So, as long as you want, it can do everything, that is greatful.
Author: wpxue
Version: 1.0.2
Author URI: http://www.wpxue.com
*/
###############WPxue_PayPal_Donate###############
if(!function_exists('WPxue_PayPal_Donate')){
function WPxue_PayPal_Donate($number,$image="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif",$name='Donate WPxue.com,Thank you very much!'){
$name=urlencode($name);
$number=urlencode($number);
$image1="https://www.paypal.com/en_US/i/btn/btn_donate_LG.gif";
$image2="https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif";
$image3="https://www.paypal.com/en_US/i/btn/btn_donateCC_LG.gif";
$image4="https://www.paypal.com/en_GB/i/btn/btn_donateCC_LG.gif";

echo <<< html
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=hnbwww%40qq%2ecom&lc=US&item_name=$name&item_number=$number&button_subtype=services&currency_code=USD&bn=PP%2dBuyNowBF%3abtn_buynowCC_LG%2egif%3aNonHosted" >
<img src="$image" border="0"   alt="If you like this Plugin , please Donate WPxue.com,Thank you very much!" title="If you like this Plugin , please Donate WPxue.com,Thank you very much! 
Make payments with PayPal - it's fast, free and secure!"/>
 </a>
html;
}
}
###############WPxue_PayPal_Donate###############
class WPxuePhpWidget extends WP_Widget {
    function WPxuePhpWidget() {
        $widget_ops = array('classname' => 'php_widget', 'description' => 'You can have Text, HTML, Javascript, Flash and/or PHP code, wordpress template tags as content or title in this widget.');
        $control_ops = array('width' => 200, 'height' => 120);
        $this->WP_Widget('php_widget', 'PHP widget', $widget_ops, $control_ops);
    }
    function widget($args, $instance) {     
        extract($args);
        $title = $instance['title'];
        $body = apply_filters('widget_text', $instance['body']);
/*        if (empty($body)) {
            $body = '&nbsp;';
        }
		*/
				
        if (!empty($title)) {
			ob_start();
            eval(" ?>$title<?php ");
			$title2 = ob_get_contents();
			ob_end_clean();
        }
		
        ob_start();
		eval(" ?>$body<?php ");
		$body2 = ob_get_contents();
		ob_end_clean();
		
		if (!empty($title2)||!empty($body2))  echo $before_widget;
		if (!empty($title2)) echo $before_title,$title2,$after_title;//if title2 not empty then echo
		if (!empty($body2)) echo $body2;	//if body2 not empty then echo
		if (!empty($title2)||!empty($body2)) echo $after_widget;	
    }
    function update($new_instance, $old_instance) {             
        return $new_instance;
    }
    function form($instance) {              
        $title = $instance['title'];
        $body = $instance['body'];
        $title_id = $this->get_field_id('title');
        $title_name = $this->get_field_name('title');
        $body_id = $this->get_field_id('body');
        $body_name = $this->get_field_name('body');
?>
        <p>
		<?php WPxue_PayPal_Donate('WP PHP widget')?><br/>
            <label for="<?php echo $title_id; ?>"><strong>Title:</strong></label>
            <input class="widefat" id="<?php echo $title_id; ?>" name="<?php echo $title_name; ?>"
                   type="text" value="<?php echo esc_attr($title); ?>"/>
        </p>
		<p><label><strong>Code:<a href="<?php  $x = WP_PLUGIN_URL.'/'.str_replace(basename( __FILE__),"",plugin_basename(__FILE__));echo $x ?>readme.txt?KeepThis=true&amp;TB_iframe=true&amp;height=450&amp;width=680" class="thickbox" title="Help" target="_blank">Help?</a></strong></label>
            <textarea class="widefat" id="<?php echo $body_id; ?>" name="<?php echo $body_name; ?>"
                      rows="16" cols="20"><?php echo htmlspecialchars($body); ?></textarea>
        </p>
<?php 
    }


}


add_action('widgets_init', create_function('', 'return register_widget("WPxuePhpWidget");'));