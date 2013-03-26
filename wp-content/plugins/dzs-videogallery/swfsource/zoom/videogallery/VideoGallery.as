package zoom.videogallery
{
	/**
	 * ver 2.3
	 * @author Digital Zoom Studio 
	 * www.digitalzoomstudio.net
	 */
	import flash.display.*;
	import flash.media.*;
	import flash.events.*;
	import flash.ui.Mouse;
	//importing classes
	import flash.text.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.ui.*;
	import caurina.transitions.*;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.ColorShortcuts;
	import ca.newcommerce.youtube.data.*;
	import ca.newcommerce.youtube.events.*;
	import ca.newcommerce.youtube.feeds.*;
	import ca.newcommerce.youtube.iterators.*;
	import ca.newcommerce.youtube.webservice.YouTubeClient;
	
	import flash.system.System;
	
	import flash.external.ExternalInterface;
	
	import zoom.*;
	
	import com.SWFAddress;
	import com.SWFAddressEvent;
	
	
	//import uk.msfx.utils.tracing.Tr;
	
	public class VideoGallery extends MovieClip
	{
		
		private var source:String = "";
		private var xml:XML;
		private var xmlLoader:URLLoader = new URLLoader();
		private var i:int = 0; //for the 'for' instruction
		private var j:int = 0;
		private var k:int = 0;
		private var q:int = 0;
		
		private var buttonPos:int = 0;
		private var buttonCon:MovieClip = new MovieClip();
		private var menu:MovieClip;
		private var currVideo:MovieClip = null;
		private var currNr:int = -1;
		private var currAddress:String = "0";
		
		
		protected var _ws:YouTubeClient;
		protected var _requestId:Number;
		
		public var feedArray:Array = [];
		public var thumbArray:Array = [];
		public var titleArray:Array = [];
		public var descArray:Array = [];
		public var vdescArray:Array = [];
		public var typeArray:Array = [];
		public var prerollArray:Array = [];
		public var prerollLinkArray:Array = [];
		public var prerollTypeArray:Array = [];
		public var audioImageArray:Array = [];
		
		public var videoWidth:int = 0;
		public var videoHeight:int = 0;
		public var autoplay:String = "off";
		public var autoplayThumb:String = "";
		public var autoplayNextVideo:String = "off"
		public var menuPosition:String = "none";
		public var scrollbar:String = "off";
		public var youtubeFeed = "off";
		public var suggestedQuality = "hd720";
		public var shareButtonWidth = 32;
		public var shareButtonHeight = 32;
		public var cueFirstVideo:String = "on";
		public var shareButton = "off";
		public var embedButton = "off";
		public var logo = "";
		public var logoAlpha = 0.7;
		public var logoLink = "http://activeden.net/user/ZoomIt";
		public var streamServer = "";
		public var defaultVolume:Number = -1;
		public var scaleMode:String = 'proportional';
		
		public var youtubeFeed_user = "digitalzoomstudio";
		public var youtubeFeed_keywords = "";
		public var youtubeFeed_playlistId = "";
		public var youtubeFeed_maxResults = "20";
		public var fadeOnLeave:String = "off";
		
		private var mainArray:Array = [];
		public var videos:String = "";
		private var videosArray:Array = [];
		public var types:String = "";
		private var typesArray:Array = [];
		public var titles:String = "";
		private var titlesArray:Array = [];
		public var descriptions:String = "";
		public var descriptionsArray:Array = [];
		public var menuDescriptions:String = "";
		public var menuDescriptionsArray:Array = [];
		public var prerolls:String = "";
		public var prerollsArray:Array = [];
		public var prerollsTypes:String = "";
		public var prerollsTypesArray:Array = [];
		public var prerollsLinks:String = "";
		public var prerollsLinksArray:Array = [];
		public var audioImages:String = "";
		public var audioImagesArray:Array = [];
		public var thumbs:String = "";
		public var thumbsArray:Array = [];
		
		
		public var shareIcons:String = "";
		public var shareTooltips:String = "";
		public var shareLinks:String = "";
		
		public var htmlEmbedCode = "";
		public var wpEmbedCode = "";
		
		public var iconsArray = [];
		public var toolsArray = [];
		public var linksArray = [];
		
		public var user:String = "";
		public var keywords:String = "";
		public var maxResults = 20;
		
		public var numLoaded:int = 0;
		public var numTarget:int = 0;
		
		public var feedFromPlaylist:Boolean = false;
		
		public var share_screen:ShareScreen = new ShareScreen();
		
		
		
		public var logo_mc:MovieClip;
		
		public var prerolled:Boolean = false;
		public var prerollVideo:String = "";
		private var feeded:Boolean = false;
		private var firstTime:Boolean = true;
		
		private var tracker:String;
		private var tracked:Boolean;
		private var trackerOld:String;
		
		private var windowOpen:Boolean = false;
		
		//vars you will need to change if you modify the design
		public var controlsHeight:int = 28;
		public var scrubbarOffsetY:int = 10;
		
		public var settings_cache:String = "on";
		public var settings_deeplinking:String = "off";
		public var thumb_smoothing:String = 'on';
		
		public var scroller_gradientMask = "off";
		public var scroller_scrollOffset = 0;
		public var scroller_blurScroll = "on";
		public var scroller_scrollTime:Number = 0.9;
		
		public var player_scrubTextSpace:int = 3333;
		public var player_scrubbarWidth:int = 3333;
		public var player_scrubTextOffsetX:int = 3333;
		public var player_overlayControls:String = "3333";
		public var player_scrubTextColor:String = "#999999";
		public var player_design_disable_description:String = 'off';
		public var player_does_not_overlay_controls:String = "off";
		
		public var settings_yt_directthumb = "on";
		public var settings_disable_thumbs = "off";
		
		public var totalWidth:int = -1;
		public var totalHeight:int = -1;
		
		public var shuffleOnStart = 'off';
		public var disableInterface = "off";
		
		public var started:Boolean = false;
		
		public var isFullscreen = false;
		
		var tempNr:int = 0;
		var tempArray:Array = [];
		
		var vp_originalx = 0;
		var vp_originaly = 0;
		public var designXML:String = '';
		public var designer:XML;
		public var dsg_bg_width:int = -1;
		public var dsg_bg_height:int = -1;
		public var dsg_thumbs_bg:String = "-1";
		public var thumbs_space:int = 0;
		public var thumbs_borderc:String = "-1";
		public var menu_scroll_blur = 'on';
		public var menu_scroll_animation_time= 0.4;
		public var settings_nav_space:int = 0;
		public var thumb_borderWidth:uint = 2;
		public var thumb_borderColor:uint = 0xffffff;
		public var thumbs_pic_w = -1;
		public var thumbs_pic_h = -1;
		public var thumbs_pic_x = -1;
		public var thumbs_pic_y = -1;
		public var thumbs_text_w = -1;
		public var thumbs_text_h = -1;
		public var thumbs_text_title_c = '-1';
		public var thumbs_text_x = -1;
		public var thumbs_text_y = -1;
		public var pp_x = -1.1;
		public var pp_y = -1.1;
		public var pp_bg = '-1.1';
		public var scr_x = -1.1;
		public var scr_y = -1.1;
		public var scr_w = -1.1;
		public var scr_h = -1.1;
		public var scr_bg:String = '-1.1';
		public var scrl_bg:String  = '-1.1';
		public var scrp_bg:String  = '-1.1';
		public var vol_x = -1.1;
		public var vol_y = -1.1;
		public var vol_bg  = '-1.1';
		public var full_x = -1.1;
		public var full_y = -1.1;
		public var full_bg  = '-1.1';
		public var settings_bg  = '-1.1';
		public var settings_controls_bg = '-1.1';
		public var settings_controls_bg_h = -1.1;
		public var settings_disable_big_play = '-1.1';
		
		public function VideoGallery(){
			visible = false;
			DisplayShortcuts.init(); 
			ColorShortcuts.init();
		}
		public function feedxml(psource:String = "xml/gallery.xml")
		{
			if (feeded) return;
			//we start the gallery when it has entered stage
			source = psource;
			feeded = true;
			
			if(stage==null)
			addEventListener(Event.ADDED_TO_STAGE, init);
			else
			init(null);
		}
		public function init(e:Event) {
			var cacheString = "?cache=" + String(int(Math.random() * 999));
			
			if (settings_cache != "on")
			source += cacheString;
			
			
			//basic xml loading function
			xmlLoader.addEventListener(Event.COMPLETE, handleXML);
			xmlLoader.load(new URLRequest(source));
			
			
		}
		private function handleXML(e:Event){
			parseXML(e.target.data);
		}
		public function feedvars(){
			
			var xmlString:String = "";
			xmlString = '<content>\
			<settings>\
			<totalWidth>' + totalWidth + '</totalWidth>\
			<totalHeight>' + totalHeight + '</totalHeight>\
			<autoplay>' + autoplay + '</autoplay>\
			<autoplayNextVideo>' + autoplayNextVideo + '</autoplayNextVideo>\
			<thumb>' + autoplayThumb + '</thumb>\
			<menuPosition>' + menuPosition + '</menuPosition>\
			<scrollbar>' + scrollbar + '</scrollbar>\
			<youtubeFeed>' + youtubeFeed + '</youtubeFeed>\
			<youtubeFeed_user>' + youtubeFeed_user + '</youtubeFeed_user>\
			<youtubeFeed_keywords>' + youtubeFeed_keywords + '</youtubeFeed_keywords>\
			<youtubeFeed_playlistId>' + youtubeFeed_playlistId + '</youtubeFeed_playlistId>\
			<youtubeFeed_maxResults>' + youtubeFeed_maxResults + '</youtubeFeed_maxResults>\
			<suggestedQuality>' + suggestedQuality + '</suggestedQuality>\
			<cueFirstVideo>' + cueFirstVideo + '</cueFirstVideo>\
			<shareButton>' + shareButton + '</shareButton>\
			<shareButtonWidth>' + shareButtonWidth + '</shareButtonWidth>\
			<shareButtonHeight>' + shareButtonHeight + '</shareButtonHeight>\
			<embedButton>' + embedButton + '</embedButton>\
			<logo>' + logo + '</logo>\
			<logoAlpha>' + logoAlpha + '</logoAlpha>\
			<logoLink>' + logoLink + '</logoLink>\
			<streamServer>' + streamServer + '</streamServer>\
			<htmlEmbedCode>' + htmlEmbedCode + '</htmlEmbedCode>\
			<fadeOnLeave>' + fadeOnLeave + '</fadeOnLeave>\
			</settings>'
			
			iconsArray = String(shareIcons).split(';');
			toolsArray = String(shareTooltips).split(';');
			linksArray = String(shareLinks).split(';');
			
			for (i = 0; i < iconsArray; i++)
			xmlString+="<socialItem icon='" + iconsArray[i] + "' link='" + linksArray[i] + "' tooltip='" + toolsArray[i] + "'></socialItem>"
			
			
			
			//if (videos == '') videos = 'video/test.flv;video/test.flv';
			videosArray = videos.split(';');
			//types = 'video;video';
			typesArray = types.split(';');
			//titles = 'normal;normal';
	
			titlesArray = titles.split(';');
			//descriptions = 'normal;normal';
			descriptionsArray = descriptions.split(';');
			//menuDescriptions = 'normal;normal';
			menuDescriptionsArray = menuDescriptions.split(';');
			//prerolls = '';
			prerollsArray = prerolls.split(';');
			prerollsTypesArray = prerollsTypes.split(';');
			prerollsLinksArray = prerollsLinks.split(';');
			//thumbs = 'thumbs/slides.jpg';
			thumbsArray = thumbs.split(';');
			
			//thumbs = 'thumbs/slides.jpg';
			audioImageArray = audioImages.split(';');
			
			for (i = 0; i < videosArray.length; i++) {
				xmlString += '<item><source> ' + videosArray[i] + '</source>';
				xmlString += '<type>' + typesArray[i] + '</type>';
				
				if (thumbsArray[i] != undefined && String(thumbsArray[i])!='')
				xmlString += '<thumb>' + thumbsArray[i] + '</thumb>'
				if (titlesArray[i] != undefined)
				xmlString += '<title>' + titlesArray[i] + '</title>'
				if (descriptionsArray[i] != undefined)
				xmlString += '<description>' + descriptionsArray[i] + '</description>'
				if (menuDescriptionsArray[i] != undefined)
				xmlString += '<menuDescription>' + menuDescriptionsArray[i] + '</menuDescription>'
				if (prerollsArray[i] != undefined)
				xmlString += '<preroll>' + prerollsArray[i] + '</preroll>'
				if (prerollsTypesArray[i] != undefined)
				xmlString += '<preroll_type>' + prerollsTypesArray[i] + '</preroll_type>'
				if (prerollsLinksArray[i] != undefined)
				xmlString += '<preroll_link>' + prerollsLinksArray[i] + '</preroll_link>'
				
				if (audioImageArray[i] != undefined && String(audioImageArray[i])!='')
				xmlString += '<audioImage>' + audioImageArray[i] + '</audioImage>'
				
				
				
				
				
				xmlString+='</item>'
			}
			
			xmlString += '</content>';
			parseXML(xmlString);
		}
		private function parseXML(arg){
			//return;
			//when xml has loaded
			xml = new XML(arg);
			//navigateToURL(new URLRequest('javascript:console.log("' + xml + '")'),'_self');
			
			//navigateToURL(new URLRequest('javascript:console.log("' + autoplayNextVideo + '")'),'_self');
			//extracting data from xml
			autoplay = xml.settings.autoplay;
			autoplayThumb = xml.settings.thumb;
			menuPosition = xml.settings.menuPosition;
			autoplayNextVideo = xml.settings.autoplayNextVideo;
			totalWidth = xml.settings.totalWidth;
			totalHeight = xml.settings.totalHeight;
			scrollbar = xml.settings.scrollbar;
			youtubeFeed = xml.settings.youtubeFeed;
			embedButton = xml.settings.embedButton;
			shareButton = xml.settings.shareButton;
			logo = xml.settings.logo;
			logoAlpha = xml.settings.logoAlpha;
			logoLink = xml.settings.logoLink;
			streamServer = xml.settings.streamServer;
			if("defaultVolume" in xml.settings)
			defaultVolume = xml.settings.defaultVolume;
			
			if("disableDescription" in xml.settings)
			player_design_disable_description = xml.settings.disableDescription;
			if("designXML" in xml.settings)
			designXML = xml.settings.designXML;
			
			if("scroll_blur" in xml.settings)
			menu_scroll_blur = xml.settings.scroll_blur;
			
			if("scroll_animation_time" in xml.settings)
			menu_scroll_animation_time= xml.settings.scroll_animation_time;
			
			
			scaleMode = xml.settings.scaleMode;
			
			if("fadeOnLeave" in xml.settings)
			fadeOnLeave = xml.settings.fadeOnLeave;
			
			suggestedQuality = xml.settings.suggestedQuality;
			cueFirstVideo = xml.settings.cueFirstVideo;
			htmlEmbedCode = xml.settings.htmlEmbedCode;
			wpEmbedCode = xml.settings.wpEmbedCode;
			
			shuffleOnStart = xml.settings.shuffleOnStart;
			
			//Tr.ace("without the username or classname", Tr.DEFAULT, Class(getDefinitionByName(getQualifiedClassName(this))) );
			
			
			if (xml.settings.deeplinking == 'on')
			settings_deeplinking = 'on';
			
			
			if (totalWidth == -1) {
				totalWidth = stage.stageWidth;
				totalHeight = stage.stageHeight;
			}
			
			
			_ws = YouTubeClient.getInstance();
			if (xml.settings.youtubeFeed != "on")
			{
			_ws.addEventListener(VideoFeedEvent.VIDEO_DATA_RECEIVED, doSearchResults);
			
			
			for (k = 0; k < xml.item.length(); k++) {
				
				if(shuffleOnStart=='on')
				randomise(0, xml.item.length());
				else
				i = k;
				
				
				feedArray.push(xml.item[i].source);
				
				
				var sthumbArray:Array = [];
				if (xml.item[i].type == "video")
				{
					for (j = 0; j < xml.item[i].thumb.length();j++){
						sthumbArray.push(xml.item[i].thumb[j]);
						
					}
					
					
				}else{
					if (String(xml.item[i].thumb[0])=='' || xml.item[i].thumb[0]!=undefined){
						for (j = 0; j < xml.item[i].thumb.length();j++){
							sthumbArray.push(xml.item[i].thumb[j]);
							//trace(i + ' ' + xml.item[i].source + ': ' + xml.item[i].thumb[j]);
							
						}
					}
					else{
						if(xml.item[i].type=='youtube'){
						if (settings_yt_directthumb == "on"){
						sthumbArray.push("http://img.youtube.com/vi/" + xml.item[i].source + "/1.jpg");
						sthumbArray.push("http://img.youtube.com/vi/" + xml.item[i].source + "/2.jpg");
						sthumbArray.push("http://img.youtube.com/vi/" + xml.item[i].source + "/3.jpg");
						}else{
						_ws.getVideos(String(xml.item[i].source), "", null, null, null, null, YouTubeClient.ORDER_BY_PUBLISHED, YouTubeClient.RACY_INCLUDE, 1, 1);
						numTarget++;
						}
						
						}
					}
				}
				thumbArray.push(sthumbArray);
				titleArray.push(xml.item[i].title);
				descArray.push(xml.item[i].menuDescription);
				vdescArray.push(xml.item[i].description);
				typeArray.push(xml.item[i].type);
				prerollArray.push(xml.item[i].preroll);
				prerollTypeArray.push(xml.item[i].preroll_type);
				prerollLinkArray.push(xml.item[i].preroll_link);
				audioImageArray.push(xml.item[i].audioImage);
				
			}
			}
			else
			{
				if (String(xml.settings.youtubeFeed_playlistId) == ''){
					_ws.addEventListener(VideoFeedEvent.VIDEO_DATA_RECEIVED, handleSearchResults);
					_ws.getVideos(String(xml.settings.youtubeFeed_keywords),String(xml.settings.youtubeFeed_user), null, null, null, null, YouTubeClient.ORDER_BY_PUBLISHED, YouTubeClient.RACY_INCLUDE, 1, int(xml.settings.youtubeFeed_maxResults))
				}
				else{
					feedFromPlaylist = true;
					_ws.addEventListener(VideoFeedEvent.VIDEO_PLAYLIST_DATA_RECEIVED, handleSearchResults);
					_ws.getPlaylist(String(xml.settings.youtubeFeed_playlistId),1,int(xml.settings.youtubeFeed_maxResults))
				}
				
				numTarget++;
			}
			for (i = 0; i < xml.item.length(); i++) {
				if (xml.item[i].type == 'vimeo')
				if (xml.item[i].thumb == undefined || String(xml.item[i].thumb)=='') {
					var vimeo_xml_loader:URLLoader = new URLLoader();
					//vimeo_xml_loader.load(new URLRequest("http://vimeo.com/api/v2/video/" + xml.item[i].source + ".xml"));
					//vimeo_xml_loader.addEventListener(Event.COMPLETE, handle_vimeo_xml);
				}
			}
			
			//share setup
			if (shareButton == "on"){
				for (i = 0; i < xml.socialItem.length(); i++)
				iconsArray.push(xml.socialItem[i].@icon);
				
				for (i = 0; i < xml.socialItem.length(); i++)
				linksArray.push(xml.socialItem[i].@link);
				
				for (i = 0; i < xml.socialItem.length(); i++)
				toolsArray.push(xml.socialItem[i].@tooltip);
			}
			
			
			if (designXML != '')
				redesign();
				else
				justStartIt();
			
				
				
			trace('settings_deeplinkinking', settings_deeplinking);
				
			//if (isStolen()) visible = false;
			
		}
		
		private function redesign() {
			var dxmlLoader:URLLoader = new URLLoader();
			
			//trace('design: ', 'trying to load ' + designXML);
			dxmlLoader.addEventListener(Event.COMPLETE, redesign_xmlloaded);
			dxmlLoader.addEventListener(IOErrorEvent.IO_ERROR, justStartIt);
			dxmlLoader.load(new URLRequest(designXML));
		}
		private function redesign_xmlloaded(e:Event) {
			//trace('design: ', 'loaded ' + e.target.data);
			designer = new XML(e.currentTarget.data);
			dsg_bg_width = designer.thumbs_width;
			dsg_bg_height = designer.thumbs_height;
			thumbs_space = designer.thumbs_space;
			dsg_thumbs_bg = designer.thumbs_bg;
			dsg_thumbs_bg = dsg_thumbs_bg.substr(1);
			thumb_borderWidth = designer.thumbs_borderw;
			thumb_borderColor = designer.thumbs_borderc;
			thumbs_pic_w = designer.thumbs_pic_w;
			thumbs_pic_h = designer.thumbs_pic_h;
			thumbs_pic_x = designer.thumbs_pic_x;
			thumbs_pic_y = designer.thumbs_pic_y;
			thumbs_text_w = designer.thumbs_text_w;
			thumbs_text_h = designer.thumbs_text_h;
			thumbs_text_title_c = designer.thumbs_text_title_c;
			thumbs_text_x = designer.thumbs_text_x;
			thumbs_text_y = designer.thumbs_text_y;
			pp_x = designer.pp_x;
			pp_y = designer.pp_y;
			pp_bg = designer.pp_bg;
			pp_bg = pp_bg.substr(1);
			scr_x = designer.scr_x;
			scr_y = designer.scr_y;
			scr_w = designer.scr_w;
			scr_h = designer.scr_h;
			scr_bg = designer.scr_bg;
			scr_bg = scr_bg.substr(1);
			scrl_bg = designer.scrl_bg;
			scrl_bg = scrl_bg.substr(1);
			scrp_bg = designer.scrp_bg;
			scrp_bg = scrp_bg.substr(1);
			full_x = designer.full_x;
			full_y = designer.full_y;
			full_bg = designer.full_bg;
			full_bg = full_bg.substr(1);
			vol_x = designer.vol_x;
			vol_y = designer.vol_y;
			vol_bg = designer.vol_bg;
			vol_bg = vol_bg.substr(1);
			settings_bg = designer.settings_bg;
			settings_bg = settings_bg.substr(1);
			settings_controls_bg = designer.settings_controls_bg;
			settings_controls_bg = settings_controls_bg.substr(1);
			settings_controls_bg_h = designer.settings_controls_bg_h;
			player_does_not_overlay_controls = designer.settings_does_not_overlay_controls;
			player_overlayControls = designer.settings_does_not_overlay_controls;
			player_design_disable_description = designer.settings_disable_description;
			fadeOnLeave = designer.settings_fade_on_leave;
			
			
			//Tr.aceObject(, Tr.DEFAULT, Class(getDefinitionByName(getQualifiedClassName(this))) );
			justStartIt();
		}
		private function justStartIt(e:IOErrorEvent = null) {
			if (e != null){
			trace('it was a IO ERROR: loading design.xml :(');
			}
			if (numTarget == 0)
			start();
			else
			setTimeout(start, 3000);
			
		}
		
		private function handle_vimeo_xml(e:Event) {
			trace('handle_vimeo_xml');
			var vimeo_xml:XML = new XML(e.currentTarget.data);
			for (i = 0; i < xml.item.length(); i++) {
			if (String(vimeo_xml.video.id) == String(xml.item[i].source))
			
			MovieClip(buttonCon.getChildAt(i)).thumb_mc.getChildByName('thumb').feedvars([String(vimeo_xml.video.thumbnail_small)], 50, 50);
			//MovieClip(MovieClip(buttonCon.getChildAt(i)).getChildByName('thumb')).feedvars('thumbs/pages1.jpg');
			}
			//trace(vimeo_xml.video.thumbnail_small);
		}
		
		
		
		protected function doSearchResults(evt:VideoFeedEvent):void{
			
			var feed:VideoFeed = evt.feed;
			var video:VideoData;
			trace("doSearchResults()");
			
			if (feed == null){
			
			numLoaded++;
			numTarget--;
			if (numLoaded == numTarget)
			start()
			
			return;
			}
			
			if (feed._entries == null) {
			
			numLoaded++;
			numTarget--;
			if (numLoaded == numTarget)
			start()
			
			return;
			}
			numLoaded++;
			video = feed.first();
			
			
			
			
			var j:int = 0;
			for (i = 0; i < feedArray.length; i++) {
				trace('video.actualId: ' + video.actualId);
				trace('feedArray: ' + feedArray[i]);
				if (String(video.actualId) == String(feedArray[i])){
					j = i;
				}
			}
			
			
			
			var tnIt:ThumbnailIterator = video.media.thumbnails;
			var tn:ThumbnailData;
			
			var tarray:Array = [];
			while(tn = tnIt.next()){
			tarray.push(tn.url);
			}
			var auxArray:Array = [];
			
			auxArray = thumbArray.slice(j + 1);
			thumbArray.splice(j)
			
			
			thumbArray.push(tarray)
			for (i = 0; i < auxArray.length; i++)
			{
				thumbArray.push(auxArray[i]);
				
			}
			if (numLoaded == numTarget)
			start()
			
			
			
			//thumbArray.push(tarray);
		}
		protected function handleSearchResults(evt:VideoFeedEvent):void	{
			var aux:String = "";
			var feed:VideoFeed = evt.feed;
			var video:VideoData;
			
			while (video = feed.next()){
			
			
			if (feedFromPlaylist == true){
			aux = video.links.first().href;
			feedArray.push(String(aux).slice(31, 42));
			}
			else
			feedArray.push(video.actualId);
			
			
			
			typeArray.push("youtube");
			titleArray.push(video.title);
			descArray.push(video.content)
			vdescArray.push(video.content);
			
			
			prerollArray.push('');
				
			var tnIt:ThumbnailIterator = video.media.thumbnails;
			var tn:ThumbnailData;
			var tarray:Array = [];
			while(tn = tnIt.next()){
			tarray.push(tn.url);
			}
			
			thumbArray.push(tarray)
			
			
			}
			if (shuffleOnStart == 'on') {
				var shuffleArray:Array = [];
				
				for (k = 0; k < feedArray.length; k++) {
					randomise(0, feedArray.length);
					shuffleArray.push(i);
				}
				//trace("******************THUMBS ARRAY****************");
				for(var mc:String in thumbsArray)
				//trace("******************/THUMBS ARRAY****************");
				randomiseArrays([titleArray,feedArray,thumbsArray,descArray,vdescArray],shuffleArray);//, descArray, vdescArray, thumbArray
			}
			start();
		}
		private function randomiseArrays(arg:Array,sarg:Array) {
			for (i = 0; i < arg.length; i++){
			var auxArray:Array = [];
			auxArray = arg[i].concat();
			
			trace('init***************************')
			
			for (j = 0; j < arg[i].length; j++){
			trace('j: ' + j + ' sarg j : ' + sarg[j]);
			
			arg[i][sarg[j]] = auxArray[j];
			}
			
			trace('init***************************')
			trace(auxArray);
			trace('final***************************')
			trace(arg[i])
			}
			
			
			//newArray.push(array.splice(Math.floor(Math.random()*array.length), 1));
			
		}
		private function start(){
			if (started)
			return;
			
			started = true;
			
			//VERTICAL MENU ARRANGEMENT
			trace(' menu_scroll_animation_time',  menu_scroll_animation_time);
			menu = new Scroller();
			menu.gradientMask = scroller_gradientMask;
			menu.scrollOffset = scroller_scrollOffset;
			menu.blurScroll = scroller_blurScroll;
			menu.scrollTime = scroller_scrollTime;
			menu.blurScroll = menu_scroll_blur;
			menu.scrollTime = menu_scroll_animation_time;
			
			//if (shuffleOnStart == 'on'){
			//randomiseArrays([feedArray, thumbArray, descArray, descriptionsArray, iconsArray, prerollArray
			
			var title_color = '#68B7E6';
			if (thumbs_text_title_c != '-1')
			title_color = thumbs_text_title_c;
		    var sheet:StyleSheet = new StyleSheet();
			sheet.parseCSS("h4{ font-size: 14px; color:" + title_color + "; }");
			
			trace(' ');
			trace('design dsg_bg_height: ', dsg_bg_height);
			for (i = 0; i < feedArray.length; i++) {
				//trace("building menu: ", i);
				var button_mc:MovieClip = new Button();
				if (dsg_bg_width > -1)
				button_mc.bg_mc.width = dsg_bg_width;
				if (dsg_bg_height > -1)
				button_mc.bg_mc.height = dsg_bg_height;
				
				if (thumbs_pic_w > -1)
				button_mc.thumb_mc.width = thumbs_pic_w;
				
				if (thumbs_pic_h > -1)
				button_mc.thumb_mc.height = thumbs_pic_h;
				if (thumbs_pic_x > -1)
				button_mc.thumb_mc.x = thumbs_pic_x;
				if (thumbs_pic_y> -1)
				button_mc.thumb_mc.y = thumbs_pic_y;
				
				if(dsg_thumbs_bg!='-1'){
				var thecolor:ColorTransform = new ColorTransform();
				thecolor.color = uint("0x" + dsg_thumbs_bg);
				button_mc.bg_mc.transform.colorTransform = thecolor;
				}
				
				
				var thumb_mc:Thumb = new Thumb();
				thumb_mc.borderColor = thumb_borderColor;
				thumb_mc.bw = thumb_borderWidth;
				thumb_mc.smoothing = 'off';
				if(settings_disable_thumbs=='on'){
				thumb_mc.visible = false;
				button_mc.thumb_mc.visible = false;
				}
				thumb_mc.feedvars(thumbArray[i], 50, 50);
				
				if (menuPosition == "right" || menuPosition == "left"){
				button_mc.x = 0
				button_mc.y = buttonPos;
				buttonPos += button_mc.bg_mc.height + thumbs_space;
				
				if(button_mc.bg_mc.right_bar)
				button_mc.bg_mc.right_bar.visible = false;
				}
				if (menuPosition == "down" || menuPosition == "up"){
				button_mc.x = buttonPos
				button_mc.y = 0;
				buttonPos += button_mc.bg_mc.width + thumbs_space;
				
				if(button_mc.bg_mc.down_bar)
				button_mc.bg_mc.down_bar.visible = false;
				}
			
				if (button_mc.text_txt) {
					button_mc.text_txt.styleSheet = sheet;
				}
				if(titleArray[i] && button_mc.hasOwnProperty('text_txt'))
				button_mc.text_txt.htmlText = '<h4>' + titleArray[i] + '</h4>';
				
				
				var desc:String = descArray[i];
				if (desc.length > 105)
				{
					desc = desc.substr(0, 105);
					desc+=" [...]"
				}
				
				if (button_mc.text_txt) {
				if (thumbs_text_w > -1)
				button_mc.text_txt.width = thumbs_text_w;
				if (thumbs_text_h > -1)
				button_mc.text_txt.height = thumbs_text_h;
				if (thumbs_text_x > -1)
				button_mc.text_txt.x = thumbs_text_x;
				if (thumbs_text_y > -1)
				button_mc.text_txt.y = thumbs_text_y;
				button_mc.text_txt.htmlText += desc;
				}
				
			
				
				button_mc.thumb_mc.addChild(thumb_mc);
				button_mc.mouseChildren = false;
				button_mc.buttonMode = true;
				button_mc.addEventListener(MouseEvent.ROLL_OVER, handleButton)
				button_mc.addEventListener(MouseEvent.ROLL_OUT, handleButton)
				button_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleButton)
				
				buttonCon.addChild(button_mc);
				
			}
			
			videoWidth = int(totalWidth);
			videoHeight = int(totalHeight);
			
			if (menuPosition == "right"){
			menu.feedvars(buttonCon, MovieClip(buttonCon.getChildAt(0)).bg_mc.width, int(totalHeight), "ver", scrollbar);
			menu.x = int(totalWidth) - MovieClip(buttonCon.getChildAt(0)).bg_mc.width;
			
			videoWidth = int(totalWidth) - MovieClip(buttonCon.getChildAt(0)).bg_mc.width
			videoHeight = int(totalHeight);
			}
			
			if (menuPosition == "down"){
			menu.feedvars(buttonCon, int(totalWidth), MovieClip(buttonCon.getChildAt(0)).bg_mc.height,"hor",scrollbar);
			menu.y = int(totalHeight) - MovieClip(buttonCon.getChildAt(0)).bg_mc.height;
			
			videoWidth = int(totalWidth);
			videoHeight =int(totalHeight) - MovieClip(buttonCon.getChildAt(0)).bg_mc.height
			}
			
			
			if (menuPosition == "up"){
			menu.feedvars(buttonCon, int(totalWidth), MovieClip(buttonCon.getChildAt(0)).bg_mc.height,"hor",scrollbar);
			menu.y = 0;
			
				vp_originalx = 0;
				vp_originaly = MovieClip(buttonCon.getChildAt(0)).bg_mc.height + settings_nav_space;
			videoWidth = int(totalWidth);
			videoHeight = int(totalHeight) - MovieClip(buttonCon.getChildAt(0)).bg_mc.height;
			}
			if (menuPosition == "left"){
			menu.feedvars(buttonCon, MovieClip(buttonCon.getChildAt(0)).bg_mc.width, int(totalHeight), "ver", scrollbar);
			menu.x = 0;
			
				vp_originalx = MovieClip(buttonCon.getChildAt(0)).bg_mc.width + settings_nav_space;
				vp_originaly = 0;
			videoWidth = int(totalWidth) - MovieClip(buttonCon.getChildAt(0)).bg_mc.width
			videoHeight = int(totalHeight);
			}
			
			addChild(menu);
			
			
			//share setup
			if (shareButton == "on"){
				
				
				share_screen.init(totalWidth, totalHeight, shareButtonWidth, shareButtonHeight, iconsArray, linksArray,toolsArray);
				addChild(share_screen);
				
				share_mc.buttonMode = true;
				share_mc.mouseChildren = false;
			}
			
			if (embedButton == "on"){
				embed_mc.visible = true;
				embed_mc.window_mc.visible = false;
				
				embed_mc.window_mc.alpha = 0;
				embed_mc.window_mc.x = 55;
				
				
			}
			
			//load logo
			if (String(logo) != ''){
				logo_mc = new Asset(logo);
				logo_mc.alpha = logoAlpha;
				logo_mc.buttonMode = true;
				
				logo_mc.addEventListener(MouseEvent.ROLL_OVER, function onRoll(e:MouseEvent) { Tweener.addTween(e.currentTarget, { alpha:0.9, time:0.5 } );  });
				logo_mc.addEventListener(MouseEvent.ROLL_OUT, function onRollO(e:MouseEvent) { Tweener.addTween(e.currentTarget, { alpha:Number(logoAlpha), time:0.5 } );  });
				logo_mc.addEventListener(MouseEvent.MOUSE_DOWN, logo_click);
				
				logo_mc.addEventListener("loaded", positionLogo, false, 0, true);
				addChild(logo_mc);
			}
			
			
			if (cueFirstVideo == 'on') {
				if(settings_deeplinking!='on')
				gotoItem(0);
			}
			else
			{
				autoplay = "on";
				var placeholder_mc:MovieClip = new Thumb();
				placeholder_mc.feedvars([autoplayThumb], videoWidth, videoHeight);
				placeholder_mc.name = 'placeholder';
				placeholder_mc.buttonMode = true;
				placeholder_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleButton);
				addChild(placeholder_mc);
				
				
				autoplayThumb = "";
			}
			
			
			
			//navigateToURL(new URLRequest('http://google.ro'),'_blank');
			
			
			
			
			hideShareButton();
			showShareButton();
			
			//logo_mc.name = "logo_mc";
			
			
			
			embed_mc.btn_mc.buttonMode = true;
			embed_mc.btn_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleEmbed);
			
			if (ExternalInterface.available)
			var pageURL:String =ExternalInterface.call('window.location.href.toString');
			if (pageURL != null){
			if (pageURL.indexOf(".html") > -1) {
				var aux = pageURL.split("/");
				var aux2 = '';
				for (i = 0; i < aux.length-1; i++) {
					aux2 += aux[i] + "/";
				}
				//navigateToURL(new URLRequest(aux2), "_blank");
				pageURL = aux2;
			}
			//var pageURL:String = loaderInfo.url.toString();
			trace('pageurl: ' + pageURL);
			
			htmlEmbedCode = htmlEmbedCode.split("%pageURL%").join(pageURL);
			}
    // She sells seaschells by the seashore.
			
			embed_mc.window_mc.html_mc.html_txt.text = htmlEmbedCode;
			embed_mc.window_mc.html_mc.buttonMode = true;
			embed_mc.window_mc.html_mc.mouseChildren = false;
			embed_mc.window_mc.html_mc.alpha = 0.7;
			embed_mc.window_mc.html_mc.addEventListener(MouseEvent.ROLL_OVER, function onRoll(e:MouseEvent) { Tweener.addTween(e.currentTarget, { alpha:1, time:0.7 } ); } );
			embed_mc.window_mc.html_mc.addEventListener(MouseEvent.ROLL_OUT, function onRoll(e:MouseEvent) { Tweener.addTween(e.currentTarget, { alpha:0.7, time:0.7 } ); } );
			embed_mc.window_mc.html_mc.addEventListener(MouseEvent.MOUSE_DOWN, function onHtml(e:MouseEvent) { System.setClipboard(String(embed_mc.window_mc.html_mc.html_txt.text)) } );
			
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullscreen);
			share_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleShare);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			
			stage.addEventListener(MouseEvent.CLICK, test_click);
			
				if (settings_deeplinking == "on" && ExternalInterface.available && disableInterface!='on'){
				SWFAddress.addEventListener(SWFAddressEvent.CHANGE, handleSWFAddress);
				//handleSWFAddress(null);
				}else {
					
				}
			
			//navigateToURL(new URLRequest('javascript:alert("a: ' + disableInterface + ' b: ' + String(disableInterface=='on') + '")'), '_self');
				
			if(ExternalInterface.available && disableInterface!='on'){
			ExternalInterface.addCallback('pauseVideo', pauseMovie);
			ExternalInterface.addCallback('nextVideo', gotoNext);
			ExternalInterface.addCallback('gotoItem', gotoItem);
			ExternalInterface.addCallback('gi', gotoItem);
			}
			
			dispatchEvent(new Event('loaded'));
			
			visible = true;
			
		}
		private function reallyStartIt() {
			
		}
		private function handleSWFAddress(e:SWFAddressEvent) {
			
			
			//navigateToURL(new URLRequest('javascript:alert("a: ' + "ceva" + ' ")'), '_self');
			var aux:String = String(SWFAddress.getValue()).slice(1);
			//navigateToURL(new URLRequest('javascript:alert("a: ' + aux + ' ")'), '_self');
			if (aux != currAddress) {
				gotoItem(int(aux));
			}
		}
		private function logo_click(e:MouseEvent) {
			//navigateToURL(new URLRequest('javascript:console.log("' + e.target.name + '")'), '_self');
			navigateToURL(new URLRequest(logoLink));
			
		}
		public function test_click(e:MouseEvent) {
			//navigateToURL(new URLRequest('javascript:console.log("' + e.target.name + '")'),'_self');
		}
		public function disableControls() {
			menu.alpha = 0.7;
			mouseChildren = false;
			mouseEnabled = false;
		}
		public function enableControls(){
			menu.alpha = 1;
			mouseChildren = true;
			mouseEnabled = true;
		}
		public function handleEmbed(e:MouseEvent)
		{
			if (windowOpen){
				Tweener.addTween(embed_mc.window_mc, { _autoAlpha:0, time:0.7 } );
				Tweener.addTween(embed_mc.window_mc, { x:55, time:0.7, rounded:true } );
				windowOpen = false;
			}
			else{
				Tweener.addTween(embed_mc.window_mc, { _autoAlpha:1, time:0.7 } );
				Tweener.addTween(embed_mc.window_mc, { x:70, time:0.7, rounded:true } );
				windowOpen = true;
			}
			 
			
		}
		private function handleButton(e:MouseEvent)
		{
			if (e.currentTarget.name == 'placeholder'){
			gotoItem(0)
			return;
			}
			
			if (buttonCon.getChildIndex(DisplayObject(e.currentTarget)) != currNr)
			{
			if (e.type == "rollOver"){
				Tweener.addTween(e.currentTarget.bg_mc, { _frame:30, time:.7 } );
				if(e.currentTarget.hasOwnProperty("thumb_mc")){
				if (e.currentTarget.getChildByName("thumb_mc").getChildByName("thumb")!=null) {
				Thumb(e.currentTarget.getChildByName("thumb_mc").getChildByName('thumb')).startSlideshow();
				}
				}
			}
			if (e.type == "rollOut"){
				Tweener.addTween(e.currentTarget.bg_mc, { _frame:1, time:.7 } );
				if(e.currentTarget.hasOwnProperty("thumb_mc"))
				if (e.currentTarget.getChildByName("thumb_mc").getChildByName("thumb")!=null)
				Thumb(e.currentTarget.getChildByName("thumb_mc").getChildByName('thumb')).stopSlideshow();
			}
			if (e.type == "mouseDown") {
				gotoItem(buttonCon.getChildIndex(DisplayObject(e.currentTarget)));
				Thumb(e.currentTarget.getChildByName("thumb_mc").getChildByName('thumb')).stopSlideshow();
			}
			}
		}
		public function isImage(arg:String) {
			if (arg!=null && ((arg.indexOf('.jpg') > -1) || (arg.indexOf('.png') > -1) || (arg.indexOf('.gif') > -1)))
			return true;
			
			return false;
		}
		public function gotoItem(arg:int){
			if (typeArray[arg] == "link"){
				navigateToURL(new URLRequest(feedArray[arg]), "_blank");
				return;
			}
			
			showPreloader();
			
			//function which loads a specific video
			if (currVideo != null){
				currVideo.removeEventListener("videoEnded", handleVideoEnd);
				
				if (prerolled == true){
				currVideo.destroyAlt();
				}
				else
				currVideo.destroy();
				//build it video player function which destroys all events
			}
			
			if (currNr != -1 && menuPosition!='none'){
				Tweener.addTween(MovieClip(buttonCon.getChildAt(currNr)).bg_mc, { _frame:1, time:.7 } );
				//Tweener.addTween(MovieClip(buttonCon.getChildAt(currNr)).text_txt, { _color:0xFFFFFF, time:.7 } );
			}
			
			currNr = arg;
			if(menuPosition!='none'){
			Tweener.addTween(MovieClip(buttonCon.getChildAt(currNr)).bg_mc, { _frame:60, time:.7 } );
			//Tweener.addTween(MovieClip(buttonCon.getChildAt(currNr)).text_txt, { _color:0x000000, time:.7 } );
			}
			
			
			
			var video_mc:MovieClip;
			var videofeed:String = feedArray[arg];
			var type:String = typeArray[arg];
			
			if (prerolled == true){
				prerolled = false;
				enableControls();
			}else{
			if (String(prerollArray[arg]) != '' && isImage(prerollArray[arg])==false){
				videofeed = prerollArray[arg];
				if (prerollTypeArray[arg] != '')
				type = prerollTypeArray[arg];
				
				prerolled = true;
				disableControls();
			}
			}
			
			if (menuPosition == "none")
				menu.visible = false;
			
			
			video_mc = new VideoPlayer();
			
			if(player_scrubbarWidth!=3333)
			video_mc.scrubbarWidth = player_scrubbarWidth;
			if(player_scrubTextOffsetX!=3333)
			video_mc.scrubTextOffsetX = player_scrubTextOffsetX;
			if(player_scrubTextSpace!=3333)
			video_mc.scrubTextSpace = player_scrubTextSpace;
			if(player_overlayControls!="3333")
			video_mc.overlayControls = player_overlayControls;
			
			//player_does_not_overlay_controls
			
			video_mc.player_scrubTextColor = player_scrubTextColor;
			video_mc.design_disable_description = player_design_disable_description;
			
			video_mc.fadeOnLeave = fadeOnLeave;
			
			
			if(youtubeFeed!='on'){
			if("hdsource" in xml.item[arg]) {
				video_mc.hdsource = xml.item[arg].hdsource;
			}
			}
			
			if (feedArray.length == 1) video_mc.isSingle = true;
			
			
			if (typeArray[arg] == 'audio')
			autoplayThumb = audioImageArray[arg];
			
			if (isImage(prerollArray[arg]) == true) {
			video_mc.ad_image = prerollArray[arg];
			video_mc.ad_image_link = prerollLinkArray[arg];
			autoplay = 'off';
			}
			
			//navigateToURL(new URLRequest(String(defaultVolume)));
			if (firstTime == true&&defaultVolume>-1)
			video_mc.defaultVolume = defaultVolume;
			
			firstTime = false;
			video_mc.scaleMode = scaleMode;
			
			
			trace(scr_bg, scrl_bg, scrp_bg, settings_bg);
			video_mc.pp_x = pp_x;
			video_mc.pp_y = pp_y;
			video_mc.pp_bg = pp_bg;
			video_mc.scr_x = scr_x;
			video_mc.scr_y = scr_y;
			video_mc.scr_w = scr_w;
			video_mc.scr_h = scr_h;
			video_mc.scr_bg = scr_bg;
			video_mc.scrl_bg = scrl_bg;
			video_mc.scrp_bg = scrp_bg;
			video_mc.vol_x = vol_x;
			video_mc.vol_y = vol_y;
			video_mc.vol_bg = vol_bg;
			video_mc.full_x = full_x;
			video_mc.full_y = full_y;
			video_mc.full_bg = full_bg;
			video_mc.settings_bg = settings_bg;
			video_mc.settings_controls_bg = settings_controls_bg;
			video_mc.settings_controls_bg_h = settings_controls_bg_h;
			video_mc.settings_disable_big_play = settings_disable_big_play;
			
			video_mc.feedvars(videofeed, videoWidth, videoHeight, autoplay, autoplayThumb, vdescArray[arg], type, suggestedQuality, autoplayNextVideo, streamServer);
			
			if (menuPosition == 'up')
			video_mc.y = totalHeight - videoHeight;
			if (menuPosition == 'left')
			video_mc.x = totalWidth - videoWidth;
			
			if (prerolled == true) video_mc.preroll = true;
			video_mc.controlsHeight = controlsHeight;
			video_mc.disableInterface = disableInterface;
			
			autoplay = "on";
			autoplayThumb = "";
			video_mc.alpha = 0;
			
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
			video_mc.wasFullscreen = true;
			
			currVideo = video_mc;
			
			Tweener.addTween(currVideo, { alpha:1, time:1 } );
			addChild(currVideo);
			
			
			if(this.getChildByName('placeholder')!=null)
			Tweener.addTween(MovieClip(this).getChildByName('placeholder'), { _autoAlpha:0, time:.7,onComplete:removeIt,onCompleteParams:[this.getChildByName('placeholder')] } );
			
			if (logo_mc != null)
			setChildIndex(logo_mc, numChildren - 1);
			setChildIndex(share_mc, numChildren - 1);
			
			
			
			
			setChildIndex(embed_mc, numChildren - 1);
			
			
			
			if(this.hasOwnProperty("preloader_mc")){
			setChildIndex(MovieClip(this).preloader_mc, numChildren - 1);
			MovieClip(this).preloader_mc.x = videoWidth / 2;
			MovieClip(this).preloader_mc.y = videoHeight / 2;
			
			}
			
			
				if (settings_deeplinking == "on" && ExternalInterface.available && disableInterface != 'on') {
					currAddress = String(arg);
					SWFAddress.setValue(String(arg));
				}
				
			if (contains(share_screen))
			setChildIndex(share_screen, numChildren - 1);
			
			currVideo.addEventListener("videoEnded", handleVideoEnd,false,0,true);
			currVideo.addEventListener("loaded", hidePreloader,false,0,true);
		}
		public function hidePreloader(e:Event = null) {
			if(this.hasOwnProperty("preloader_mc"))
			Tweener.addTween(MovieClip(this).preloader_mc, { _autoAlpha:0, time:2 } );
		}
		private function showPreloader(e:Event = null) {
			
			if(this.hasOwnProperty("preloader_mc"))
			Tweener.addTween(MovieClip(this).preloader_mc, { _autoAlpha:1, time:0.5 } );
		}
		private function removeIt(arg:Object) {
			if(contains(DisplayObject(arg)))
			removeChild(DisplayObject(arg));
		}
		public function handleVideoEnd(e:Event)
		{
			//when a video reaches end, goto the next one
			gotoNext();
		}
		public function gotoNext() {
			var temp:int = currNr;
			if (!prerolled)
			temp++;
			
			if (temp >= feedArray.length) temp = 0;
			gotoItem(temp);
		}
		
		
		public function hideShareButton(){
			share_mc.visible = false;
			embed_mc.visible = false;
			
			if (logo_mc != null && xml.settings.keep_logo_on_fullscreen != 'on')
			logo_mc.visible = false;
			else
			positionLogo(null);
		}
		public function showShareButton(){
			if (shareButton == "on")
			share_mc.visible = true;
			
			if (embedButton == "on")
			embed_mc.visible = true;
			
			if (logo_mc != null)
			logo_mc.visible = true;
			
			
			positionLogo(null);
		}
		public function handleShare(e:MouseEvent){
			
			
			share_screen.openTransition();
		}
		public function positionLogo(e:Event) {
			if (logo_mc == null)
			return;
			
			logo_mc.y = 5;
			if (menuPosition == "right" || menuPosition == "left") {
				if (isFullscreen) {
					
			logo_mc.x = int(stage.stageWidth) - logo_mc.l.width - 5;
			//navigateToURL(new URLRequest('javascript:console.log("' + logo_mc.x + '")'),'_self');
				}else{
			logo_mc.x = int(totalWidth) - MovieClip(buttonCon.getChildAt(0)).bg_mc.width - logo_mc.l.width - 5;
				}
			}
			if (menuPosition == "down")
			logo_mc.x = int(totalWidth) - logo_mc.l.width-5;
			if (menuPosition == "none")
			logo_mc.x = int(totalWidth) - logo_mc.l.width - 5;
			
			
		}
		public function handleRemove(e:Event){
			if (currVideo != null){
				currVideo.destroy();
			}
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handleFullscreen);
		}
		public function pauseMovie() {
			//navigateToURL(new URLRequest('javascript:console.log("' + 'ceva' + '")'),'_self');
			
			
			if (currVideo != null)
			currVideo.pauseMovie();
		}
		public function playMovie() {
			if (currVideo != null)
			currVideo.playMovie();
		}
		private function handleFullscreen(e:FullScreenEvent) {
			if (stage.displayState == StageDisplayState.FULL_SCREEN){
				menu.visible = false;
				currVideo.x = 0;
				currVideo.y = 0;
				//navigateToURL(new URLRequest('javascript:console.log("' + currVideo.x + '")'),'_self');
				//setChildIndex(currVideo, getChildIndex(menu));
				//if(logo!=null)
				//setChildIndex(logo_mc, numChildren - 1);
				isFullscreen = true;
			} else {
				trace(vp_originalx, vp_originaly);
				currVideo.x = vp_originalx;
				currVideo.y = vp_originaly;
				if (menuPosition != 'none')
				menu.visible = true;
				
				if(currVideo.type=='vimeo')
				setChildIndex(menu, numChildren-1);
				//(logo!=null)
				//setChildIndex(logo_mc, numChildren - 1);
				
				isFullscreen = false;
			}
		}
		private function randomizeArray(array:Array):Array{
			var newArray:Array = new Array();
			while(array.length > 0){
				newArray.push(array.splice(Math.floor(Math.random()*array.length), 1));
			}
			return newArray;
		}
		private function randomise(arg:int,max:int){
			
			arg = Math.random() * max;
			
			var sw = false;
			
			for (q = 0; q < tempArray.length; q++) {
			if (arg == tempArray[q])
			sw = true;
			}
			
			if (sw==true){
			randomise(0, max);
			return;
			}
			else
			tempArray.push(arg);
			
			
			i = arg;
		}
		/*dump public function trackerSend(trackTitle:String)
		{
			
			trackerOld = trackTitle;
			var url:String = "tracker.php";
			var request:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			requestVars.tracker = trackTitle;
			request.data = requestVars;
			request.method = URLRequestMethod.POST;

			var urlLoader:URLLoader = new URLLoader();
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, trackerSent, false, 0, true);
			//urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			//urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			//urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			
			try {
				urlLoader.load(request);
			} catch (e:Error) {
				
			}
		}
		
		public function trackerSent(e:Event){
		//function trackerSent(e:Event):void {
		//	var requestVars:URLVariables = new URLVariables( e.target.data );
		
			tracked = true;
		}
		*/
		


	}
}