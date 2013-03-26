(function($) {
	
	$(document).ready(function() {
		
		/* Caption CSS styles. 'YOUR-CSS-STYLE':'Description in admin' */
		var captionStyles = {		
			'no-style':'No Style',				
			'caption-black-text-block':'Text Block (black)',		
			'caption-white-text-block':'Text Block (white)',			
			'caption-big-title':'Title (big)',	
			'caption-smaller-title':'Title (smaller)'
		};
		
		
		
		
		/* MANAGE SLIDERS	*/
		// delete the slider
		var deleteBtn = $('.royalslider-admin #delete-rslider').click(function(e) {
			e.preventDefault();	
			var href = $(this).attr('href');
			$('<div><div class="delete-dialog-icon"></div><p>Delete slider permanently?</p></div>').dialog({
						resizable:false,
						modal:true,
						width:350,
						buttons: {
							'yes' : function() { $(this).remove(); window.location = href; },
							'cancel' : function() { $(this).remove(); }
						}
			});			
			$('.ui-dialog-titlebar').remove();			
		});			
		if(deleteBtn && deleteBtn.length > 0) {			
			return;
		}		
		/* MANAGE SLIDERS END */
		
		
		
		
		var slidesContainer = $('.royalslider-admin #slides');
		var optionsContainer = $("#royalslider-options");
		var saveProgressButton = $('.royalslider-admin #save-progress');
		var isUnsaved = false;
		
		
		$('#slides').sortable({
			placeholder: 'sortable-placeholder',
			items: '.slidecontainer',
			handle: '.hndle',
			cursor: 'move',
			distance: 2,
			tolerance: 'pointer',
			helper: 'clone',
			forcePlaceholderSize: true,			
			opacity: 0.7
		});
		
		
		var sliderDataNode =  $('#royal-slider-data');
		var sliderID = sliderDataNode.attr('data-id');
		if(!sliderID) {
			sliderID = -1;	
			/*$('.royalslider #title').val('No name set');*/
		} else {
			$('.royalslider-admin #title').val(sliderDataNode.attr('data-name'));
			
			optionsContainer.find("#skin").val(sliderDataNode.attr('data-skin'));			
			
		}
		$('.royalslider-admin #title').bind('change', function() {
			unsaved();
		});
		optionsContainer.find('input, select').bind('change', function() {
			unsaved();
		});
		
		$('#sortable-slides-boxes').bind('sortupdate', function() {
			unsaved();
		});
		
		if(sliderDataNode.attr('data-preload-skin') == '1') {
			optionsContainer.find('#preload-skin').attr('checked', true);

		}
		
		
		
				
		parseSliderOptionsNode();	
		parseSliderDataNode();
		
		var isAjaxRunning = false,			
			pluginUrl = royalslider_ajax_vars.pluginurl;
		
		var saveButton = $("#save-slider");
		
		if(saveButton) {
			if(sliderID > -1) {				
				saveButton.html('Save Slider');
			} else {
				unsaved();
				saveButton.html('Create Slider');
			}			
				
			saveButton.click(function(e) {
				e.preventDefault();
				
				saveSlider();
			});
		}
		
		
		
		
		var sliderLivePreviewDialog = $('<div></div>');
		
		$("#preview-slider").click(function(e) {
			e.preventDefault();	
			
			var realPreviewSlider = generateSliderHTML();
			
			var wid = getOptionFromMainSidebar('slider-width');
			var hei = getOptionFromMainSidebar('slider-height');			
			
			if(wid.indexOf('%') < 0) {
				wid = parseInt(wid, 10) ;
			} else {
				wid = 800;
			}		
			
			if(hei.indexOf('%') < 0) {
				hei = parseInt(hei, 10);
			} else {
				hei = 400;
			}			
			
			sliderLivePreviewDialog.dialog({
				resizable: false,
				modal: true,
				width: wid + 28,
				height: hei + 131,
				title: 'Live Preview',
				create: function() {
					
				},
				close: function() {				
					sliderLivePreviewDialog.find('.royalSlider').data('royalSlider').destroy();
					sliderLivePreviewDialog.dialog('destroy');
					sliderLivePreviewDialog.remove();	
					$('this').remove();
					
				}
			});
			
			realPreviewSlider.appendTo(sliderLivePreviewDialog);			
			realPreviewSlider.css({'width':wid + 'px', 'height':hei + 'px'});
			realPreviewSlider.royalSlider(generateSliderJSOptions());
			
			sliderLivePreviewDialog.dialog( "option", "height", realPreviewSlider.outerHeight(true) + 65);
		});
		
		var tooltipDefault = {
			content: {
				attr: 'data-help'
			},
			position: {
				at: 'center left', 
				my: 'center right'
			},
			style: {
				classes: 'ui-tooltip-rounded ui-tooltip-shadow ui-tooltip-tipsy rs-tooltip'
			}
		};
		 		
		optionsContainer.find('label').each( function( ) {
			var help = $(this).attr( 'data-help' );
			if ( help != undefined && help != '' ) {
				$(this).qtip(tooltipDefault);
            }
		});
		
		optionsContainer.find('#caption-show-delay').change(function() {
			var dVal = $(this).val();				
			if(dVal === '' || isNaN(dVal)) {
				dVal = 'auto';
				$(this).val(dVal);	
			}				
		});
		
		
		var lGroup;
		var lField;
		optionsContainer.find(".group-leader input[type=checkbox]").each(function() {
			$(this).click(function() {	
				lGroup = $(this).closest('.fields-group');
				lField = $(this);
			
				if(lField.is(':checked')) {
					lGroup.find(".field-row:not(.group-leader)").removeClass('rs-hidden-controls');	
				} else {
					lGroup.find(".field-row:not(.group-leader)").addClass('rs-hidden-controls');	
				}				
			}).triggerHandler('click');
		});			
		
		$('.royalslider-admin #add-new-slide-button').click(function(e) {
			e.preventDefault();
			var slide = createAdminSlideItem();	
			slide.appendTo(slidesContainer);
			addSlideItemEvents(slide);
			slide.hide().fadeIn();
		});			
		
		slidesContainer.find('.slidecontainer').each(function(){			
			addSlideItemEvents($(this));			
		});
		
		function addSlideItemEvents(slide) {				
			slide.find('.settings-tabs').tabs({ selected: 0 });
			
			slide.find('.deletediv').click(function() {
				var slideContainer = $(this).parent();			
		
				slideContainer.animate({'opacity':0}, 100).slideUp(100, function() {
					$(this).remove();
					unsaved();				
				});				
			});
			slide.find('.duplicatediv').click(function() {
				var newSlide = slide.clone(false);	
				newSlide.insertAfter(slide);
				
				var textAreaVal = slide.find('#html-content').val();
				addSlideItemEvents(newSlide);		
				newSlide.find('#html-content').val(textAreaVal);
				newSlide.hide().fadeIn();	
				unsaved();
			});
			
			slide.find('.content-editor-button').click( function(e) {
				e.preventDefault();
				unsaved();
				showContentEditor($(this).closest('.slidecontainer'));
			});
			
			
			slide.find("input[name='image']").bind('change', function(e, triggered){
				
				if(!triggered) {
			        unsaved();
			    }
				
				var self = $(this);
				self.removeClass('incorrect-image-url');
				var tWidth = 256,
					tHeight = 128,					
					imgPath = self.val();
				
				
				if(imgPath) {
					var	thumbPath = pluginUrl + "timthumb/timthumb.php?src=" + imgPath + '&w=' + tWidth + '&h=' + tHeight + '&q=100';
					
					$('<img />').load(function(){
						var nImg = slide.find('.image-area img');
						if(nImg) {
							nImg.get(0).src = this.src;
						}						
					}).error(function(){						
						self.addClass("incorrect-image-url");
						slide.find('.image-area img').attr('src', pluginUrl + 'images/blank.gif');						
					}).attr('src', thumbPath);
				} else {
					slide.find('.image-area img').attr('src', pluginUrl + 'images/blank.gif');
				}
			}).triggerHandler('change', true);
			
			var thumbURLInput = slide.find("#thumb-path");
			var thumbImg;
			var newSrc;
			var thumbPar = thumbURLInput.parent();
			thumbImg = thumbPar.find('.royalThumbImagePreview');
			if(!thumbImg || !(thumbImg.length > 0)) {
				thumbImg =  $('<img class="royalThumbImagePreview" />');
				thumbPar.append(thumbImg);
			}
			
			thumbURLInput.bind('change', function(e, triggered) {
				if(!triggered) {
			        unsaved();
			    }
				thumbURLInput.removeClass("incorrect-image-url");
				if(thumbURLInput.val()) {
					$('<img />').load(function(){					
						thumbImg.attr('src', this.src);				
					}).error(function(){					
						thumbURLInput.addClass("incorrect-image-url");
						thumbImg.attr('src', pluginUrl + 'images/blank.gif');					
					}).attr('src', thumbURLInput.val());
				} else {
					thumbImg.attr('src', pluginUrl + 'images/blank.gif');			
				}
			}).triggerHandler('change', true);
			
			slide.find('.select-thumb-button').click(function(e) {
				e.preventDefault();						
				tb_show('', 'media-upload.php?type=image&amp;TB_iframe=true');
				// prevent "unload" event from firing when tb_window is closed 
				$("#TB_window,#TB_overlay,#TB_HideSelect").one("unload",function(e){
					e.stopPropagation();
					e.stopImmediatePropagation();
					return false;
				});
				window.send_to_editor = function(html) {
					tb_remove();
					thumbURLInput.val(jQuery('img',html).attr('src')).triggerHandler("change");
				};				
			});
			
			
			slide.find('#html-content').bind('change', function() {
				unsaved();
			});
			slide.find('#link-url').bind('change', function() {
				unsaved();
			});
			slide.find('#link-target').bind('change', function() {
				unsaved();
			});
			
			
			slide.find('.image-area').click( function(e) {				
				var field = slide.find('input[name="image"]');
				tb_show('', 'media-upload.php?type=image&amp;TB_iframe=true');				
				$("#TB_window,#TB_overlay,#TB_HideSelect").one("unload",function(e){
					e.stopPropagation();
					e.stopImmediatePropagation();
					return false;
				});
				window.send_to_editor = function(html) {
					tb_remove();
					field.val(jQuery('img',html).attr('src')).triggerHandler("change");
				};
			});
		}		
		
		
		var currentCaptionEditing;
		var lastCaptionSelected;
		var isEditing;
		
		var xInput;
		var yInput;
	
		
		var slideW;
		var slideH;
		
		var captionsArray;
		var sortableCaptions;
		
		var animationOptions;
		var cssCaptionClassesArr;
		
		var captionsContainer;
		var currentContentEditorData;
		var currentSlideCaption;
		
		var captionStyleSelect;
		
		var animationCheckbox;
		
		var durationInput;
		var delayInput;
		var fadeEffectCheckbox;
		var moveEffectSelect;
		var moveDistance;
		var animationTypeRadio;
		var easingTypeSelect;
		
		var isCustomEditing;
		
		var baseProps;
		
		var previewContainer;
		
		var dragEnabledCheckbox;
		
		/**
		 * Slider content editor
		 */
		function showContentEditor(slide) {
			currentSlideCaption = slide.find('.royalCaption');
			currentCaptionEditing = '';
			lastCaptionSelected = '';
			cssCaptionClassesArr = [];
			captionsContainer = '';
			currentContentEditorData = '';
			isEditing = false;
			captionsArray = [];			
			
			previewContainer = $(
				'<div class="royalslider-content-editor">' +
					'<div class="slide-area royalSlider">'+
						
					'</div>' +
				'</div>'					
			);		
			
			
			slideW = getOptionFromMainSidebar('slider-width');
			slideH = getOptionFromMainSidebar('slider-height');			
			
			if(slideW.indexOf('%') < 0) {
				slideW = parseInt(slideW, 10) ;
			} else {
				slideW = 600;
			}			
			if(slideH.indexOf('%') < 0) {
				slideH = parseInt(slideH, 10);
			} else {
				slideH = 400;
			}
			
			
			var slideArea = previewContainer.find('.slide-area').css({
				width:slideW, 
				height:slideH
			});
			
			captionsContainer = $('<div class="admin-captions-container "></div>').appendTo(slideArea);
            
			captionsContainer.bind('click.previewContainer', function() {				 
				 if(currentCaptionEditing) {				
					 removeCaptionEditor();						 
				 } else {
					 deselectCaption(lastCaptionSelected, true);									
				 }					 
			 });
			
			var imgPath = getSlideBgImage(slide);
			if(imgPath != false) {				
				slideArea.css('background', 'url(' + imgPath + ') top left no-repeat');				
			}
			
			var options = $('<div class="content-editor-options"></div>').appendTo(previewContainer);
			
			var addButton = $('<a class="alignleft button-primary button80" href="#">+ Add Block</a>')
							.appendTo(options)
							.click(function(e){
								e.preventDefault();								
								var cItem = addCaptionItem(captionsContainer);
								setSelectedCaption(cItem);		
							});
			
			function getCaptionStyleTypes() {
				var s = '';
				var count = 0;
				for (var style in captionStyles) {					
					s += '<option value="' + style + '" ' + ((count == 0) ? 'selected' : '')  + '>' + captionStyles[style] + '</option>';
					cssCaptionClassesArr.push(style);
					count++;
				}				
				return s;
			}
		
			
			baseProps = $(					
					'<div class="base-props hidden-group">'+	
						'<label for="curr-caption-style" data-help="CSS style for selected caption. Can be edited in css/royalslider.css">Style:</label>'+
						'<select id="curr-caption-style">'+
							getCaptionStyleTypes() +
						'</select>'+
						
						'<label for="caption-x-pos">X:</label>'+
						'<input id="caption-x-pos" name="caption-x-pos" type="text" value="0" size="5" />	'	+		
					
						'<label for="caption-y-pos">Y:</label>'+
						'<input id="caption-y-pos" name="caption-y-pos" type="text" value="20" size="5" />	'	+						
						
						'<input id="drag-enabled" name="my-caption-fade-effect" type="checkbox" value="true" checked style="margin-left:30px; margin-top:6px;" />'+
						'<label for="drag-enabled" style="margin-left:5px;" data-help="Prevents dragging functionality on selected element">Dragging enabled</label>'+								
										
					'</div>'+
					'<br class="clear" />'
			).appendTo(options);
			
			
			dragEnabledCheckbox = baseProps.find("#drag-enabled");
			
			dragEnabledCheckbox.bind('change',function() {			
				if(lastCaptionSelected) {
					if($(this).is(':checked')) {
						lastCaptionSelected.removeClass('non-draggable');
					} else {
						lastCaptionSelected.addClass('non-draggable');
					}					
				}
			});
			
			captionStyleSelect = baseProps.find('select[id="curr-caption-style"]').change(function() {
				addCaptionStyle($(this).val());
			});
			
			
			
			sortableCaptions = $('<ul id="sortable-captions"></ul>').sortable({				
				forceHelperSize: true,
				placeholder: 'ui-state-highlight',
				update:function(event, ui) {
					var cCaption = $(ui.item).data('captionItem');	
					cCaption.detach();		
					var cListIndex = ui.item.index();					
					var beforeCaption = captionsContainer.children().eq(cListIndex);					
					if(beforeCaption.length) {						
						cCaption.insertBefore(beforeCaption);			
					} else {						
						cCaption.appendTo(captionsContainer);
					}					
				}
			});
			
			
			animationOptions = $(
					'<div class="fields-group main-animation-block hidden-group">'+
						'<div class="animation-type-block">'+
							'<div class="radio-group-label">Block animation</div>'+
							'<div class="r-button"><input type="radio" name="animType" value="default" id="anim-default" checked /><label data-help="Animation options are inherited from &ldquo;Animated Block Options&rdquo;  section in main right sidebar." for="anim-default">Default</label></div>'+
							'<div class="r-button"><input type="radio" name="animType" value="custom" id="anim-custom" /><label data-help="Custom animation for selected block." for="anim-custom">Custom</label></div>'+
							'<div class="r-button"><input type="radio" name="animType" value="none" id="anim-none" /><label data-help="No animation is applied to block and it is always visible." for="anim-none">None</label></div>'+
						'</div>'+	
						'<div class="animation-settings-block">'+
											
						    '<div class="col col1">'+
								'<div class="field-row">'+
									'<label for="my-caption-duration">Duration</label>'+
									'<input id="my-caption-duration" name="caption-duration" type="text" value="400" size="5" />	'	+		
								'</div>'+
								'<div class="field-row">'+
									'<label for="my-caption-delay">Delay</label>'+
									'<input id="my-caption-delay" name="caption-delay" type="text" value="auto" size="5" />	'	+		
								'</div>'+
							'</div>'+		
							
							'<div class="col col2">'+
								'<div class="field-row">'+			
									'<label for="my-caption-easing">Easing</label>'+		
									'<select id="my-caption-easing">'+									
										'<option value="easeInOutSine" selected>Sine-in-out</option>'+	
										'<option value="easeInOutQuart">Quart-in-out</option>'+	
										'<option value="easeInOutCirc">Circ-in-out</option>'+										
										'<option value="easeOutSine">Sine-out</option>'+	
										'<option value="easeOutQuart">Quart-out</option>'+	
										'<option value="easeOutCirc">Circ-out</option>'+										
										'<option value="linear">Linear</option>'+								
									'</select>'+
								'</div>'+	
								'<div class="field-row">'+			
									'<label for="my-caption-move-effect">Move effect</label>'+		
									'<select id="my-caption-move-effect">'+									
										'<option value="movetop" selected>Move from top</option>'+	
										'<option value="moveright">Move from right</option>'+	
										'<option value="movebottom">Move from bottom</option>'+		
										'<option value="moveleft">Move from left</option>'+	
										'<option value="none">None</option>'+						
									'</select>'+
								'</div>'+	
							'</div>'+	
							
							'<div class="col col3">'+
								'<div class="field-row label_checkbox_pair">'+			
									'<input id="my-caption-fade-effect" name="my-caption-fade-effect" type="checkbox" value="true" checked/>'+
									'<label for="my-caption-fade-effect">Fade effect</label>'+								
								'</div>'+
								'<div class="field-row move-dist-container">'+
									'<label for="my-caption-move-dist">Move distance</label>'+
									'<input id="my-caption-move-dist" type="text" value="20" size="5" />	'	+		
								'</div>'+
							'</div>'+
						'</div>'+	
					'</div>'
			).appendTo(options);
			sortableCaptions.appendTo(options);
			
			animationOptions.wrap($('<div class="main-block-container"></div>'));
			
			var animOptionsTTip = {
					content: {
						attr: 'data-help'
					},
					position: {
						at: 'center right', 
						my: 'center left'
					},
					style: {
						classes: 'ui-tooltip-rounded ui-tooltip-shadow ui-tooltip-tipsy rs-tooltip'
					}
			};
			options.find('label').each( function( ) {
				var help = $(this).attr( 'data-help' );
				if ( help != undefined && help != '' ) {
					$(this).qtip(animOptionsTTip);
	            }
			});			
			
			durationInput = animationOptions.find('#my-caption-duration');
			delayInput = animationOptions.find('#my-caption-delay');
			fadeEffectCheckbox = animationOptions.find('#my-caption-fade-effect');
			easingTypeSelect = animationOptions.find('#my-caption-easing');
			moveEffectSelect = animationOptions.find('#my-caption-move-effect');
			moveDistance = animationOptions.find('#my-caption-move-dist');			
			
			durationInput.change(function() {
				if(isCustomEditing)
					setInputValue(durationInput, $(this).val());			
			});
			delayInput.change(function() {				
				if(isCustomEditing) {
					var dVal = $(this).val();					
					if(dVal === '' || isNaN(dVal)) {
						dVal = 'auto';
					}
					setInputValue(delayInput, dVal);				
				}					
			});
			
			fadeEffectCheckbox.change(function() {				
				if(isCustomEditing)
					setInputValue(fadeEffectCheckbox, $(this).is(':checked'));				
			});
			easingTypeSelect.change(function() {
				if(isCustomEditing)
					setInputValue(easingTypeSelect, $(this).val());				
			});
			moveEffectSelect.change(function() {
				if(isCustomEditing)
					setInputValue(moveEffectSelect, $(this).val());				
			});
			moveDistance.change(function() {
				if(isCustomEditing)
					setInputValue(moveDistance, $(this).val());				
			});
			
			// Adding items
			currentContentEditorData = slide.find('.royalCaption .royalCaptionItem');		
			currentContentEditorData.each(function() {				
				addCaptionItem(captionsContainer, $(this));
			});			
			
			xInput = baseProps.find('#caption-x-pos').bind('change', function() {		
				updateCaptionProperty('left',$(this));				
			});
			yInput = baseProps.find('#caption-y-pos').bind('change', function() {		
				updateCaptionProperty('top',$(this));				
			});
			
			
			animationTypeRadio = animationOptions.find('input[type=radio]').change(function() {	
				isCustomEditing = false;
				if(lastCaptionSelected) {					
					var animType = $(this).val();
					var lastCaptionAnimType = lastCaptionSelected.attr('data-anim-type');					
					
					lastCaptionSelected.attr('data-anim-type', animType);
					
					if(animType === 'default' || animType === 'none') {
						animationOptions.find('.animation-settings-block').css('display', 'none');						
						if(lastCaptionAnimType === 'custom') {
							lastCaptionSelected.removeAttr('data-show-effect');							
							lastCaptionSelected.removeAttr('data-move-offset');
							lastCaptionSelected.removeAttr('data-delay');
							lastCaptionSelected.removeAttr('data-easing');
							lastCaptionSelected.removeAttr('data-speed');							
						}
					} else {						
						if(lastCaptionSelected) {	
							isCustomEditing = true;	
							// set default values to custom field if others aren't set
							if(lastCaptionAnimType === 'default'||  lastCaptionAnimType === 'none') {														
								lastCaptionSelected.attr('data-anim-type', 'custom');								
								setInputDefaultValue(durationInput, 'caption-show-speed');
								delayInput.val('auto');								
								setInputDefaultValue(fadeEffectCheckbox, 'fade-effect');
								setInputDefaultValue(moveEffectSelect, 'move-effect');
								setInputDefaultValue(moveDistance, 'caption-move-offset');								
							}							
						}						
						animationOptions.find('.animation-settings-block').css('display', 'block');						
					}
				}
			});			
			
			animationTypeRadio.eq(0).triggerHandler('change');			
			
			previewContainer.dialog({
				resizable: false,
				modal: true,
				width: (slideW < 752)  ? 820 : (slideW + 28),
				height: slideH + 275,
				title: 'Blocks Editor',				
				close: function() {					
					captionsContainer.children('.admin-caption-item').draggable('destroy').resizable('destroy');					
					saveNewCaptionsData();					
					previewContainer.dialog('destroy');
					previewContainer.remove();	
					$('this').remove();
					$('html').unbind('click.previewContainer');
				}
			});
		}
		function saveNewCaptionsData() {			
			//remove old captions
			currentSlideCaption.find('.royalCaptionItem').remove();
			
			//add new captions			
			var cItem;
			captionsContainer.children('.admin-caption-item').each(function() {
				cItem = $(this);
				cItem.removeClass('admin-caption-item rs-selected ui-resizable-autohide')
					.css('position', 'absolute')
					.addClass('royalCaptionItem')
					.appendTo(currentSlideCaption);				
			});			
		}
		function getSlideBgImage(slide) {
			var imgPath = slide.find('input[name="image"]').val();
			if(imgPath != undefined && imgPath != "") {			
				var wid = getOptionFromMainSidebar('slider-width');
				var hei = getOptionFromMainSidebar('slider-height');	
				if(getOptionFromMainSidebar('auto-generate-images')) {
					imgPath = pluginUrl + 'timthumb/timthumb.php?src=' + imgPath + '&w=' + ((wid.indexOf('%') < 0) ? wid : 600) + '&h=' + ((hei.indexOf('%') < 0) ? hei : 400) + '&q=100';					
				}				
				return imgPath;
			}
			return false;
		}
		
		function addCaptionItem(container, caption) {		
				var defaultValue;
				var captionItem;
				if(caption) {
					captionItem = caption.clone();
					captionItem.removeClass('royalCaptionItem');
					captionItem.addClass('admin-caption-item');					
					captionItem.appendTo(container);
					defaultValue = captionItem.text();
				} else {
					defaultValue = 'Block HTML text';
					captionItem = $('<div class="admin-caption-item no-style" data-anim-type="default"'+							
							'>' + defaultValue + '</div>').appendTo(container);
				}
				
				var listItem = $('<li class="ui-state-default">' + getSlicedCaptionText(defaultValue) + '<a class="ui-caption-remove" href="#" title="Delete caption"/>').appendTo(sortableCaptions);
				listItem.data('captionItem', captionItem);
				
				captionsArray.push(listItem);
				
				listItem.click(function() {			
					if(listItem.hasClass('list-item-selected')) {
						deselectCaption(captionItem, true);
						if(currentCaptionEditing == captionItem) {
							removeCaptionEditor();	
						}
					} else {
						setSelectedCaption(captionItem);
					}
				});
				
				listItem.find('a.ui-caption-remove').click(function(e) {
					e.preventDefault();					
					removeCaption(captionItem, listItem);
				});
				
				
				captionItem
				.resizable({ 
					handles: "all", 
					autoHide: true, 
					containment: 'parent',
					resize:function(event, ui) {					
						
					}
				})
				.draggable({ 							
					snap:'.admin-caption-item',
					snapTolerance: 5,
					cursor: 'move',
					/*handle: '.rs-handle',*/
					containment: 'parent',
					opacity: 0.5,
					drag:function(event, ui) {		
						var position = captionItem.position();
						xInput.val(position.left);
						yInput.val(position.top);
					}				
				}).dblclick(function(){		
					
					if(currentCaptionEditing != captionItem) {					
						removeCaptionEditor();							
						isEditing = true;
						captionItem.resizable('destroy');
						var oldHtml = captionItem.html();					
						captionItem.html('');								
						var captionTextArea = $('<textarea id="" name="caption-editor" cols="80" rows="10" class="all-options text-area-caption-editor">'+ oldHtml +'</textarea>').appendTo(captionItem);
						
						captionTextArea.focus();
						
						currentCaptionEditing = captionItem.addClass("rs-editor");					
					}
					
				}).click(function(e){
					e.preventDefault();					
					e.stopPropagation();
				})
				.mousedown(function(e) {						
					setSelectedCaption(captionItem);				
				});	
			return captionItem;
		}
		
		function getSlicedCaptionText(text) {			
			if(text && text !== ' ' && text !== '') {
				if(text.length > 18) {
					return text.substring(0, 17) + '...';
				}
				return text;
			} else {
				return 'No text content';
			}			
		}
		function updateCaptionProperty(prop, input) {
			if(lastCaptionSelected) {					
				var val = input.val();				
				if(!isNaN(val)) {
					lastCaptionSelected.css(prop,val+"px");
				}					
			}
		}
		function addCaptionStyle(cssCaptionStyleClass) {
			if(lastCaptionSelected) {			
				var cId;
				$(lastCaptionSelected.attr('class').split(' ')).each(function() {		
					cId = $.inArray(String(this), cssCaptionClassesArr);
					if(cId != -1) {
						lastCaptionSelected.removeClass(cssCaptionClassesArr[cId]);
					}					
				});
								
				lastCaptionSelected.data('skinClass',cssCaptionStyleClass);
				lastCaptionSelected.addClass(cssCaptionStyleClass);
			}
		}
		function getCaptionStyle(caption) {			
			var newCaptionStyle = '';
			if(caption.data('skinClass')) {				
				newCaptionStyle = caption.data('skinClass');
			} else {
				var cId;
				$(caption.attr('class').split(' ')).each(function() {							
					cId = $.inArray(String(this), cssCaptionClassesArr);
					if(cId != -1) {								
						newCaptionStyle = cssCaptionClassesArr[cId];			
						return;
					}					
				});
			} 
			return newCaptionStyle;
		}
		
		function setSelectedCaption(caption) {
			if(lastCaptionSelected != caption) {				
				var captionAnimType = caption.attr('data-anim-type');
				
				if(captionAnimType === 'custom') {					
					durationInput.val(caption.attr('data-speed'));
					
					var delayVal = caption.attr('data-delay');
					if(delayVal === '' || delayVal === 'auto' || isNaN(delayVal)) {
						delayInput.val('auto');
					} else {
						delayInput.val(delayVal);
					}
					
					easingTypeSelect.val(caption.attr('data-easing'));
					moveDistance.val(caption.attr('data-move-offset'));
					
					var moveEffect = 'none';
					var fadeEffect = false;
					var moveEffects = caption.attr('data-show-effect');
					
					if(moveEffects) {
						moveEffects = moveEffects.split(' ');				
						$(moveEffects).each(function(index){							
							if(this.indexOf('move') != -1) {							
								moveEffect = String(this);
							} else if(String(this) === 'fade') {
								fadeEffect = true;
							}					
						});								
					}					
					
					moveEffectSelect.val(moveEffect);
					
					fadeEffectCheckbox.attr('checked', fadeEffect);
				} 
								
				animationOptions.removeClass('hidden-group');
				baseProps.removeClass('hidden-group');
				
				deselectCaption(lastCaptionSelected);
								
				getCaptionListItem(caption.index()).addClass('list-item-selected');
				
				captionStyleSelect.val(getCaptionStyle(caption));
				
				if(caption.hasClass('non-draggable')) {
					dragEnabledCheckbox.attr('checked', false);
				} else {
					dragEnabledCheckbox.attr('checked', true);
				}
				
				caption.addClass('rs-selected');
				
				
				var pos = caption.position();
				xInput.val(pos.left);
				yInput.val(pos.top);				
				
				lastCaptionSelected = caption;
				
				animationTypeRadio.filter('[value=' + captionAnimType + ']').attr('checked', true).triggerHandler('change');
			}
		}
		function deselectCaption(caption, hideOptions) {			
			if(caption) {
				caption.removeClass('rs-selected');	
				getCaptionListItem(caption.index()).removeClass('list-item-selected');		
				lastCaptionSelected = '';
				if(hideOptions) {					
					baseProps.addClass('hidden-group');
					animationOptions.addClass('hidden-group');
				}
			}
		}
		function removeCaptionEditor() {
			if(currentCaptionEditing) {
				 var textArea = currentCaptionEditing.find('textarea[name="caption-editor"]');				
				 var newText = textArea.val();				 
				 if(newText) {
					 currentCaptionEditing.html(newText);
					 textArea.remove();
					 
					 currentCaptionEditing.resizable({ 
						 handles: "all", 
						 autoHide: true, 
						 containment: 'parent' 
					 });	
					 
					 isEditing = false;
					 
					
					
					 var listItem = getCaptionListItem(currentCaptionEditing.index());
					 var closeIcon = listItem.find('a.ui-caption-remove').detach();
					
					 listItem.html(getSlicedCaptionText(currentCaptionEditing.text()));
					 closeIcon.appendTo(listItem);
					
					 currentCaptionEditing.removeClass("rs-editor");
					 currentCaptionEditing = '';
				 } else {
					 removeCaption(currentCaptionEditing);
				 }							 
			 }
		}
		
		function getOptionFromMainSidebar(optionId) {			
			var obj = optionsContainer.find('#' + optionId);
			if(obj.is(':checkbox')) {
				return obj.is(':checked');
			} else {
				return obj.val();
			}			
		}
		
		function setInputValue(input, value) {
			if(input.is(':checkbox')) {
				input.attr('checked', value);
			} else {
				input.val(value);
			}
			
			var currInputId = input.attr('id');
			
			if(currInputId === 'my-caption-duration') {				
				lastCaptionSelected.attr('data-speed', value);
			} else if(currInputId === 'my-caption-delay') {
				if(value === 'auto' || isNaN(value)) {
					lastCaptionSelected.removeAttr('data-delay');					
				} else {
					lastCaptionSelected.attr('data-delay', value);
				}
			} else if(currInputId === 'my-caption-easing') {
				lastCaptionSelected.attr('data-easing', value);
			} else if(currInputId === 'my-caption-move-dist') {
				lastCaptionSelected.attr('data-move-offset', value);
			} else {
				var moveEffect = '';
				var fadeEffect = '';
				var moveEffects = lastCaptionSelected.attr('data-show-effect');
				
				if(moveEffects) {
					moveEffects = moveEffects.split(' ');				
					$(moveEffects).each(function(index){
						
						if(this.indexOf('move') != -1) {							
							moveEffect = String(this);
						} else if(String(this) === 'fade') {
							fadeEffect = 'fade';
						}					
					});	
					if(currInputId === 'my-caption-fade-effect') {
						if(value === true) {
							fadeEffect = 'fade';
						} else {
							fadeEffect = '';
						}						
					} else if(currInputId === 'my-caption-move-effect') {
						if(value != 'none') {
							moveEffect = value;
						} else {
							moveEffect = '';
						}
					} 
					lastCaptionSelected.attr('data-show-effect', moveEffect + ' ' + fadeEffect);
					
				} else {
					lastCaptionSelected.attr('data-show-effect', value);
				}				
			}
		}
	
		function setInputDefaultValue(input, mainOptionId) {
			setInputValue(input, getOptionFromMainSidebar(mainOptionId));
			input.trigger('change');
		}
		
		function getCaptionListItem(index) {
			return sortableCaptions.children(':eq(' + index + ')');
		}
		function removeCaption(caption, listItem) {
			if(currentCaptionEditing) {
				isEditing = false;				
				currentCaptionEditing = '';
			}
			
			if(listItem) {
				listItem.remove();
			} else {
				getCaptionListItem(caption.index()).remove();				
			}			
			
			caption.draggable('destroy');
			caption.resizable('destroy');
			caption.remove();
		}		
		
		function generateSliderJSOptions() {
			var opts = form2object('royalslider-options');
		
			var controlNav = opts.controlNavigationType;
			if(controlNav === 'none') {
				opts.controlNavEnabled = false;
			} else if(controlNav === 'bullets') {
				opts.controlNavEnabled = true;
				opts.controlNavThumbs = false;
			} else if(controlNav === 'thumbnails') {
				opts.controlNavEnabled = true;
				opts.controlNavThumbs = true;
				opts.controlNavThumbsNavigation = true;				
			}
			
			if(opts.captionAnimationEnabled) {
                var effects = [];
                if(opts.captionShowFadeEffect === true) {
                    effects.push('fade');                    
                }
                if(opts.captionShowMoveEffect && opts.captionShowMoveEffect != 'none') {
                    effects.push(opts.captionShowMoveEffect);   
                }
                opts.captionShowEffects = effects;
            }            
            return opts;
		}
		function generateSliderHTML() {
			
			var itemData;
			var newItem;
			var lazyLoading = getOptionFromMainSidebar('lazy-loading');
			var imgPath;
			var freeImgPath;
			var htmlContent;
			var htmlContentContainer;
			
			var thumbnailsEnabled = Boolean(getOptionFromMainSidebar('control-nav') === 'thumbnails');
			var thumbnailURL;
			
			var animatedBlocks;
			
			var slideURL;
			
			var newId;
			if(sliderID > 0) {
				newId = sliderID;				
			} else {
				newId = 'no-slider-id-set';
			}
			var wid = getOptionFromMainSidebar('slider-width');
			var hei = getOptionFromMainSidebar('slider-height');	
			
			
			
			
			var mainSliderHTML = $('<div id="royalslider-' + newId + '" class="royalSlider" '+
					'style="width:' + ((wid.indexOf('%') < 0) ? (wid + 'px') : wid) + '; '+
					'height:' + ((hei.indexOf('%') < 0) ? (hei + 'px') : hei) + ';"'+
					'></div>');			
			mainSliderHTML.addClass(getOptionFromMainSidebar('skin'));
			
			
			var slidesList = $('<ul class="royalSlidesContainer"></ul>');
			slidesList.appendTo(mainSliderHTML);
		
			slidesContainer.find('.slidecontainer').each(function(index){
				itemData = $(this);
				newItem = $('<li class="royalSlide"></li>');	        
				freeImgPath = imgPath = itemData.find('#image-path').val();				
				
				if(imgPath) {					
					
					if(getOptionFromMainSidebar('auto-generate-images')) {
						imgPath = pluginUrl + 'timthumb/timthumb.php?src=' + imgPath + '&w=' + ((wid.indexOf('%') < 0) ? wid : 600) + '&h=' + ((hei.indexOf('%') < 0) ? hei : 400) + '&q=100';					
					}
					
					if(lazyLoading) {
						newItem.attr('data-src', imgPath);
					} else {
						$('<img class="royalImage" src="' + imgPath + '"/>').appendTo(newItem);
					}
				}
				
				htmlContent = itemData.find('#html-content').val();
			
				if(htmlContent) {					
					htmlContentContainer = $('<div class="royalHtmlContent"></div>');
					$(htmlContent).appendTo(htmlContentContainer);					
					htmlContentContainer.appendTo(newItem)
				}			
				
				thumbnailURL = itemData.find('#thumb-path').val();
				
				
				
				
				if(thumbnailURL) {						
					newItem.attr('data-thumb', thumbnailURL);
				} else {
					var generateThumbs = getOptionFromMainSidebar('auto-generate-thumbs');
					var thumbWidth = getOptionFromMainSidebar('thumb-width');
					var thumbHeight = getOptionFromMainSidebar('thumb-height');
					if(generateThumbs && freeImgPath) {
						newItem.attr('data-thumb', pluginUrl + 'timthumb/timthumb.php?src=' + freeImgPath + '&w=' + thumbWidth + '&h=' + thumbHeight + '&q=100');
					}
				}
				
				slideURL = itemData.find('#link-url').val();
				if(slideURL) {
					$('<a class="royalSlideLink" href="' + slideURL + '" target="' + itemData.find('#link-target').val() + '"></a>').appendTo(newItem);
				}
				
				
				var animatedBlocks = itemData.find('.royalCaption');				
				if(animatedBlocks && animatedBlocks.children('.royalCaptionItem').length > 0 ) {			
					animatedBlocks = animatedBlocks.clone().removeClass('hidden');
					animatedBlocks.find('[data-anim-type="none"]').remove().appendTo(newItem);
					animatedBlocks.appendTo(newItem);
				}			
				
				newItem.appendTo(slidesList);
			});			
			return mainSliderHTML;
		}
		
		function saveSlider() {
			
			if (!isAjaxRunning) {
				isAjaxRunning = true;
			
				var sHTMLStr = generateSliderHTML();
				sHTMLStr = $('<div>').append(sHTMLStr.clone()).remove().html();
				var sliderSkin = getOptionFromMainSidebar('skin');
				
				var jsonOpts = JSON.stringify(generateSliderJSOptions());
				
				var preloadSkin = getOptionFromMainSidebar('preload-skin');
				preloadSkin = preloadSkin ? 1 : 0;
				
				saveProgressButton.removeClass('ajax-saved').html('');			
				
				saveButton.html('Saving...');				
				$.ajax({
					url: royalslider_ajax_vars.ajaxurl,
					type: 'post',
					data: {
						action : 'royalSliderSave',
						body : sHTMLStr,
						settings : jsonOpts,
						id : sliderID,
						skin : sliderSkin,
						preload_skin : preloadSkin,
						name : $('.royalslider-admin #title').val(),
						royalslider_ajax_nonce : royalslider_ajax_vars.royalslider_ajax_nonce
					},
					complete: function(data) {						
						
						if(!(sliderID > -1)) {
							$('#edit-slider-text').text('Edit RoyalSlider #' + data.responseText);							
						}
						if(parseInt(data.responseText, 10) > -1) {
							sliderID = parseInt(data.responseText, 10);							
						}
						saveButton.html('Save Slider');
						isUnsaved = false;
						saveProgressButton.html('Saved').addClass('ajax-saved').removeClass('unsaved');						
						
						isAjaxRunning = false;
					},
				    error: function(jqXHR, textStatus, errorThrown) { alert(textStatus); alert(errorThrown); }
				});
			}
		}
		function unsaved() {
			if(!isUnsaved) {
				saveProgressButton.addClass('unsaved');
				saveProgressButton.html('Unsaved');
				isUnsaved = true;
			}
			
		}
		function parseSliderDataNode() {			
			var adminSlides = $('<div></div>');
			
			if(sliderDataNode) {
				var dSlides = sliderDataNode.find('.royalSlide');				
				var dSlide;
				var imgPath;
				var tagImg;
				
				var adminSlideItem;
				
				var animBlocks;
				
				var thumbnailURL;
				
				var slideLink;
				
				dSlides.each(function(index) {
					dSlide = $(this);
					
					adminSlideItem = createAdminSlideItem();
					
					imgPath = dSlide.attr('data-src');
					
					
					if(!imgPath) {					
						tagImg = dSlide.find('.royalImage');
						if(tagImg) {
							imgPath = tagImg.attr('src');												
						} else {
							imgPath = '';
						}
					}					
					
					if(imgPath && imgPath != '' && getOptionFromMainSidebar('auto-generate-images')) {
						if(imgPath.indexOf('timthumb/timthumb.php') > 0) {							
							imgPath = getURLParameter('src', imgPath);
						}
					}
					adminSlideItem.find('#image-path').val(imgPath);		
					
					
					
					
					
					animBlocks = dSlide.find('.royalCaptionItem');
					
					if(animBlocks && animBlocks.length > 0) {
						animBlocks.appendTo(adminSlideItem.find('.royalCaption'));
					}
					
					
					
					thumbnailURL = dSlide.attr('data-thumb');
					if(thumbnailURL) {
						if(thumbnailURL.indexOf('timthumb/timthumb.php') > 0) {
							thumbnailURL = '';
						} else {
							adminSlideItem.find('#thumb-path').val(thumbnailURL);		
						}
					}
					
					
					
					adminSlideItem.find('#html-content').val(dSlide.find('.royalHtmlContent').html());
					
					slideLink = dSlide.find('.royalSlideLink');
					if(slideLink && slideLink.length > 0) {
						adminSlideItem.find('#link-url').val(slideLink.attr('href'));
						adminSlideItem.find('#link-target').val(slideLink.attr('target'));						
					}				
					
					adminSlideItem.appendTo(adminSlides);
				});
			}
			sliderDataNode.remove();
			adminSlides.appendTo(slidesContainer);
		}
		function parseSliderOptionsNode() {
			var sliderSettingsNode = $('#royal-slider-settings-data');	
			
			if(sliderSettingsNode && sliderSettingsNode.length > 0 ) {					
				populate(optionsContainer, jQuery.parseJSON(sliderSettingsNode.text()));				
				sliderSettingsNode.remove();
			}
		}
		function populate(frm, data) {
			var input;
			$.each(data, function(key, value){
				input =  $('[name='+key+']', frm);
				if(input.is(':checkbox')) {
					input.attr('checked', value);
				} else {
					input.val(value);
				}
			});
		}
		function getURLParameter(name, url) {
		    return decodeURI(
		        (RegExp(name + '=' + '(.+?)(&|$)').exec(url)||[,null])[1]
		    );
		}
		
		function createAdminSlideItem() {
			return $(
'<div class="postbox slidecontainer">'+
	'<div class="hidden royalCaption">'+		
	'</div>'+
	
	'<div class="dragdiv hndle"	title="Click and drag to reorder"><span class="dragicon"></span></div>'+
	'<div class="deletediv" title="Delete slide"></div>'+
	'<div class="duplicatediv" title="Clone slide"></div>'+

	
	'<div class="inside">'+
		'<div class="image-area"><img /></div>'+		
		'<div class="settings-area">'+							
			'<div class="settings-tabs">'+
			    '<ul>'+
			        '<li><a href="#tabs-1">Image</a></li>'+
			        '<li><a href="#tabs-2">Thumbnail</a></li>'+
			        '<li><a href="#tabs-3">HTML Content</a></li>'+
			        '<li><a href="#tabs-4">Link</a></li>'+
			    '</ul>'+
			    '<div id="tabs-1">'+
					'<input id="image-path" name="image" type="text" placeholder="Image URL" value="" />'+				
			    '</div>'+
			    '<div id="tabs-2">'+
			    	'<input id="thumb-path" name="main-thumb" type="text" placeholder="Thumbnail URL" value="" />'+
			    	'<a class="select-thumb-button button-secondary button80" href="#">Select thumbnail</a>	'+
			    '</div>'+
			    '<div id="tabs-3">'+
			        '<textarea id="html-content" cols="50" rows="3" placeholder="Static HTML content"></textarea>'+
			    '</div>'+
			    '<div id="tabs-4">'+
		    		'<input id="link-url" name="link-url" type="text" placeholder="URL" />'+	
		    		'<select id="link-target">'+
		    			'<option value="_self" selected>_self</option>'+	
		    			'<option value="_blank">_blank</option>'+
		    		'</select>'+
		    	'</div>'+
			'</div>'+
		
			'<a class="content-editor-button alignleft button-secondary button80" href="#">Open Blocks Editor</a>'+
			
		'</div>'+		
		'<div class="clear"></div>'+		
	'</div>'+
'</div>')
		}
	});
})(jQuery);

