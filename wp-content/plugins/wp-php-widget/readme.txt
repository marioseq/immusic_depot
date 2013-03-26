=== Plugin Name ===
Contributors: wpxue,ym99
Tags: php,widget
Stable tags:trunk
Requires at least: 2.8
Tested up to: 3.0.1


== Description ==
This plugin adds a new widget called PHP Widget, which will allow you to include PHP code, you can have Text, HTML, Javascript, Flash and/or PHP code wordpress template tags as content or title in this widget.
So, as long as you want, it can do everything, that is greatful.

== Installation ==

1. Upload the folder wp-php-widget to the `/wp-content/plugins/
2. Activate the plugin through the 'Plugins' menu in WordPress
3. Navigate to Appear > widget > PHP widget 
you will see PHP widget ,Use the widget like any other widget.

when you add the PHP widget ,you will see help.

== Help? ==
when you add the PHP widget ,you will see help.


==Usage . example==
`
title:<?php if(is_home()){$html='php-widget title';echo $html;}?>
code:<h1>test</h1><br/> <?php if(is_home()){$html='home';echo $html;}?>

title:<strong><a href="#">url test</a></strong>
code:<h1>test</h1><br/> <?php if(is_home()){$html='home';echo $html;}?>

title:title
code:<h1>test</h1><br/> <?php if(is_home()){$html='home';echo $html;}?>

title:video
code:<embed src="http://player.youku.com/player.php/sid/XMjE1OTczNTA4/v.swf" quality="high" width="480" height="400" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash"></embed>

title:New Posts最新文章
code:<ul>  <?php get_archives('postbypost', 10); ?>	 </ul>

title:Rand Posts随即文章
code:
<ul> 
<?php
query_posts(array('orderby' => 'rand', 'showposts' => 10));
if (have_posts()) :
while (have_posts()) : the_post();?>
<li><a href="<?php the_permalink() ?>"><?php the_title();?></a></li>
<?php endwhile;endif; wp_reset_query();?>
</ul> 

title:orderby comments评论排行
code:
<ul> 
 <?php $result = $wpdb->get_results("SELECT comment_count,ID,post_title FROM $wpdb->posts ORDER BY comment_count DESC LIMIT 0 , 10");
foreach ($result as $post) {
setup_postdata($post);
$postid = $post->ID;
$title = $post->post_title;
$commentcount = $post->comment_count;
if ($commentcount != 0) { ?>
<li><a href="<?php echo get_permalink($postid); ?>" title="<?php echo $title ?>">
<?php echo $title ?></a> (<?php echo $commentcount ?>)</li>
<?php } } ?>
</ul> 

title:new comments最新评论
code:
<ul> 
<?php
////最新评论 显示内容

if (!function_exists('src_simple_recent_comments'))
{
//参数解释：调用评论数量，评论字数（如显示20个汉字就写60），前面html，后面html
function src_simple_recent_comments($src_count=8, $src_length=60, $pre_HTML='', $post_HTML='') {
	global $wpdb;
	
	$sql = "SELECT DISTINCT ID, post_title, post_password, comment_ID, comment_post_ID, comment_author, comment_date_gmt, comment_approved, comment_type, comment_content
		FROM $wpdb->comments 
		LEFT OUTER JOIN $wpdb->posts ON ($wpdb->comments.comment_post_ID = $wpdb->posts.ID) 
		WHERE comment_approved = '1' AND comment_type = '' AND post_password = '' 
		ORDER BY comment_date_gmt DESC 
		LIMIT $src_count";
	$comments = $wpdb->get_results($sql);

	$output = $pre_HTML;
	$output .= "\n<ul>";
	foreach ($comments as $comment) {
		$output .= "\n\t<li><a href=\"" . get_permalink($comment->ID) . "#comment-" . $comment->comment_ID  . "\" title=\" " . htmlspecialchars($comment->post_title) . "\">" . $comment->comment_author . "</a> 在 <a href=\"".get_permalink($comment->ID)."\">".htmlspecialchars($comment->post_title)."</a> : <br />" . substr(strip_tags($comment->comment_content),0,$src_length) . "...</li>";
	}
    $output = convert_smilies($output);
	$output .= "\n</ul>";
	$output .= $post_HTML;
	
  if (empty($comments)) { return ''; } else {	return $output; }

}
}

//简化版：echo '<li><a href="'. get_permalink($comment->comment_post_ID) . '#comment-' . $comment->comment_ID.'">'.get_the_title($comment->comment_post_ID) .'</a></li>'; 只输出标题

//输出评论人和评论内容：		$output .= "\n\t<li><a href=\"" . get_permalink($comment->ID) . "#comment-" . $comment->comment_ID  . "\" title=\" " . htmlspecialchars($comment->post_title) . "\">" . $comment->comment_author.":".substr(strip_tags($comment->comment_content),0,$src_length) . "  ...</a></li>";

?>
<?php if (function_exists('src_simple_recent_comments')) {  echo src_simple_recent_comments('10');  } ?>

</ul> 

title:postviews热门文章
code:
<ul> 
<?php if (function_exists('get_most_viewed')): ?>
   <?php get_most_viewed(); ?>
<?php endif; ?>
</ul> 


title:Time加载时间
code:
 <?php echo get_num_queries(); ?> queries in<?php timer_stop(1); ?> s.

`

etc 

You can have Text, HTML, Javascript, Flash and/or PHP code as content or title in this widget.

So, as long as you want, it can do everything, that is greatful.



== Screenshots ==
1. The widgets screen showing a PHP widget in use.
2. PHP widget .


== Changelog ==
= 1.0.2 =
fixed usage,add help link
= 1.0.1 =
add usage code
= 1.0.0 =
create PHP widget
