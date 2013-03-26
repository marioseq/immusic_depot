
var zs_adminItem='';
var zs_adminSlider='';
var zs_adminTableSlider='';
var zs_nrItems=0;
var zs_nrSliders=0;
var zs_cacheNr=0;
var zs_cacheObject;
var i=0;
var zs_targetInput;
var zs_targetImg;

var zs_currSlider;
var zs_currSliderNr=-1;//curr slider index

zs_adminSlider = '<div class="zs-slider" style="display:none">\
<div class="zs-slider-thumbs"></div><div class="clearfix"></div>\
	<div class="item">\
    <h3>OPTIONS</h3>\
    <div class="settings_cont">\
	<div class="setting"><div class="setting_label">Title [ ID ]:</div><input type="text" class="short textinput zs-input-id" value="default" name="firstname"/><span class="sidenote">Must be unique</span></div>\
	<div class="setting"><div class="setting_label">Width:</div><input type="text" class="short textinput" name="firstname" value="600"/><span class="sidenote">In pixels</span></div>\
	<div class="setting"><div class="setting_label">Height:</div><input type="text" class="short textinput" name="firstname" value="400"/></div>\
	<div class="setting"><div class="setting_label">Menu Position:</div>\<div class="select-wrapper"><span>down</span><select class="textinput short"><option>down</option><option>right</option><option>up</option><option>left</option><option>none</option></select></div></div>\
	<div class="setting"><div class="setting_label">Autoplay:</div>\<div class="select-wrapper"><span>on</span><select class="textinput short"><option>on</option><option>off</option></select></div></div>\
	<div class="setting"><div class="setting_label">Skin:</div>\<div class="select-wrapper"><span>complete</span><select class="textinput short"><option>complete</option><option>light</option><option>rouge</option><option>complete_allchars</option></select></div></div>\
    <h3>YOUTUBE FEED</h3>\
    <span class="sidenote">If you enable this, you can set a YouTube user or playlist from which the videos will come from [ so you wont have to set up every each of them ], the videos set up by you below wont matter</span><br>\
    <div class="setting"><div class="setting_label">Enable:</div>\<div class="select-wrapper"><span>off</span><select class="textinput short"><option>off</option><option>on</option></select></div></div>\
	<div class="setting"><div class="setting_label">YouTube User:</div><input type="text" class="short textinput" name="firstname" value=""/></div>\
	<div class="setting"><div class="setting_label">YouTube Playlist:</div><input type="text" class="short textinput" name="firstname" value=""/></div><div class="sidenote">You need to set the playlist ID there not the playlist Name. For example for this playlist http:'+'/'+''+'/'+'www.youtube.com/my_playlists?p=08BACDB761A0C52A the id is 08BACDB761A0C52A</div>\
    <h3>OTHER OPTIONS</h3>\
    <div class="setting"><div class="setting_label">Scrollbar:</div>\<div class="select-wrapper"><span>off</span><select class="textinput short"><option>off</option><option>on</option></select></div></div>\
	<div class="setting"><div class="setting_label">Thumb:</div><input type="text" id="text1" class="textinput long zs-file-input" name="firstname"/><button class="button-secondary action upload_file zs-main-upload">Upload</button><span class="sidenote">If this is not empty, videos will not autoplay and stead the thumb image instead. Also this will overwrite the youtube user setting if not left blank.</span></div>\
	<div class="setting"><div class="setting_label">YF Max Videos:</div><input type="text" class="short textinput" value="100"/><span class="sidenote">The maximum number of videos to be retrieved from YouTube user channel or playlist</span></div>\
    <div class="setting"><div class="setting_label">Window Mode:</div>\<div class="select-wrapper"><span>opaque</span><select class="textinput short"><option>opaque</option><option>transparent</option></select></div></div>\
    <div class="setting"><div class="setting_label">Display Mode:</div>\<div class="select-wrapper"><span>normal</span><select class="textinput short"><option>normal</option><option>wall</option></select></div></div>\
    <div class="setting"><div class="setting_label">Default Volume:</div>\<input type="text" id="text1" class="textinput"/></div>\
    <div class="toggle"><div class="toggle-title"><h3><div class="arrowdown"></div>Vimeo Settings</h3></div><div class="toggle-content" style="display: none;"><div class="arrow-top"></div><div class="the-content"><div class="sidenote">\
    <div class="setting"><div class="setting_label">Enable:</div>\<div class="select-wrapper"><span>off</span><select class="textinput short"><option>off</option><option>on</option></select></div></div><div class="setting"><div class="setting_label">Vimeo User:</div><input type="text" class="short textinput" name="firstname" value=""/></div> </div></div></div></div>\
    </div>\
    <div class="setting"><div class="setting_label">Suggested Quality:</div>\<input type="text" id="text1" class="textinput" value="hd720"/><span class="sidenote">only for youtube, <a href="http://code.google.com/apis/youtube/flash_api_reference.html#getPlaybackQuality">list of options</a></span></div>\
    <div class="setting"><div class="setting_label">Custom Design Mode:</div>\<div class="select-wrapper"><span>off</span><select class="textinput short"><option>off</option><option>on</option></select></div><span class="sidenote">you can brand the video gallery via the Designer Center above</span></div>\
    <div class="setting"><div class="setting_label">Disable Description:</div>\<div class="select-wrapper"><span>off</span><select class="textinput short"><option>off</option><option>on</option></select></div><span class="sidenote">you can disable the description that appears on top of the video on pause</span></div>\
    <div class="setting"><div class="setting_label">Enable Deeplinking:</div>\<div class="select-wrapper"><span>off</span><select class="textinput short"><option>off</option><option>on</option></select></div><span class="sidenote">enable deeplinking for url pointing to the video you are watching</span></div>\
    <div class="setting"><div class="setting_label">Menu Scroll Time</div>\<input type="text" class="short textinput" value="0.3"/></div>\
	</div><!--end item-->\
	<div class="item-con">\
	</div><!--end item con-->\
	<br><button class="button-secondary action kb-button-add-bot">Add Item</button>\
	</div>'



