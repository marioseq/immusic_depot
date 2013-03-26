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
	public class Asset extends MovieClip
	{
		
		public var l:Loader = new Loader;
		public var bg:Sprite = new Sprite();
		
		public var w:int;
		public var h:int;
		
		
		public function Asset(feed:String,pw:int=0,ph:int=0)
		{
			//globalizing vars
			w = pw;
			h = ph;
			
			//simple load function
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete)
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			
				bg.graphics.beginFill(0x000000,0.3);
				bg.graphics.drawRect(0, 0, w, h);
				//addChild(bg);
			
			
			
			
			
			if(feed!='')
			l.load(new URLRequest(feed));
			
			
			
		}
		public function onError(e:IOErrorEvent)
		{
				
			trace('logo path not found');
				
		}
		public function onComplete(e:Event)
		{
				
			//we scale the assets after has loaded
			if (w != 0)
			{
			l.content.width = w;
			l.content.height = h - 28;
			}
				
				
				dispatchEvent(new Event("loaded"));
				addChild(l);
				
				
				
				
		}
		
		
	}
}