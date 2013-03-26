package zoom
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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.filters.*;
	import flash.system.Security;
	import flash.net.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.ui.*;
	import caurina.transitions.*;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	
	import vimeo.VimeoPlayer;
	import flash.external.ExternalInterface;
	
	
	public class VideoPlayer extends MovieClip
	{
		//declaring our variables
		public var ncConnection:NetConnection;
		public var nStream:NetStream;
		public var video_mc:Video = new Video();
		public var videoInfo:Object;//the metaData returned at load time
		
		public var scrubLength:int = 0;
		public var comme:String = '"';
		private var textString:String;
		private var volIndex:int = 4;
		private var currTime:Number;
		
		private var soundHandler:SoundTransform = new SoundTransform();
		
		// boolean to record the scrubing and stuff
		public var added:Boolean = false;
		private var mo:Boolean = false;
		public var scrubing:Boolean = false;
		public var scrubingvol:Boolean = false;
		//global vars
		private var source:String = "";
		public var w:int = 0;
		public var h:int = 0;
		public var autoplay:String;
		private var description:String;
		public var originalX:int = 0;
		public var originalY:int = 0;
		
		//bolean vars
		private var muted:Boolean = false;
		private var lastVol:Number = 1;
		
		private var thumb_mc:MovieClip;
		private var thumb:String;
		public var type:String;
		public var quality:String;
		public var fadeOnLeave:String = 'off';
		private var hded:Boolean = false;
		
		private var stretch:Boolean = false;
		private var hasEnded:Boolean = false;
		
		public var videoWidth:int = 0;
		public var videoHeight:int = 0;
		
		private var i:int = 0;
		//YOUTUBE vars
		private var _youTubeLoader:Object;
		private var vimeo_player:Object;
		private var loader:Loader = new Loader();
		private var paused:Boolean = true;
		
		public var autoplayNext:Boolean = false;
		public var metaReceived:Boolean = false;
		public var streamServer:String = '';
		public var preroll:Boolean = false;
		public var ad_image:String = '';
		public var ad_image_link:String = '';
		public var shared:SharedObject;
		public var defaultVolume:Number = -1;
		public var scaleMode:String = 'proportional';
		
		
		
		//*****************************************************
		//vars you will need to change if you modify the design
		public var scrubTextOffsetX:int = 0;
		public var scrubbarWidth:int = -98;//a negative value = totalWidth - value
		public var overlayControls:String = "on";
		
		//*****************************************************
		//design vars - automatic value
		public var controlsHeight:int = 28;//from VideoGallery.as
		public var scrubbarOffsetY:int = 0;
		public var scrubTextSpace:int = 106;
		public var controlsOffsetY:int = 0;
		public var overtakeInfoBtn:String = "onf";
		
		public var loadedWidth:int = 0;
		public var loadedHeight:int = 0;
		public var totalWidth:int = -1;
		public var totalHeight:int = -1;
		
		public var wasFullscreen:Boolean = false;
		public var isFullscreen:Boolean = false;
		public var isSingle:Boolean = false;
		
		private var controlsArray:Array = [];
		
		
		private var infobox_mask:Sprite = new Sprite();
		private var timeUpdater:Timer = new Timer(1000);
		
		private var playpause_mc_offset_x:int = 0;
		private var playpause_mc_offset_y:int = 0;
		private var scrubbar_mc_offset_x:int = 0;
		private var scrubbar_mc_offset_y:int = 0;
		private var vol_mc_offset_x:int = 0;
		private var vol_mc_offset_y:int = 0;
		private var full_mc_offset_x:int = 0;
		private var full_mc_offset_y:int = 0;
		
		
		public var disableInterface = "off";
		
		
		//defining our variables that we will use
		public var sound:Sound = new Sound();
		public var soundDuration:Number = 0;
		public var soundDurationLast:Number = 0;
		public var sChannel:SoundChannel = new SoundChannel();
		
		private var lastpos:int = 0;
		
		private var checkSoundLengthId:uint;
		
		private var videoinfo_width:int = 500;
		private var videoinfo_height:int = 300;
		
		
		public var player_scrubTextColor = "#999999";
		public var design_disable_description:String = 'off';
		public var mc_ad_image:MovieClip = new Ad_image();
		public var hdsource:String = '';
		
		
		public var pp_x:Number = -1.1;
		public var pp_y:Number = -1.1;
		public var pp_bg:String = '-1.1';
		public var scr_x:Number = -1.1;
		public var scr_y:Number = -1.1;
		public var scr_w:Number = -1.1;
		public var scr_h:Number = -1.1;
		public var scr_bg:String = '-1.1';
		public var scrl_bg:String  = '-1.1';
		public var scrp_bg:String  = '-1.1';
		public var vol_x:Number = -1.1;
		public var vol_y:Number = -1.1;
		public var vol_bg:String  = '-1.1';
		public var full_x:Number = -1.1;
		public var full_y:Number = -1.1;
		public var full_bg:String  = '-1.1';
		public var settings_bg:String  = '-1.1';
		public var settings_controls_bg:String = '-1.1';
		public var settings_controls_bg_h:Number = -1.1;
		public var settings_disable_big_play = '-1.1';
		
			var auxcolor:ColorTransform = new ColorTransform();
			
			private var destroyed:Boolean = false;
		
		public function VideoPlayer(){
			
			//we set up the player to be invisible at start
			DisplayShortcuts.init(); 
			
			visible = false;
			
			scrubbarOffsetY = scrubbar_mc.y - 400;
			
			if(this.hasOwnProperty('bg_mc'))
			controlsArray.push(MovieClip(this).bg_mc);
			if(this.hasOwnProperty('playbtn_mc')){
			controlsArray.push(MovieClip(this).playbtn_mc);
			if (settings_disable_big_play == 'on')
			trace('cevaaa');
			}
			if(this.hasOwnProperty('next_mc'))
			controlsArray.push(MovieClip(this).next_mc);
			if(this.hasOwnProperty('buffer_mc'))
			controlsArray.push(MovieClip(this).buffer_mc);
			if(this.hasOwnProperty('infobox_mc'))
			controlsArray.push(MovieClip(this).infobox_mc);
			if(this.hasOwnProperty('playpause_mc')){
			controlsArray.push(MovieClip(this).playpause_mc);
			playpause_mc_offset_x = MovieClip(this).playpause_mc.x - 612;
			playpause_mc_offset_y = MovieClip(this).playpause_mc.y - 428;
			}
			if(this.hasOwnProperty('scrubbar_mc')){
			controlsArray.push(MovieClip(this).scrubbar_mc);
			scrubbar_mc_offset_x = MovieClip(this).scrubbar_mc.x - 612;
			scrubbar_mc_offset_y = MovieClip(this).scrubbar_mc.y - 428;
			}
			if(this.hasOwnProperty('vol_mc')){
			controlsArray.push(MovieClip(this).vol_mc);
			vol_mc_offset_x = MovieClip(this).vol_mc.x - 612;
			vol_mc_offset_y = MovieClip(this).vol_mc.y - 428;
			}
			if(this.hasOwnProperty('full_mc')){
			controlsArray.push(MovieClip(this).full_mc);
			full_mc_offset_x = MovieClip(this).full_mc.x - 612;
			full_mc_offset_y = MovieClip(this).full_mc.y - 428;
			}
			if(this.hasOwnProperty('info_mc')){
			controlsArray.push(MovieClip(this).info_mc);
			}
			
			
			
			
		}
		public function feedvars(psource:String, pw:int = 0, ph:int = 0, pautoplay:String = "on", pthumb:String = "", pdescription:String = "", ptype:String = "video", pquality:String = "hd720", pautoplayNext:String = "on", pstreamServer:String = '')
		{
			w = pw;
			h = ph;
			totalWidth = w;
			totalHeight = h;
			source = psource;
			autoplay = pautoplay;
			thumb = pthumb;
			type = ptype;
			quality = pquality;
			streamServer = pstreamServer;
			
			//depracted but good
			if (overlayControls == 'on')
			overlayControls = 'off';
			else
			overlayControls = 'on';
			
			//trace('VideoPlayer.as: type - ' + type);
			
			if (type == '')
			type = 'video';
			
			
			if (pautoplayNext == "on") autoplayNext = true;
			
			description = pdescription;
			playpause_mc.pause_mc.visible = false;
			scrubbar_mc.scruber_mc.prog_mc.scaleX = 0;
			scrubbar_mc.scruber_mc.buf_mc.scaleX = 0;
			scrubbar_mc.scruber_mc.roll_mc.visible = false;
			next_mc.visible = false;
			
			if (design_disable_description=='on' && this.hasOwnProperty('infobox_mc')) {
				MovieClip(this).infobox_mc.visible = false;
			}
			
			
			//Tweener.addTween(infobox_mc, { _autoAlpha:0, time:0 } );
			//we choose between normal player and youtube player
			
			
			if (this.hasOwnProperty('infobox_mc')) {
				
				
				MovieClip(this).infobox_mc.alpha = 0;
				if (description == '')
				MovieClip(this).infobox_mc.visible = false;
				
				var bggr:Sprite = new Sprite();
				var matrix:Matrix= new Matrix();
				var colors:Array=[0x000000,0x000000,0x000000,0x000000];
				var alphas:Array=[0,1,1,0];
				var ratios:Array=[0,40,215,255];
				matrix.createGradientBox(totalWidth*2, totalHeight);
				
				infobox_mask.graphics.lineStyle();
				infobox_mask.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
				infobox_mask.graphics.drawRect(0,0,totalWidth*2,totalHeight);
				infobox_mask.graphics.endFill();
				
				addChild(infobox_mask);
				MovieClip(this).infobox_mc.cacheAsBitmap = true;
				infobox_mask.cacheAsBitmap = true;
				
				
				MovieClip(this).infobox_mc.mask = infobox_mask;
				Tweener.addTween(infobox_mask, { x:-totalWidth*2, time:0,transition:'linear'} )
				
			}
			
			trace('hdsource' + hdsource);
			
			trace('settings_bg', settings_bg);
			if(this.hasOwnProperty('playbtn_mc')){
			if (settings_disable_big_play == 'on')
			MovieClip(this).playbtn_mc.visible = false;
			MovieClip(this).removeChild(MovieClip(this).playbtn_mc);
			}
			if (settings_bg != '-1.1') {
				if (this.hasOwnProperty('bg_mc'))
				auxcolor.color = uint("0x" + settings_bg);
				MovieClip(this).bg_mc.transform.colorTransform = auxcolor;
			}
			if (settings_controls_bg != '-1.1') {
				auxcolor.color = uint("0x" + settings_controls_bg);
				if (hasOwnProperty("scrubbar_mc"))
				MovieClip(this).scrubbar_mc.bg_mc.transform.colorTransform = auxcolor;
				if (hasOwnProperty("playpause_mc"))
				MovieClip(this).playpause_mc.bg_mc.transform.colorTransform = auxcolor;
				if (hasOwnProperty("vol_mc"))
				MovieClip(this).vol_mc.bg_mc.transform.colorTransform = auxcolor;
				if (hasOwnProperty("full_mc"))
				MovieClip(this).full_mc.bg_mc.transform.colorTransform = auxcolor;
			}
			if (settings_controls_bg_h != -1.1) {
				if (hasOwnProperty("scrubbar_mc"))
				MovieClip(this).scrubbar_mc.bg_mc.height = settings_controls_bg_h;
				if (hasOwnProperty("playpause_mc"))
				MovieClip(this).playpause_mc.bg_mc.height = settings_controls_bg_h;
				if (hasOwnProperty("vol_mc"))
				MovieClip(this).vol_mc.bg_mc.height = settings_controls_bg_h;
				if (hasOwnProperty("full_mc"))
				MovieClip(this).full_mc.bg_mc.height = settings_controls_bg_h;
			}
			
			
			if (type == "video" || type=="rtmp"){
				if(stage==null)
				addEventListener(Event.ADDED_TO_STAGE, init);
				else
				init(null);
			}
			if (type == "youtube"){
				if(stage==null)
				addEventListener(Event.ADDED_TO_STAGE, yinit);
				else
				yinit(null);
			}
			if (type == "vimeo"){
				if(stage==null)
				addEventListener(Event.ADDED_TO_STAGE, vinit);
				else
				vinit(null);
			}
			if (type == "audio"){
				if(stage==null)
				addEventListener(Event.ADDED_TO_STAGE, ainit);
				else
				vinit(null);
			}
			if (type == "image"){
				if(stage==null)
				addEventListener(Event.ADDED_TO_STAGE, iinit);
				else
				iinit(null);
			}
			
			addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
			
			//mc_ad_image.feedvars(ad_image);
			if(ad_image.length>0){
			addChild(mc_ad_image);
			mc_ad_image.x = totalWidth / 2 - mc_ad_image.bg_mc.width/2;
			mc_ad_image.y = totalHeight / 2 - mc_ad_image.bg_mc.height / 2;
			
			var square:Sprite = new Sprite();
addChild(square);
square.graphics.beginFill(0x000000);
square.graphics.drawRect(0,0,totalWidth,totalHeight);
square.graphics.endFill();
square.x = -totalWidth / 2 + mc_ad_image.bg_mc.width/2;
square.y = -totalHeight / 2 + mc_ad_image.bg_mc.height / 2;
mc_ad_image.addChildAt(square,0);
square.alpha = 0.2;
			
			var mc_ad_image_thumb:ImageLoaderSimple = new ImageLoaderSimple();
			trace('ad:');
			//trace(ad_image);
			
			if (ad_image_link != '')
			mc_ad_image_thumb.link = ad_image_link;
			
			mc_ad_image.close_mc.addEventListener(MouseEvent.CLICK, function onClick(e:MouseEvent) { removeChild(mc_ad_image); playMovie(); } );
			
			mc_ad_image_thumb.feedvars(ad_image,mc_ad_image.bg_mc.width-20, mc_ad_image.bg_mc.height-70);
			mc_ad_image_thumb.x = 10;
			mc_ad_image_thumb.y = 10;
			mc_ad_image.addChild(mc_ad_image_thumb);
			}
		}
		
		public function onLastSecond ( ...args ):void{

		}

		public function onBWDone(...args):void{
			
		}
		public function init(e:Event)
		{
			//we set up the stage and the connection
			originalX = this.x;
			originalY = this.y;
			
			ncConnection = new NetConnection();
			
			
			ncConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			ncConnection.client = this
			
			//we find the position variables
			
			
			
			if (streamServer == '' || type == "video") {
			ncConnection.connect(null);
			}
			else {
				trace('stream server: ' + streamServer);
				ncConnection.connect(streamServer);
			}
			
			
			//start();
		}
		private function netStatusHandler(event:NetStatusEvent):void {
			
			//trace(event.info.code);
			
			if (event.info.code == "NetConnection.Connect.Success")
			start();
			
		}
		public function close() {
			
		}
		public function start() {
			if (destroyed == true)
			return;
			
			// we create a netstream that has tbe client the videoplayer
			nStream = new NetStream(ncConnection);
			nStream.client = this;
			
			var client:Object = new Object(); 
			client.onBWDone = onBWDone; 
			client.onMetaData = onMetaData; 
			nStream.client = client; 
			
			video_mc.attachNetStream(nStream);
			video_mc.smoothing = true;
			
			
			nStream.bufferTime = 3;
			nStream.soundTransform = soundHandler;
			
			nStream.play(source);
			
			
			addChildAt(video_mc, 1);
			
			
			nStream.addEventListener(NetStatusEvent.NET_STATUS, netstat);
			nStream.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			setTimeout(onMetaData, 7000);
		}
		public function onBWCheck(info:Object):void{
			
			
		}
		private function handleIOError(e:IOErrorEvent) {
			trace("IO ERROR");
			//trace(e.currentTarget);
		}
		public function onMetaData(info:Object=null):void{
			
			if (metaReceived)
			return;
			
			trace('VideoPlayer.as: MetaData received')
			
			
			
			metaReceived = true;
			
			
			//when meta data arrives we handle it
			if (autoplay == "on"){
			playpause_mc.play_mc.visible = false;
			playpause_mc.pause_mc.visible = true;
			
			playMovie();
			paused = false;
			}
			else
			{
				nStream.pause();
				//nStream.seek(0);
				paused = true;
				
			}
			
			
			//function that records the metadata in video info
			
			trace('oc', overlayControls);
			videoInfo = info;
			if (videoInfo == null) {
			}else {
				videoinfo_width = videoInfo.width;
				videoinfo_height = videoInfo.height;
			}
			if (w == 0){
				videoWidth = videoinfo_width;
				if(overlayControls=='on')
				videoHeight = videoinfo_height;
				else
				videoHeight = videoinfo_height - controlsHeight;
				
			}
			else
			{
				videoWidth = w;
				if(overlayControls=='on')
				videoHeight = h;
				else
				videoHeight = h - controlsHeight;
				trace(videoHeight);
			}
			
		
			if (videoWidth != videoinfo_width){
				if (scaleMode == "fill") {
					video_mc.x = 0;
					video_mc.y = 0;
					video_mc.width = videoWidth;
					video_mc.height = videoHeight;
				}else{
				if (videoinfo_width / videoinfo_height >= videoWidth / videoHeight){
					video_mc.width = videoWidth;
					video_mc.height = videoWidth * (videoinfo_height / videoinfo_width);
					
					video_mc.x = 0;
					video_mc.y = (videoHeight - (videoWidth*(videoinfo_height / videoinfo_width)))>>1;
				}
				else
				{
					
					video_mc.width = videoHeight * (videoinfo_width / videoinfo_height);
					video_mc.height = videoHeight;
					
					video_mc.x = (videoWidth - (videoHeight * (videoinfo_width / videoinfo_height))) >> 1;
					video_mc.y=0
				}
				}
			}
			else{
				video_mc.x = 0;
				video_mc.y = 0;
				video_mc.width = videoWidth;
				video_mc.height = videoHeight;
			}
			
			totalWidth = videoWidth;
			
			if(overlayControls=='on')
			totalHeight = videoHeight;
			else
			totalHeight = videoHeight + controlsHeight;
			
			resizePlayerControls(totalWidth,totalHeight);
			
			
			
			
			
			setupButtons();
			
			//handleFullScreen(null);
			
			if (autoplay == "on"){
				//visible = true;
				thumb_mc.visible = false;
				paused = false;
			}
			else
			thumb_mc.addEventListener("loaded", thumbLoaded);
			
			
			if (thumb == '') visible = true;
			
			loadedWidth = videoWidth;
			loadedHeight = videoHeight + controlsHeight;
			
			if (wasFullscreen) {
				resizeFullscreen();
				wasFullscreen = false;
			}
			dispatchEvent(new Event("loaded"));
			
			
			stage.addEventListener(Event.MOUSE_LEAVE, handleLeave,false,0,true);
			if(fadeOnLeave=='on'){
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleEnter, false, 0, true);
			}
			
		}
		
		public function thumbLoaded(e:Event){
			visible = true;
			paused=true;
		}
		public function handleMouseEvents(e:MouseEvent)
		{
			//function which handles almost all the mosue events
			//--------------------------------------------------
			if (e.type == "rollOver"){
				
				Tweener.addTween(e.currentTarget, { _frame:30, time:1 } );
			}
			if (e.type == "rollOut") {
				
					if (scrubingvol == false)
					Tweener.addTween(e.currentTarget, { _frame:1, time:1 } );
				
			}
			if (e.type == "click")
			{
				if (e.currentTarget.name == "playbtn_mc")
				{
					
					playMovie();
					
				}
				if (e.currentTarget.name == "playpause_mc")
				{
					if (e.currentTarget.play_mc.visible == true)
					{
						playMovie();
					}
					else
					{
						pauseMovie();
					}
				}
				
				
				if (e.currentTarget.name == "full_mc"){
					checkFullscreen();
				}
			}
			if (e.type == "mouseDown")
			{
				if (e.currentTarget.name == "vol_icon")
				{
					if (type != "youtube")
					{
					if (muted == false)
					{
						
						muted = true;
						lastVol = soundHandler.volume;
						soundHandler.volume = 0;
						if (hasOwnProperty("vol_mc"))
						{
						MovieClip(this).vol_mc.vol_icon.vol_ammount.scaleX = 0;
						MovieClip(this).vol_mc.slider_mc.slider_mc.y = 44;
						}
						
					}
					else
					{
						muted = false;
						soundHandler.volume = lastVol;
						if (hasOwnProperty("vol_mc"))
						{
						MovieClip(this).vol_mc.vol_icon.vol_ammount.scaleX = lastVol;
						MovieClip(this).vol_mc.slider_mc.slider_mc.y = 4 + (1 - lastVol) * 40;
						}
					}
					nStream.soundTransform = soundHandler;
					}
					else
					{
						
						if (muted == false)
						{
							//mute handler
							muted = true;
							lastVol = _youTubeLoader.getVolume();
							_youTubeLoader.setVolume(0);
							if (hasOwnProperty("vol_mc"))
							{
							MovieClip(this).vol_mc.vol_icon.vol_ammount.scaleX = 0;
							MovieClip(this).vol_mc.slider_mc.slider_mc.y = 44;
							}
							
						}
						else
						{
							muted = false;
							_youTubeLoader.setVolume(lastVol);
							
							if (hasOwnProperty("vol_mc"))
							{
							MovieClip(this).vol_mc.vol_icon.vol_ammount.scaleX = lastVol/100;
							MovieClip(this).vol_mc.slider_mc.slider_mc.y = 4 + (1 - lastVol / 100) * 40;
							}
						}
						
					}
					if (hasOwnProperty("vol_mc"))
					MovieClip(this).vol_mc.slider_mc.blackslider_mc.height = MovieClip(this).vol_mc.slider_mc.slider_mc.y;
				}
				if (e.currentTarget.name == "slider_mc")
				{
					scrubingvol = true;
					
				}
			}
			//--------------------------------------------------
		}
		public function netstat(e:NetStatusEvent)
		{
			//if player has reached end
			if (e.info.code == "NetStream.Play.Stop")
			{
				openReplay();
				
			}
        
		}
		public function handleFrame(e:Event){
			if (paused == false){
				if (thumb_mc != null && type!='audio'){
					thumb_mc.visible = false;
					
				}
			}
			
			//frame handler - for simple player
			if (type == "video"){
			if (nStream.bufferLength >= nStream.bufferTime)
			{
				buffer_mc.visible = false;
			}
			else
			{
				buffer_mc.visible = true;
			}
			
			
			if (nStream.time > int(videoInfo.duration) - nStream.bufferTime)
			{
				buffer_mc.visible = false;
			}
			
			if (scrubing == true)
			{
				
				var ratio:Number = scrubbar_mc.scruber_mc.mouseX / scrubLength;
				
				if (ratio > 1) ratio = 1;
				if (ratio < 0) ratio = 0;
				
				nStream.seek(Number(ratio * videoInfo.duration));
				scrubbar_mc.scruber_mc.prog_mc.width = ratio * scrubLength;
				
			}
			else
			{
				if (((nStream.time / Number(videoInfo.duration) ) * scrubLength) > scrubLength)
				{
					Tweener.addTween(scrubbar_mc.scruber_mc.prog_mc, { width:scrubLength, time:0.3 } );
				}
				else
				Tweener.addTween(scrubbar_mc.scruber_mc.prog_mc, { width:(nStream.time / Number(videoInfo.duration) ) * scrubLength, time:0.3 } );
				
				
					
			}
			
			
			//if playing
			
			currTime = nStream.time;
				
			if (currTime > videoInfo.duration){
				currTime = videoInfo.duration;
			}
			
			
				
			textString = String(formatTime(currTime)) + "<font size='12px' color='" + player_scrubTextColor + "'> / " + formatTime(videoInfo.duration);
			if(scrubbar_mc.hasOwnProperty('text_txt'))
			scrubbar_mc.text_txt.htmlText = textString;
			
			
			scrubbar_mc.scruber_mc.buf_mc.width = (nStream.bytesLoaded / nStream.bytesTotal ) * scrubLength;
			
			
			//***********
			
			
			
			}
			if (type == "youtube"){
				//********************
				//YOU TUBE ENTER FRAME
				//********************
				if (scrubing == true)
				{
				
				var yratio:Number = scrubbar_mc.scruber_mc.mouseX / scrubLength;
				
				if (yratio > 1) yratio = 1;
				if (yratio < 0) yratio = 0;
				
				
				_youTubeLoader.seekTo(Number(yratio * _youTubeLoader.getDuration()),true);
				scrubbar_mc.scruber_mc.prog_mc.width = yratio * scrubLength;
				
				}
				else{
				if (((_youTubeLoader.getCurrentTime() / _youTubeLoader.getDuration() ) * scrubLength) > scrubLength)
				{
					Tweener.addTween(scrubbar_mc.scruber_mc.prog_mc, { width:scrubLength, time:0.3 } );
				}
				else
				Tweener.addTween(scrubbar_mc.scruber_mc.prog_mc, { width:(_youTubeLoader.getCurrentTime() / _youTubeLoader.getDuration() ) * scrubLength, time:0.3 } );	
				}
				
				
				//if playing!
				textString = String(formatTime(_youTubeLoader.getCurrentTime())) + "<font size='12px' color='" + player_scrubTextColor + "'> / " + formatTime(_youTubeLoader.getDuration());
				if(scrubbar_mc.hasOwnProperty('text_txt'))
				scrubbar_mc.text_txt.htmlText = textString;
				
				//scrubbar_mc.scruber_mc.buf_mc.x = (_youTubeLoader.getVideoStartBytes() / _youTubeLoader.getVideoBytesTotal()) * scrubLength;
				
				
			    //navigateToURL(new URLRequest('javascript:console.log("start b ' + _youTubeLoader.getVideoStartBytes() + ', total b ' + _youTubeLoader.getVideoBytesTotal() + '")'), '_self');
				scrubbar_mc.scruber_mc.buf_mc.width =  + (_youTubeLoader.getVideoBytesLoaded() / _youTubeLoader.getVideoBytesTotal() ) * scrubLength - scrubbar_mc.scruber_mc.buf_mc.x;
				
			
			
			}
			
			if (type == "audio") {
				if (soundDuration > 0) {
					
					
				
				
				if (scrubing == true){
				
				var aratio:Number = scrubbar_mc.scruber_mc.mouseX / scrubLength;
				
				if (aratio > 1) aratio = 1;
				if (aratio < 0) aratio = 0;
				
				
				sChannel.stop();
				
				lastpos = Number(aratio * soundDuration) * 1000;
				playMovie();
				
				
				refreshSoundChannel();
				scrubbar_mc.scruber_mc.prog_mc.width = aratio * scrubLength;
				
				}
				else
				if ((((sChannel.position/1000) / soundDuration ) * scrubLength) > scrubLength)
				Tweener.addTween(scrubbar_mc.scruber_mc.prog_mc, { width:scrubLength, time:0.3 } );
				else
				Tweener.addTween(scrubbar_mc.scruber_mc.prog_mc, { width:((sChannel.position/1000) / soundDuration ) * scrubLength, time:0.3 } );	
				
				
				textString = String(formatTime(sChannel.position*0.001)) + "<font size='12px' color=" + comme + "#999999" + comme + "> / " + formatTime(soundDuration);
				if(scrubbar_mc.hasOwnProperty('text_txt'))
				scrubbar_mc.text_txt.htmlText = textString;
				
				
				}
			}
			
			//we verify if volume is scrubbing
			if (scrubingvol == true){
				if (hasOwnProperty("vol_mc"))
				volIndex = MovieClip(this).vol_mc.slider_mc.mouseY;
				if (volIndex < 4) volIndex = 4;
				if (volIndex > 44) volIndex = 44;
				
				
				setVolume(Math.abs(1 - ((volIndex - 4) / 40)));
				
			}
			
			if (mo == true || scrubing == true){
				
				var index:int = scrubbar_mc.scruber_mc.mouseX;
				if (index < 0) index = 0;
				if (index > scrubbar_mc.scruber_mc.bg_mc.width-4) index = scrubbar_mc.scruber_mc.bg_mc.width-4;
				scrubbar_mc.scruber_mc.roll_mc.x = index;
				
				if(type=="video")
				scrubbar_mc.scruber_mc.roll_mc.text_txt.text = String(formatTime((index / scrubbar_mc.scruber_mc.bg_mc.width) * videoInfo.duration));
				
				if(type=="youtube")
				scrubbar_mc.scruber_mc.roll_mc.text_txt.text = String(formatTime((index / scrubbar_mc.scruber_mc.bg_mc.width) * _youTubeLoader.getDuration()));
				
				
				if(type=="audio")
				scrubbar_mc.scruber_mc.roll_mc.text_txt.text = String(formatTime((index / scrubbar_mc.scruber_mc.bg_mc.width) * soundDuration));
				
				
				scrubbar_mc.scruber_mc.roll_mc.visible = true;
			}
			if (mo == false && scrubing==false)
			scrubbar_mc.scruber_mc.roll_mc.visible = false;
			
			
			
			
			if (isFullscreen)
			if (mouseY < stage.stageHeight - 200){
				hideControls();
			}
			else{
				showControls();
			}
			
		}
		public function showControls() {
			//navigateToURL(new URLRequest('javascript:console.log("show controls")'), '_self');
				
			
			if(controlsArray[controlsArray.length-1].alpha<1)
				for (i = 0; i < controlsArray.length; i++) {
				if(controlsArray[i].name!='bg_mc' && controlsArray[i].name!='playbtn_mc' && controlsArray[i].name!='next_mc')
				Tweener.addTween(controlsArray[i], { alpha:1, time:1 } );
				}
		}
		public function hideControls() {
			if(controlsArray[controlsArray.length-1].alpha>0)
				for (i = 0; i < controlsArray.length; i++){
				if(controlsArray[i].name!='bg_mc' && controlsArray[i].name!='playbtn_mc' && controlsArray[i].name!='next_mc')
				Tweener.addTween(controlsArray[i], { alpha:0, time:1 } );
				}
		}
		public function handleTimeUpdate(e:TimerEvent) {
			
		}
		public function setVolume(arg:Number = 1){
		
			if (type == "video"){
			soundHandler.volume = arg;
			nStream.soundTransform = soundHandler;
			if (hasOwnProperty("vol_mc")){
			MovieClip(this).vol_mc.vol_icon.vol_ammount.scaleX = arg;
			MovieClip(this).vol_mc.slider_mc.slider_mc.y = (40 * ( 1 - (arg))) + 4;
			MovieClip(this).vol_mc.slider_mc.blackslider_mc.height = (40 * ( 1 - (arg))) + 4;
			}
			}
			if (type == "youtube"){
			_youTubeLoader.setVolume(arg * 100);
			if (hasOwnProperty("vol_mc")){
			MovieClip(this).vol_mc.vol_icon.vol_ammount.scaleX = Math.abs(arg);
			MovieClip(this).vol_mc.slider_mc.slider_mc.y = (40 * ( 1 - (arg))) + 4;
			MovieClip(this).vol_mc.slider_mc.blackslider_mc.height = (40 * ( 1 - (arg))) + 4;
			}
			}
			
			if (type == "audio"){
			
			soundHandler.volume = arg;
			refreshSoundChannel();
			if (hasOwnProperty("vol_mc")){
			MovieClip(this).vol_mc.vol_icon.vol_ammount.scaleX = arg;
			MovieClip(this).vol_mc.slider_mc.slider_mc.y = (40 * ( 1 - (arg))) + 4;
			MovieClip(this).vol_mc.slider_mc.blackslider_mc.height = (40 * ( 1 - (arg))) + 4;
			}
			}
			
			shared.data.volume = arg;
		}
		public function checkScrub(e:MouseEvent)
		{
			if (e.type == "rollOver"){
				mo = true;
				
			}
			if (e.type == "rollOut"){
				mo = false;
			}
			if (e.type == "mouseDown"){
				scrubing = true;
			}
			if (e.type == "mouseUp"){
				scrubing = false;
				scrubingvol = false;
				
				if (hasOwnProperty("vol_mc"))
				Tweener.addTween(MovieClip(this).vol_mc, { _frame:1, time:1 } );
			}
		}
		public function formatTime(secs:int):String {
			//code snippet from http://snipplr.com/view.php?codeview&id=33913
			var h:Number=Math.floor(secs/3600);
			var m:Number=Math.floor((secs%3600)/60);
			var s:Number=Math.floor((secs%3600)%60);
			return(h==0?"":(h<10?"0"+h.toString()+":":h.toString()+":"))+(m<10?"0"+m.toString():m.toString())+":"+(s<10?"0"+s.toString():s.toString());
			
		}
		public function openReplay(){
			//function which tells the gallery that it has ended playback
			pauseMovie();
			
			
			if (ExternalInterface.available && disableInterface!='on')
			ExternalInterface.call("vg_videoEnd");
			
			if(autoplayNext==true || preroll==true){
			dispatchEvent(new Event("videoEnded"));
			}else{
				
				if (hasOwnProperty("playbtn_mc"))
				MovieClip(this).playbtn_mc.icon_mc.gotoAndStop(2);
				
				if(isSingle==false)
				MovieClip(this).next_mc.visible = true;
				
				
				if (next_mc.hasEventListener(MouseEvent.ROLL_OVER)==false)
				{
					next_mc.buttonMode = true;
				
					next_mc.addEventListener(MouseEvent.ROLL_OVER, handleMouseEvents);
					next_mc.addEventListener(MouseEvent.ROLL_OUT, handleMouseEvents);
					next_mc.addEventListener(MouseEvent.MOUSE_DOWN, onNext);
				}
				
				hasEnded = true;
			}
			
			//send end video
			//Object(parent).trackerSend("video ended");
			
			
			
		}
		public function onNext(e:MouseEvent){
			dispatchEvent(new Event("videoEnded"));
		}
		public function playMovie(e:Event = null){
			if(type=="video")
			nStream.resume();
			
			if(type=="youtube")
			_youTubeLoader.playVideo();
			
			if (type == "audio") {
				sChannel = sound.play(lastpos);
				
				if(sChannel!=null){
				sChannel.soundTransform = soundHandler;
				sChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false, 0, true);
				}
			}
					
			if (thumb_mc != null && type != 'audio') {
			thumb_mc.visible = false;
			}
			if (hasOwnProperty("playbtn_mc"))
			MovieClip(this).playbtn_mc.visible = false;
			playpause_mc.play_mc.visible = false;
			playpause_mc.pause_mc.visible = true;
			paused = false;
			
			next_mc.visible = false;
			
			if (hasEnded) {
				if(type=="video")
				nStream.seek(0)
				if(type=="youtube")
				_youTubeLoader.seekTo(0, true);
				
				if (hasOwnProperty("playbtn_mc"))
				MovieClip(this).playbtn_mc.icon_mc.gotoAndStop(1);
				
				next_mc.visible = false;
				hasEnded = true;
			}
			
			
			//Tweener.addTween(infobox_mc, { _autoAlpha:0, time:.7 } );
			Tweener.addTween(infobox_mask, { x:-totalWidth*2, time:1.4,transition:'linear'} );
			
			
			//send start video
			//Object(parent).trackerSend("video started");
		}
		public function pauseMovie()
		{
			if(type=="video")
			nStream.pause();
			if(type=="youtube")
			_youTubeLoader.pauseVideo();
			
			
			if (type == "audio") {
				lastpos = sChannel.position;
				sChannel.stop();
			}
			
			
			playpause_mc.play_mc.visible = true;
			playpause_mc.pause_mc.visible = false;
			if (hasOwnProperty("playbtn_mc"))
			MovieClip(this).playbtn_mc.visible = true;
			paused = true;
			
			if(this.hasOwnProperty('infobox_mc'))
			Tweener.addTween(MovieClip(this).infobox_mc, { alpha:1, time:.7 } );
			Tweener.addTween(infobox_mask, { x:-totalWidth*0.5, time:2,transition:'linear'} );
		}
		
		public function resizeFullscreen(){
			
			var sw = stage.stageWidth;
			var sh = stage.stageHeight;
			if (overlayControls != 'on')
			sh -= controlsHeight;
			if (type == "video") {
				var aux = stage.stageHeight;
				if (hdsource != '' && hded==false)
				createHD();
				
				if (scaleMode == "fill") {
					video_mc.x = 0;
					video_mc.y = 0;
					video_mc.width = sw;
					video_mc.height = sh;
				}else {
					
				if (videoinfo_width / videoinfo_height >= stage.stageWidth / aux)
				{
					video_mc.width = sw;
					video_mc.height = sw * (videoinfo_height / videoinfo_width);
					video_mc.x = 0;
					video_mc.y = (aux - (sw*(videoinfo_height / videoinfo_width)))>>1;
				}
				else
				{
					video_mc.width = (aux) * (videoinfo_width / videoinfo_height);
					video_mc.height = aux;
					
					
					video_mc.x = (sw - (sh * (videoinfo_width / videoinfo_height))) >> 1;
					video_mc.y = 0;
				}
				}
			}
			if (type == "youtube"){
				_youTubeLoader.setSize(sw, sh)
				}
				
				
				if (type == "vimeo") {
					//trace('vimeo getting fullscreen');
					//stage.displayState = StageDisplayState.NORMAL;
					vimeo_player.setSize(stage.stageWidth, stage.stageHeight);
				}
				
				x -= Object(parent).x;
				y -= Object(parent).y;
				resizePlayerControls(stage.stageWidth, stage.stageHeight);
				
				// scaling the video preview image too //
				if (thumb_mc){
				if (thumb_mc.hasOwnProperty('l'))
				if (thumb_mc.l.hasOwnProperty('content'))
				if (thumb_mc.l.content != null){
					thumb_mc.l.content.width = sw;
					thumb_mc.l.content.height = sh;
				}
				if (thumb_mc.hasOwnProperty('bmp') && thumb_mc.bmp!=null){
					thumb_mc.bmp.width = sw;
					thumb_mc.bmp.height = sh;
				}
				}
				
				if(hasOwnProperty('infobox_mc'))
				Tweener.addTween(MovieClip(this).infobox_mask, { x: -totalWidth * 2, time:0, transition:'linear' } );
				
				if(Object(parent).hasOwnProperty("isFullscreen"))
				Object(parent).isFullscreen=true;
				
				if(Object(parent).hasOwnProperty("hideShareButton"))
				Object(parent).hideShareButton();
				
				isFullscreen = true;
		}
		private function createHD() {
			hded = true;
			nStream = new NetStream(ncConnection);
			nStream.client = this;
			
			var client:Object = new Object(); 
			client.onBWDone = onBWDone; 
			client.onMetaData = onMetaData; 
			nStream.client = client; 
			
			video_mc.attachNetStream(nStream);
			video_mc.smoothing = true;
			
			
			nStream.bufferTime = 3;
			nStream.soundTransform = soundHandler;
			
			nStream.play(hdsource);
			
			
			//addChildAt(video_mc, 1);
			
			
			nStream.addEventListener(NetStatusEvent.NET_STATUS, netstat);
			nStream.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			setTimeout(onMetaData, 7000);
		}
		public function resizeNormalscreen()
		{
			if(MovieClip(this).hasOwnProperty("full_mc"))
				MovieClip(this).full_mc.gotoAndStop(1);
				if (type == "video") {
					
				
				if (videoWidth != videoinfo_width)
				{
					
					if (videoinfo_width / videoinfo_height >= videoWidth / videoHeight)
					{
						video_mc.width = videoWidth;
						video_mc.height = videoWidth * (videoinfo_height / videoinfo_width);
						video_mc.x = 0;
						video_mc.y = (videoHeight - (videoWidth*(videoinfo_height / videoinfo_width)))>>1;
					}
					else
					{
						
						video_mc.width = videoHeight * (videoinfo_width / videoinfo_height);
						video_mc.height = videoHeight;
						video_mc.y = 0;
						video_mc.x = (videoWidth - (videoHeight * (videoinfo_width / videoinfo_height)))>>1;
					}
				}
				else
				{
					video_mc.y = 0;
					video_mc.x = 0;
					video_mc.width = videoWidth;
					video_mc.height = videoHeight;
				}
				}
				if (type == "youtube"){
					if (w == 0)
					{
						videoWidth = 640;
						videoHeight = 480;
					}
					else
					{
						videoWidth = videoWidth;
						videoHeight = videoHeight;
					}
					_youTubeLoader.x = 0;
					_youTubeLoader.y = 0;
					_youTubeLoader.setSize(videoWidth, videoHeight);
				}
				
				if (type == "vimeo") {
					//navigateToURL(new URLRequest("http://" + String(videoWidth)), '_blank');
					vimeo_player.setSize(videoWidth, videoHeight);
					//vimeo_player.width = videoWidth;
				}
				
				
				trace(originalX, originalY);
				x = originalX;
				y = originalY;
				resizePlayerControls(totalWidth,totalHeight);
				
				if (thumb_mc)
				if (thumb_mc.hasOwnProperty('l'))
				if (thumb_mc.l.hasOwnProperty('content'))
				if (thumb_mc.l.content != null){
					thumb_mc.l.content.width = videoWidth;
					thumb_mc.l.content.height = videoHeight;
					
				}
				
				
				if(Object(parent).hasOwnProperty("isFullscreen"))
				Object(parent).isFullscreen=false;
				
				if(Object(parent).hasOwnProperty("showShareButton"))
				Object(parent).showShareButton();
				
				
				isFullscreen = false;
		}
		public function handleFullScreen(e:FullScreenEvent)
		{
			//fucntion which handle the FULLSCREEN event
			//******************************************
			if (stage.displayState == StageDisplayState.NORMAL){
			if(type=='vimeo'){
			e.preventDefault();
			e.stopImmediatePropagation();
			e.stopPropagation();
			}
			resizeNormalscreen();
			
			showControls();
			}
			//******************************************
			
			if (stage.displayState == StageDisplayState.FULL_SCREEN) {
				if (type == 'vimeo') {
					trace('vimeooooo');
				}
			}
		}
		
		//*******************
		//YOUTUBE INTEGRATION
		//*******************
		
		public function yinit(e:Event)
		{
			originalX = this.x;
			originalY = this.y;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			Security.allowDomain("*");
			
			
		}
		public function onLoaderInit(event:Event):void {
			
			addChildAt(loader,1);
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
		public function onVideoPlaybackQualityChange(event:Event):void {
			// Event.data contains the event parameter, which is the new video quality
			
		}
		
		public function onPlayerReady(event:Event):void {
			// Event.data contains the event parameter, which is the Player API ID 
			
			if (destroyed == true){
			return;
			}
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			_youTubeLoader = loader.content;
			// Set appropriate player dimensions for your application
			
			
			if (w == 0)
			{
				videoWidth = 900;
				videoHeight = 600;
				totalWidth = 900;
				totalHeight = 600 + controlsHeight;
			}
			else
			{
				videoWidth = w;
				videoHeight = h;
				
				if (overlayControls != 'on')
				videoHeight -= controlsHeight;
			}
			
			
			
			
			_youTubeLoader.setSize(videoWidth, videoHeight);
			
			
			resizePlayerControls(videoWidth, totalHeight);
			
			
			trace('videoplayer.as: video id is: ' + source);
			_youTubeLoader.setVolume(0);
			_youTubeLoader.loadVideoById(source, 0, String(quality));
			
			
			
			if (autoplay == "on"){
				paused = false;
			playpause_mc.play_mc.visible = false;
			playpause_mc.pause_mc.visible = true;
			
			//playMovie();
			}
			else
			{
				paused = true;
				//_youTubeLoader.seekTo(0,true);
				pauseMovie();
			}
			
		
			
			setupButtons();
			//_youTubeLoader.setVolume(0);
			
			
			if (autoplay == "on")
			{
				visible = true;
				thumb_mc.visible = false;
				if (hasOwnProperty("playbtn_mc"))
				MovieClip(this).playbtn_mc.visible = false;
				
			}
			else
			{
			thumb_mc.addEventListener("loaded", thumbLoaded);
			_youTubeLoader.pauseVideo();
			}
			
			if (thumb == '') visible = true;
			
			if(MovieClip(this).hasOwnProperty('buffer_mc'))
			MovieClip(this).buffer_mc.visible = false;
			
			
			
			loadedWidth = videoWidth;
			loadedHeight = videoHeight + controlsHeight;
			
			if (wasFullscreen) {
				resizeFullscreen();
				wasFullscreen = false;
			}
			
			
			dispatchEvent(new Event("loaded"));
			
			if(fadeOnLeave=='on'){
			stage.addEventListener(Event.MOUSE_LEAVE, handleLeave,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleEnter, false, 0, true);
			}
			
		}

		public function onPlayerError(event:Event):void {
			// Event.data contains the event parameter, which is the error code
			//trace("videoplayer.as: player error:", Object(event).data);
		}

		public function onPlayerStateChange(event:Event):void {
			// Event.data contains the event parameter, which is the new player state
			
			if (Object(event).data == 3)
			buffer_mc.visible = true;
			else
			buffer_mc.visible = false;
			
			if (Object(event).data == 0)
			openReplay();
			
			
		}

		
		
		private function setupButtons()
		{
			
			//we add the video player on stage
			thumb_mc = new ImageLoaderSimple();
			thumb_mc.feedvars(thumb, totalWidth, totalHeight);
			
			
			addChildAt(thumb_mc, 1);
			
			scrubbar_mc.scruber_mc.roll_mc.mouseChildren = false;
			scrubbar_mc.scruber_mc.roll_mc.mouseEnabled = false;
			
			scrubbar_mc.scruber_mc.buttonMode = true;
			scrubbar_mc.scruber_mc.mouseChildren = false;
			
			if (hasOwnProperty("playbtn_mc")){
			MovieClip(this).playbtn_mc.buttonMode = true;
			MovieClip(this).playbtn_mc.mouseChildren = false;
			}
			
			//thumb_mc.mouseEnabled = false;
			thumb_mc.mouseChildren = false;
			
			
			addListeners(playpause_mc);
			if (hasOwnProperty("info_mc"))
			addListeners(MovieClip(this).info_mc);
			if (hasOwnProperty("vol_mc"))
			addListeners(MovieClip(this).vol_mc);
			if (hasOwnProperty("full_mc"))
			addListeners(MovieClip(this).full_mc);
			if (hasOwnProperty("playbtn_mc"))
			addListeners(MovieClip(this).playbtn_mc);
			
			
			if(autoplay=='on')
			handleShared();
			else {
			if(type=='youtube')
			setTimeout(handleShared, 3000);
			else
			handleShared();
			}
			
			if (hasOwnProperty("vol_mc"))
			{
			MovieClip(this).vol_mc.slider_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvents);
			MovieClip(this).vol_mc.vol_icon.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvents);
			}
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreen);
			scrubbar_mc.scruber_mc.addEventListener(MouseEvent.ROLL_OUT, checkScrub);
			scrubbar_mc.scruber_mc.addEventListener(MouseEvent.ROLL_OVER, checkScrub);
			scrubbar_mc.scruber_mc.addEventListener(MouseEvent.MOUSE_DOWN, checkScrub);
			stage.addEventListener(MouseEvent.MOUSE_UP, checkScrub);
			
			timeUpdater.addEventListener(TimerEvent.TIMER, handleTimeUpdate);
			//timeUpdater.start();
			
			stage.addEventListener(Event.ENTER_FRAME, handleFrame);
			
			trace(thumb_mc);
			thumb_mc.buttonMode = true;
			thumb_mc.mouseChildren = false;
			thumb_mc.addEventListener(MouseEvent.CLICK, playMovie);
			
			addEventListener(Event.REMOVED_FROM_STAGE, handleDestroy);
			//*********************************************
		}
		/*private function youTubePlayerStateChangeHandler (event:YouTubeLoaderEvent):void {
			//handle the youtube player events
			
		};*/
		public function destroy()
		{
			Tweener.addTween(this, { _autoAlpha:0, time:1, onComplete:completeDestroy } );
			if (type == "video"){
				nStream.pause();
				nStream.close();
			}
			if (type == "youtube" && _youTubeLoader != null) {
				/*
				_youTubeLoader.stopVideo();
				*/
				_youTubeLoader.pauseVideo();
			}
			if (type == "vimeo"){
			vimeo_player.pause();
			}
			
			if (type == "audio"){
				sChannel.stop();
				//sound.close();
			}
			destroyed = true;
		}
		public function destroyAlt()
		{
			Tweener.addTween(this, { _autoAlpha:0, x:this.width*0.25, y:this.height*0.25, width:0, height:0, time:1, onComplete:completeDestroy } );
			if (type != "youtube"){
				nStream.pause();
				nStream.close();
			}
			else{
				_youTubeLoader.pauseVideo();
				//_youTubeLoader.stopVideo();
				//_youTubeLoader.destroy();
			}
			destroyed = true;
			
		}
		private function completeDestroy(){
			Object(parent).removeChild(this);
		}
		public function handleKey(e:KeyboardEvent){
			if (e.keyCode == 32)
			{
				if (paused == true)
				playMovie();
				else
				pauseMovie();
			}
		}
		public function handleDestroy(e:Event){
			//function which stops the video and removes all listeners to release memory
			
			removeListeners(playpause_mc);
			if (hasOwnProperty("info_mc"))
			removeListeners(MovieClip(this).info_mc);
			if (hasOwnProperty("vol_mc"))
			removeListeners(MovieClip(this).vol_mc);
			if (hasOwnProperty("full_mc"))
			removeListeners(MovieClip(this).full_mc);
			if (hasOwnProperty("playbtn_mc"))
			removeListeners(MovieClip(this).playbtn_mc);
			
			if (hasOwnProperty("vol_mc")){
			MovieClip(this).vol_mc.slider_mc.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvents);
			MovieClip(this).vol_mc.vol_icon.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseEvents);
			}
			
			scrubbar_mc.scruber_mc.removeEventListener(MouseEvent.ROLL_OUT, checkScrub);
			scrubbar_mc.scruber_mc.removeEventListener(MouseEvent.ROLL_OVER, checkScrub);
			scrubbar_mc.scruber_mc.removeEventListener(MouseEvent.MOUSE_DOWN, checkScrub);
			
			timeUpdater.removeEventListener(TimerEvent.TIMER, handleTimeUpdate);
			stage.removeEventListener(MouseEvent.MOUSE_UP, checkScrub);
			stage.removeEventListener(Event.ENTER_FRAME, handleFrame);
			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreen);
			
		}
		public function addListeners(... objects){
			for (i = 0; i < objects.length; i++){
				objects[i].gotoAndStop(1);
				objects[i].buttonMode = true;
				objects[i].addEventListener(MouseEvent.ROLL_OVER, handleMouseEvents,false,0,true);
				objects[i].addEventListener(MouseEvent.ROLL_OUT, handleMouseEvents,false,0,true);
				objects[i].addEventListener(MouseEvent.CLICK, handleMouseEvents,false,0,true);
			}
		}
		public function removeListeners(... objects){
			for (i = 0; i < objects.length; i++){
				objects[i].removeEventListener(MouseEvent.ROLL_OVER, handleMouseEvents);
				objects[i].removeEventListener(MouseEvent.ROLL_OUT, handleMouseEvents);
				objects[i].removeEventListener(MouseEvent.CLICK, handleMouseEvents);
			}
		}
		public function resizePlayerControls(wd:int, hg:int){
			//arranging the controls
			//playpause_mc.y = hg-controlsHeight
			//scrubbar_mc.y = hg - controlsHeight + scrubbarOffsetY;
			if (hasOwnProperty("playpause_mc")) {
			//MovieClip(this).playpause_mc.x = wd + playpause_mc_offset_x;
			MovieClip(this).playpause_mc.y = hg + playpause_mc_offset_y;
			var xmod = pp_x;
			var ymod = pp_y;
			if (xmod != -1.1) {
				if (xmod < 0)
				MovieClip(this).playpause_mc.x = wd - MovieClip(this).playpause_mc.width + xmod;
				else
				MovieClip(this).playpause_mc.x = xmod;
			}
			if (ymod != -1.1) {
				if (ymod < 0)
				MovieClip(this).playpause_mc.y = hg - MovieClip(this).playpause_mc.height + ymod;
				else
				MovieClip(this).playpause_mc.y = ymod;
			}
			if (pp_bg != '-1.1') {
				auxcolor.color = uint("0x" + pp_bg);
				MovieClip(this).playpause_mc.play_mc.transform.colorTransform = auxcolor;
				MovieClip(this).playpause_mc.pause_mc.transform.colorTransform = auxcolor;
			}
			}
			if (hasOwnProperty("scrubbar_mc")) {
			//MovieClip(this).scrubbar_mc.x = wd + scrubbar_mc_offset_x;
			MovieClip(this).scrubbar_mc.y = hg + scrubbar_mc_offset_y;
			
			xmod = scr_x;
			ymod = scr_y;
			if (xmod != -1.1) {
				if (xmod < 0)
				MovieClip(this).scrubbar_mc.scruber_mc.x = -33 + wd - MovieClip(this).scrubbar_mc.scruber_mc.width + xmod;
				else
				MovieClip(this).scrubbar_mc.scruber_mc.x = -33 + xmod;
			}
			//trace(
			if (ymod != -1.1) {
				if (ymod < 0)
				MovieClip(this).scrubbar_mc.y = hg - MovieClip(this).scrubbar_mc.bg_mc.height + ymod;
				else
				MovieClip(this).scrubbar_mc.y = ymod + MovieClip(this).scrubbar_mc.bg_mc.height;
			}
			if (scr_bg != '-1.1') {
				auxcolor.color = uint("0x" + scr_bg);
				MovieClip(this).scrubbar_mc.scruber_mc.bg_mc.transform.colorTransform = auxcolor;
			}
			if (scrl_bg != '-1.1') {
				auxcolor.color = uint("0x" + scrl_bg);
				MovieClip(this).scrubbar_mc.scruber_mc.buf_mc.transform.colorTransform = auxcolor;
			}
			if (scrp_bg != '-1.1') {
				auxcolor.color = uint("0x" + scrp_bg);
				MovieClip(this).scrubbar_mc.scruber_mc.prog_mc.transform.colorTransform = auxcolor;
			}
			}
			if (hasOwnProperty("vol_mc")) {
			MovieClip(this).vol_mc.x = wd + vol_mc_offset_x;
			MovieClip(this).vol_mc.y = hg + vol_mc_offset_y;
			
			xmod = vol_x;
			ymod = vol_y;
			if (xmod != -1.1) {
				if (xmod < 0)
				MovieClip(this).vol_mc.x = wd - MovieClip(this).vol_mc.width + xmod;
				else
				MovieClip(this).vol_mc.x = xmod;
			}
			if (ymod != -1.1) {
				if (ymod < 0)
				MovieClip(this).vol_mc.y = hg - MovieClip(this).vol_mc.bg_mc.height + ymod;
				else
				MovieClip(this).vol_mc.y = ymod;
			}
			if (vol_bg != '-1.1') {
				auxcolor.color = uint("0x" + vol_bg);
				MovieClip(this).vol_mc.vol_icon.transform.colorTransform = auxcolor;
				MovieClip(this).vol_mc.slider_mc.slider_mc.transform.colorTransform = auxcolor;
			}
			}
			
			if (hasOwnProperty("full_mc")) {
			MovieClip(this).full_mc.x = wd + full_mc_offset_x;
			MovieClip(this).full_mc.y = hg + full_mc_offset_y;
			
			
			
			xmod = full_x;
			ymod = full_y;
			if (xmod != -1.1) {
				if (xmod < 0)
				MovieClip(this).full_mc.x = wd - MovieClip(this).full_mc.width + xmod;
				else
				MovieClip(this).full_mc.x = xmod;
			}
			if (ymod != -1.1) {
				if (ymod < 0)
				MovieClip(this).full_mc.y = hg - MovieClip(this).full_mc.height + ymod;
				else
				MovieClip(this).full_mc.y = ymod;
			}
			if (full_bg != '-1.1') {
				auxcolor.color = uint("0x" + full_bg);
				MovieClip(this).full_mc.full_icon.transform.colorTransform = auxcolor;
			}
			
			
			
			}
			bg_mc.width = wd;
			bg_mc.height = hg;
			
			//setting up the description
			if(MovieClip(this).hasOwnProperty('infobox_mc')){
			MovieClip(this).infobox_mc.text_txt.htmlText = description;
			MovieClip(this).infobox_mc.text_txt.width = wd-20;
			MovieClip(this).infobox_mc.text_txt.autoSize = TextFieldAutoSize.LEFT;
			MovieClip(this).infobox_mc.text_txt.width = MovieClip(this).infobox_mc.text_txt.textWidth + 5;
			MovieClip(this).infobox_mc.bg_mc.width = MovieClip(this).infobox_mc.text_txt.textWidth + 15;
			MovieClip(this).infobox_mc.bg_mc.height = MovieClip(this).infobox_mc.text_txt.textHeight + 15;
			}
			
			
			if (hasOwnProperty("playbtn_mc")){
			MovieClip(this).playbtn_mc.x = wd / 2 - (MovieClip(this).playbtn_mc.width >> 1);
			MovieClip(this).playbtn_mc.y = hg / 2 - (MovieClip(this).playbtn_mc.height >> 1);
			}
			
			if (hasOwnProperty("playbtn_mc")){
			next_mc.x = wd / 2 - (MovieClip(this).playbtn_mc.width >> 1) + 110;
			next_mc.y = hg / 2 - (MovieClip(this).playbtn_mc.height >> 1) + 25;
			}
			else{
				next_mc.x = wd / 2 - (MovieClip(this).next_mc.width >> 1);
				next_mc.y = hg / 2 - (MovieClip(this).next_mc.height >> 1);
			}
			
			
			
			if(scrubbarWidth>0)
			scrubbar_mc.bg_mc.width = scrubbarWidth;
			else
			scrubbar_mc.bg_mc.width = wd + scrubbarWidth;
			
			scrubbar_mc.scruber_mc.bg_mc.width = scrubbar_mc.bg_mc.width - scrubTextSpace;
			scrubLength = scrubbar_mc.scruber_mc.bg_mc.width;
			
			//if(hasOwnProperty("vol_mc"))
			//MovieClip(this).vol_mc.x = wd - 65;
			if(scrubbar_mc.hasOwnProperty('text_txt'))
			scrubbar_mc.text_txt.x = scrubbar_mc.bg_mc.width - 86 + scrubTextOffsetX;
			
			if (thumb_mc != null){
			thumb_mc.bg.width = wd;
			thumb_mc.bg.height = hg;
			}
		}
		public function handleShared()
		{
			shared = SharedObject.getLocal("reloaded");
			if (shared.data.volume==undefined) {
				setVolume(1);
			}
			else {
				setVolume(shared.data.volume);
			}
			if (defaultVolume > -1)
			setVolume(defaultVolume);
			shared.close();
		}
		
		public function checkFullscreen(e:Event = null) {
			
			
			
			
			if (!isFullscreen) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
				resizeFullscreen();
			}
			else{
				stage.displayState = StageDisplayState.NORMAL;
			}
			
			
		}
		public function forceResize(wd:int, hg:int)
		{
			if (String(type).indexOf("video")!=-1)
			{
				video_mc.width = wd;
				video_mc.height = hg-28;
				
			}
			if (type == "youtube")
			{
				_youTubeLoader.setSize(wd, hg-28);
			}
			if (type == "vimeo")
			{
				vimeo_player.setSize(wd, hg);
			}
			videoWidth = wd;
			videoHeight = hg-28;
		}

		public function vinit(e:Event){
			originalX = this.x;
			originalY = this.y;
			for each (var mc:* in controlsArray){
				mc.visible = false;
			}
			vimeo_player = new VimeoPlayer("7facdfffa5beced96aabae9806a619ee", int(source), w, h, '10', 2, autoplay);
			vimeo_player.addEventListener(Event.COMPLETE, vimeoPlayerLoaded);
			addChild(DisplayObject(vimeo_player));
			//var vfb = new Vimeofullscreenbtn;
			//addChild(vfb);
			
		}
		
		public function vimeoPlayerLoaded(e:Event){
			
			vimeo_player.changeColor('ffffff');
			
			videoWidth = w;
			videoHeight = h;
			if (w == 0){
				videoWidth = 900;
				videoHeight = 600;
			}
			
			//vimeo_player.setSize(videoWidth, videoHeight);
				
				
			loadedWidth = videoWidth;
			loadedHeight = videoHeight;
			
			if(wasFullscreen)
				resizeFullscreen();
			
			visible = true;
			dispatchEvent(new Event("loaded"));
			
			stage.addEventListener("Vimeo_fullscreenit", handleVimeoFullscreen);
			stage.addEventListener("Vimeo_normalscreenit", handleVimeoNormalscreen);
			
		}
		
		private function handleVimeoFullscreen(e:Event) {
			resizeFullscreen();
		}
		
		private function handleVimeoNormalscreen(e:Event) {
			resizeNormalscreen();
		}
		public function ainit(e:Event){

			originalX = this.x;
			originalY = this.y;
			
			//we load the sound
			sound.load(new URLRequest(source));
			sound.addEventListener(Event.COMPLETE, handleSoundLoaded);
		}
		private function handleSoundLoaded(e:Event) {
			if (destroyed == true)
			return;
			trace("VideoPlayer.as: Sound loaded");
			trace("VideoPlayer.as: autoplay " + autoplay);
			
			if (autoplay == "on"){
				paused = false;
				//sChannel = sound.play();
				playMovie();
				refreshSoundChannel();
			}
			else{
				paused = true;
				sChannel = sound.play();
				refreshSoundChannel();
				sChannel.stop();
			}
			
			
			if (w == 0){
				videoWidth = stage.stageWidth;
				videoHeight = stage.stageHeight;
			}
			else{
				videoWidth = w;
				videoHeight = h;
			}
			
			totalWidth = videoWidth;
			
			if(overlayControls=='on')
			totalHeight = videoHeight;
			else
			totalHeight = videoHeight + controlsHeight;
			
			resizePlayerControls(totalWidth, totalHeight);
			
			
			checkSoundLengthId = setInterval(checkSoundLength, 1000);
			
			
			if(MovieClip(this).hasOwnProperty('buffer_mc'))
			MovieClip(this).buffer_mc.visible = false;
			
			visible = true;
			dispatchEvent(new Event("loaded"));
			setupButtons();
			
			if(Object(parent).hasOwnProperty('hidePreloader'))
			Object(parent).hidePreloader();
			
			scrubbar_mc.scruber_mc.addEventListener(MouseEvent.CLICK, handleScrubarClick);
			
		}
		private function handleScrubarClick(e:MouseEvent) {
			
		}
		private function checkSoundLength() {
			
			
			soundDuration = (sound.bytesTotal / (sound.bytesLoaded / sound.length)) / 1000;
			
			
			if (soundDuration == soundDurationLast) {
				clearInterval(checkSoundLengthId);
				return;
			}
			
			soundDurationLast = soundDuration;
			
			
		}
		private function handleSoundComplete(e:Event) {
			
		}
		private function refreshSoundChannel() {
			if(sChannel!=null){
			sChannel.soundTransform = soundHandler;
			sChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false, 0, true);
			}
		}
		
		public function handleEnter(e:MouseEvent) {
			
			showControls();
		}
		public function handleLeave(e:Event) {
			//navigateToURL(new URLRequest('javascript:console.info("handleleave")'), '_self');
			
				for (i = 0; i < controlsArray.length; i++){
				controlsArray[i].gotoAndStop(1);
				}
			if(fadeOnLeave=='on')
			hideControls();
		}
		public static function fadeOut(arg:MovieClip) {
			
		}
		function iinit(e:Event) {
			
			originalX = this.x;
			originalY = this.y;
			var iloader:Loader = new Loader();
			iloader.contentLoaderInfo.addEventListener(Event.COMPLETE, icomplete);
			iloader.load(new URLRequest(source));
		}
		function icomplete(e:Event) {
			addChild(e.currentTarget.content);
			//trace(controlsArray);
			for (i = 0; i < controlsArray.length; i++ ) {
				controlsArray[i].visible = false;
				//trace(controlsArray[i]);
				//control.visible = false;
			}
			visible = true;
			if (scaleMode == 'fill') {
				e.currentTarget.content.width = totalWidth;
				e.currentTarget.content.height = totalHeight;
			}
			dispatchEvent(new Event("loaded"));
		}
	}
}