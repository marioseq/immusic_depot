package zoom
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
	public class ImageLoaderSimple extends MovieClip
	{
		
		public var l:Loader = new Loader;
		public var bg:Sprite = new Sprite();
		
		public var w:int;
		public var h:int;
		
		public var link:String = '';
		
		public var smoothing:Boolean = true;
		public var bmpdata:BitmapData;
		public var bmp:Bitmap;
		public function ImageLoaderSimple(){
			
		}
		public function feedvars(feed:String,pw:int=0,ph:int=0)
		{
			//globalizing vars
			w = pw;
			h = ph;
			
			//simple load function
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete)
		
			
			
				bg.graphics.beginFill(0x000000,0.3);
				bg.graphics.drawRect(0, 0, w, h);
				//addChild(bg);
			
			
			
			
			
			if(feed!='')
			l.load(new URLRequest(feed));
			
			
			
		}
		public function onError(e:Event)
		{
			trace('ImageLoaderSimple.as: Failed loading image...');
		}
		public function onComplete(e:Event)
		{
				
			//we scale the assets after has loaded
			if (w != 0)
			{
			l.content.width = w;
			l.content.height = h;
			}
				
				
			dispatchEvent(new Event("loaded"));
			if(smoothing==false){
			addChild(l);
			}else {
				bmpdata = new BitmapData(l.content.width, l.content.height);
				bmpdata.draw(l.content);
				bmp = new Bitmap(bmpdata);
				//bmp.width = w;
				//bmp.height = h;
				addChild(bmp);
				bmp.smoothing = true;
			}
				
				
			if (link != '') {
			this.addEventListener(MouseEvent.CLICK, function onClick(e:MouseEvent) { navigateToURL(new URLRequest(link)); } );
			this.buttonMode = true;
			this.mouseChildren = false;
			}
				
		}
		
		
	}
}