//<div class="setting"><div class="setting_label">XML Name:</div><input type="text" class="short textinput zs-input-id" value="gallery' + parseInt(Math.random() * 999) + '.xml"/><span class="sidenote">Must be unique</span></div>\
zs_adminTableSlider = '<tr class="zs-table-row"><th class="manage-column column-title column-title-fixed"><span class="zs-table-row-slider-id">default</span></th><th class="zs-edit-slider">Edit Gallery</th><th class="zs-duplicate-slider">Duplicate Gallery</th><th class="zs-delete-slider">Delete Gallery</th></tr>';

var zs_arraySliders = [];//array that holds nr items in each slider


function dzs_ready(){
	jQuery('.import-export-db-con .the-toggle').click(function(){
		var $t = jQuery(this);
		var $cont = $t.parent().children('.the-content-mask');
		/*
		if($cont.css('display')=='none')
		$cont.slideDown('slow');
		else
		$cont.slideUp('slow');
		*/
		if($cont.css('height')=='0px')
		$cont.stop().animate({
			'height' : 400
		}, 700);
		else
		$cont.stop().animate({
			'height' : 0
		}, 700);
		
	});
}

function zs_itemExpand(){


    zs_cacheNr = zs_currSlider.find('.item_header').index(jQuery(this)) + 1;

    if (jQuery(this).hasClass('img-con')) {
        zs_cacheNr = zs_currSlider.find('.img-con').index(jQuery(this)) + 1;
        window.scrollTo(0, zs_currSlider.find('.settings_cont').eq(zs_cacheNr).parent().offset().top)

    }


    if (zs_cacheNr == 0)
        return;


    if (zs_currSlider.find('.settings_cont').eq(zs_cacheNr).css('display') != 'none')
        zs_currSlider.find('.settings_cont').eq(zs_cacheNr).hide('slow');
    else
        zs_currSlider.find('.settings_cont').eq(zs_cacheNr).show('slow');


}

