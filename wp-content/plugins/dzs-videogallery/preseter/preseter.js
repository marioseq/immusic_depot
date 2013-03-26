jQuery(document).ready(function($){
	
	jQuery('.select-wrapper select').unbind();
	jQuery('.select-wrapper select').change(change_select);
	jQuery('.preseter .the-icon').bind("click", function(){
		var $t = jQuery(this);
		if(parseInt($t.parent().css('left')) < 0)
		$t.parent().animate({'left' : 0},{duration:300, queue:false});
		else
		$t.parent().animate({'left' : -140},{duration:300, queue:false});
	})
})
function change_select(){
	var selval = (jQuery(this).find(':selected').text());
	jQuery(this).parent().children('span').text(selval);
}
