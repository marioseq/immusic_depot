<?php


add_action('widgets_init', array('zs1_widget', 'register_this_widget'));

class zs1_widget extends WP_Widget {
    public $name = "Video Gallery";
    public $control_options = array();

    function __construct() {
        $wdesc = '';
        if(isset($this->widget_desc)) $wdesc = $this->widget_desc;
        $widget_options = array(
            'classname' => __CLASS__,
            'description' => $wdesc,
        );
        parent::__construct(__CLASS__, $this->name, $widget_options, $this->control_options);
    }

    //!!! Static Functions
    static function register_this_widget() {
        register_widget(__CLASS__);
    }

    function form($instance) {

        $defaults = array('zs1id' => '1', 'title' => 'Video Gallery');
        $instance = wp_parse_args((array) $instance, $defaults);
?>
        <p>        
            <label for="<?php echo $this->get_field_id('title'); ?>">Title:</label>
            <input type="text" name="<?php echo $this->get_field_name('title') ?>" id="<?php echo $this->get_field_id('title') ?> " value="<?php echo $instance['title'] ?>" size="20"> </p>
            <label for="<?php echo $this->get_field_id('zs1id'); ?>">Gallery Id:</label>
            <input type="text" name="<?php echo $this->get_field_name('zs1id') ?>" id="<?php echo $this->get_field_id('zs1id') ?> " value="<?php echo $instance['zs1id'] ?>" size="20"> </p>
        <p>
<?php
    }
  function widget ($args,$instance) {
  extract($args);

  $title = $instance['title'];
  //$title = $instance['zs1id'];

  

  echo $before_widget;
  echo $before_title;
  echo  $title;
  echo $after_title;


  //do_shortcode('[phoenixgallery]');
  
  $arr = array("id" => $instance['zs1id']);
  echo zs1_show_slider($arr);


  echo $after_widget;
    }

}


?>