function zs_makeButtons(){
	
	
	jQuery('.item_header').unbind();
	jQuery('.item_header').click(zs_itemExpand)
	
	jQuery('.upload_file').unbind();
	jQuery('.upload_file').click(zs_uploadMedia);

	jQuery('.button-delete').unbind();
	jQuery('.button-delete').click(zs_deleteItem);



	jQuery('.img-con').unbind();
	jQuery('.img-con').click(zs_itemExpand)

	jQuery('.btn-img-delete').unbind();
	jQuery('.btn-img-delete').click(zs_deleteItem);

	jQuery('.zs-duplicate-slider').unbind();
	jQuery('.zs-duplicate-slider').click(zs_duplicate_slider);

	jQuery('.zs-delete-slider').unbind();
	jQuery('.zs-delete-slider').click(zs_deleteSliderHandler);

	jQuery('.zs-edit-slider').unbind();
	jQuery('.zs-edit-slider').click(function(){zs_enableSlider(jQuery('.zs-edit-slider').index(jQuery(this)));})
	
	//jQuery('.zs-file-input').unbind();
	//jQuery('.zs-file-input').change(function(){ zs_changePreview(jQuery(this))});
	
	
	jQuery('.toggle-title').unbind();
	jQuery('.toggle-title').bind('click', function(){
		var $t = jQuery(this);
		if($t.hasClass('opened')){
			($t.parent().find('.toggle-content').slideUp('fast'));
			$t.removeClass('opened');
		}else{
			($t.parent().find('.toggle-content').slideDown('fast'));
			$t.addClass('opened');
		}
	})
	
	for(i=0;i<jQuery('.zs-slider').length;i++){
	jQuery('.zs-slider').eq(i).find('.textinput').eq(0).unbind();
	jQuery('.zs-slider').eq(i).find('.textinput').eq(0).change(function(){zs_checkSlider(jQuery('.zs-slider').index(jQuery(this).parent().parent().parent().parent()),jQuery(this).val());})
	}
	
	
	
	jQuery('.kb-button-add-bot').unbind();
	jQuery('.kb-button-add-bot').click(function(){
		zs_addItems(zs_currSliderNr, 1);
	})
	
	
	
	jQuery('.select-wrapper select').unbind();
	jQuery('.select-wrapper select').change(change_select);

	setTimeout(zs_makeSortable,1000);
}
function change_select(){
	var selval = (jQuery(this).find(':selected').text());
	jQuery(this).parent().children('span').text(selval);
}
function zs_changePreview(argslider, arg, value) {
    jQuery('.zs-slider').eq(argslider).find('.preview-img').eq(arg).attr('src', value);
}

function zs_changeTitle(argslider, arg, value) {
    jQuery('.zs-slider').eq(argslider).find('.item_header h3').eq(arg).text(value);
    //jQuery('.zs-slider').eq(argslider).find('.preview-img').eq(arg).attr('src', value);
}

function zs_showSlider(arg){
	if(zs_currSliderNr>=0){
		jQuery('.zs-slider').eq(zs_currSliderNr).hide("slow");
	}
	jQuery('.zs-slider').eq(arg).show("slow");
	
	zs_currSliderNr=arg;
	zs_currSlider=jQuery('.zs-slider').eq(arg);
}

function zs_enableSlider(arg){
	zs_showSlider(arg);
}
function zs_removeIt(){
	jQuery(this).remove();
}
function zs_deleteItem(){
	
	zs_currSlider.find('.item').eq(zs_currSlider.find('.button-delete').index(jQuery(this)) + 1).hide('slow',zs_removeIt);

}


function zs_deleteItem() {

    zs_currSlider.find('.item').eq(zs_currSlider.find('.btn-img-delete').index(jQuery(this)) + 1).hide('slow', zs_removeIt);
    jQuery(this).parent().remove();

}

