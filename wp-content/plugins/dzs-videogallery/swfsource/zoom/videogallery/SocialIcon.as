package zoom.videogallery
{
	//importing the main classes
	import flash.display.*;
	import flash.geom.*;
	import flash.media.*;
    import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
    import flash.xml.*;
	import flash.text.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.*;
	public class SocialIcon extends MovieClip
	{
		
		public var l:Loader = new Loader;
		public var bg:Sprite = new Sprite();
		
		public var w:int;
		public var h:int;
		
		
		public function SocialIcon(feed:String,pw:int,ph:int)
		{
			w = pw;
			h = ph;
			//simple load function
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete)
			
			
			if(feed!='')
			l.load(new URLRequest(feed));
			
			
			
		}
		public function onComplete(e:Event)
		{
				
				//we scale the assets after has loaded
				l.content.width = w;
				l.content.height = h;
				
				
				dispatchEvent(new Event("loaded"));
				addChild(l);
				
				
				
				
		}
		private function handleError(e:IOErrorEvent) {
			trace("SocialIcon.as: Asset not found");
		}
		
		
	}
}