function zs_uploadMedia(){
    zs_targetInput = jQuery(this).prev();

    var temp = zs_currSlider.find('.zs-main-upload').index(jQuery(this));
    

    if(jQuery(this).hasClass('zs-main-upload'))
    zs_currSlider.find('.zs-type-select').eq(temp).val('video');

	tb_show('', 'media-upload.php?post_id=1&TB_iframe=true');






	window.send_to_editor = function (arg) {
	    var fullpath = arg;
	    var fullpathArray = fullpath.split('>');
	    //fullpath = fullpathArray[1] + '>';


	    var aux1 = jQuery('.zs-slider').index(zs_targetInput.parent().parent().parent().parent().parent().parent());
	    var aux2 = zs_currSlider.find('.columns-1-1').index(zs_targetInput.parent().parent());
	    var aux3 = jQuery(fullpath).attr('href');
        var aux4=zs_targetInput.hasClass('zs-thumb-main');

        if(aux4==true)
	    zs_changePreview(aux1, aux2,aux3);

	    zs_targetInput.val(aux3);

	    tb_remove();

	    zs_changePreview(zs_targetInput);
	}


	
}
function zs_addSliders(arg){
	
	for(i=0;i<arg;i++){
	
	
	
	jQuery('.zs-slider-container').append(zs_adminSlider);
	jQuery('.zs-tbody').append(zs_adminTableSlider);
	
	zs_arraySliders[zs_nrSliders]=[];
	zs_arraySliders[zs_nrSliders][0]=0;// this is the number of current items of the current slider
	zs_nrSliders++;
	}
	
	zs_currSlider=jQuery('.zs-slider').eq(0);
	zs_makeButtons();
	if(zs_nrSliders==0)
	zs_showSlider(zs_nrSliders-1);
	
}
function zs_checkSlider(argslider, argvalue){
	jQuery('.zs-table-row-slider-id').eq(argslider).text(argvalue);
}
function zs_deleteSliderHandler(){
	zs_deleteSlider(jQuery('.zs-delete-slider').index(jQuery(this)));
}
function zs_deleteSlider(argslider){
	zs_arraySliders[argslider]=0;
	zs_nrSliders--;
	
	jQuery('.zs-slider').eq(argslider).remove();
	jQuery('.zs-table-row').eq(argslider).remove();
}
function zs_addItems(argslider, arg, top){
	
	
	
	for(i=0;i<arg;i++){
	adminItem='<div class="item"><div class="item_header"><h3>ITEM ' + (zs_arraySliders[argslider][0] + 1) + '</h3>\
		<div class="arrow-down"></div></div>\
		<div class="settings_cont" style="display:none">\
		<div class="columns-1-1">\
        <div class="sidenote">Below you will enter your video address. If it is a video from YouTube or Vimeo you just need to enter the id of the video in the "Video:" field. The ID is the bolded part http://www.youtube.com/watch?v=<strong>j_w4Bi0sq_w</strong>. If it is a local video you just need to write its location there or upload it through the Upload button ( .flv format ).</div>\
		<div class="setting"><div class="setting_label">Video:</div><input type="text" id="text1" class="textinput long zs-file-input" name="firstname" value="UIFV3fX26_o"/><button class="button-secondary action upload_file zs-main-upload">Upload</button></div>\
        <div class="setting"><div class="setting_label">Thumbnail:</div><input type="text" id="text1" class="textinput long zs-file-input zs-thumb-main" name="firstname" value=""/><button class="button-secondary action upload_file">Upload</button></div>\
		<div class="setting"><div class="setting_label">Type:</div>\
		<select class="textinput zs-type-select"><option>youtube</option><option>video</option><option>vimeo</option><option>audio</option></select></div>\
        <h4>DESCRIPTION</h4>\
		<div class="setting"><div class="setting_label">Title:</div>\
		<input type="text" id="text1" class="textinput short zs-title-main" name="firstname" value=""/></div>\
		<div class="setting"><div class="setting_label">Menu Caption:</div>\
		<input type="text" id="text1" class="textinput long" name="firstname" value=""/></div>\
		<br />\
        <div class="sidenote">*if you want to upload your own video it must be in .flv (recommended) or .mp4 format<br>\
        *all the fields can be empty, thumbs will update automatically from YouTube if left empty</div>\
		</div>\
		</div>';


	jQuery('.zs-slider').eq(argslider).find('.zs-slider-thumbs').append('<div class="img-con"><img width="90" height="90" class="preview-img"/><div class="btn-img-delete"></div></div>')



	if(top==undefined)
	jQuery('.zs-slider').eq(argslider).find('.item-con').append(adminItem);
	else
	jQuery('.zs-slider').eq(argslider).find('.item-con').prepend(adminItem);

	zs_arraySliders[argslider][0]++;


	
	}
	
	
	

	zs_makeButtons();
}

function zs_checkItem(argslider,arg1,arg2, value){
	
	if(value!=''){
		if(jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2)[0]!=undefined && jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2)[0].nodeName!='SELECT'){
			jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).val(value);
			
			if(jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).hasClass('zs-file-input'))
			    zs_changePreview(jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2))


			var aux = jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).hasClass('zs-thumb-main');

			if (aux == true)
			    zs_changePreview(argslider, arg1 - 1, value);



			var aux2 = jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).hasClass('zs-title-main');

			if (aux2 == true)
			    zs_changeTitle(argslider, arg1 - 1, value);
		
		}
		else{

			for(j=0;j<jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).children().length;j++)
			if(jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).children().eq(j).text()==value)
			jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).children().eq(j).attr('selected', 'selected');
			
			jQuery('.zs-slider').eq(argslider).find('.item').eq(arg1).find('.textinput').eq(arg2).change();
		}
			
		

	
	}
}
function zs_makeSortable(){
	jQuery( ".item-con" ).sortable({
		axis:   'y',
		containment: 'parent',
		tolerance: 'pointer',
		placeholder: "ui-state-highlight",
		update : sortupdate
	});
};
function sortupdate(){
	for(i=1; i<zs_currSlider.find('.item').length; i++){
		//console.log();
		zs_currSlider.find('.zs-slider-thumbs').children().eq(i-1).children('img').attr('src', zs_currSlider.find('.item').eq(i).find('.zs-thumb-main').val());
	}
}

function zs_duplicate_slider(){
	var ind = (jQuery('.zs-duplicate-slider').index(jQuery(this)))
	jQuery('.zs-slider-container').append(jQuery('.zs-slider').eq(ind).clone());
	//console.log(jQuery('.zs-slider').last())
	jQuery('.zs-slider').last().hide();
	
	
	jQuery('.zs-tbody').append(zs_adminTableSlider);
	zs_makeButtons();
}


function zs_sendGallery(){
	
	jQuery('#save-ajax-loading').css('visibility','visible');

	var i=0;
	var j=0;
	var k=0;
	var tempValue='';
	
	var mainString='';
	var optionsString='';
	var itemsString='';
	
	
	for(k=0;k<jQuery('.zs-slider').length;k++){
	itemsString='';
	
	
	
	
	for(i=0;i<jQuery('.zs-slider').eq(k).find('.item').length;i++){
		
		
		for(j=0;j<jQuery('.zs-slider').eq(k).find('.item').eq(i).find('.textinput').length;j++){
		
		
		//console.log(k, i, j, jQuery('.zs-slider').eq(k).find('.item').eq(i).find('.textinput').eq(j));
		
		if(jQuery('.zs-slider').eq(k).find('.item').eq(i).find('.textinput').eq(j)[0].nodeName!="SELECT")
		tempValue = jQuery('.zs-slider').eq(k).find('.item').eq(i).find('.textinput').eq(j).val();
		else{
			tempValue = jQuery('.zs-slider').eq(k).find('.item').eq(i).find('.textinput').eq(j).find(':selected').text();
		}
		
		
		itemsString+=tempValue + '&,';
		}//end j for
		//itemsString = itemsString.slice(0,itemsString.length-2);
		
		itemsString+='&;';
		}//end i for
		
		
		//console.log(itemsString);
		//itemsString = itemsString.slice(0,itemsString.length-2);
		//console.log(itemsString);
		
		
		mainString+=itemsString + '&.';
	}//end k for
	mainString = mainString.slice(0,mainString.length-2);
	
	//console.log(mainString);
	
	

		var data = {
			action: 'zs1_ajax',
			arrayMain: mainString
		};

		// since 2.8 ajaxurl is always defined in the admin header and points to admin-ajax.php
		jQuery.post(ajaxurl, data, function(response) {~
			jQuery('#save-ajax-loading').css('visibility','hidden');
		});
	}









