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
	public class Thumb extends MovieClip
	{
		
		private var i:int = 0;
		//you can modify the border color and width from here.
		public var borderColor:uint = 0x111111;
		public var bw:int = 4;
		public var gw:int;
		public var gh:int;
		public var smoothing:String = 'on';
		public var bdata:BitmapData ;
		public var bmp:Bitmap;
		private var loader_mc:MovieClip = new Preloader();
		public var borders:MovieClip = new MovieClip();
		private var currNr:int = 0;
		private var sstimer:Timer = new Timer(1000);
		private var thumbCon:MovieClip = new MovieClip();
		private var thumbArray:Array = new Array();
		public var feed:Array = new Array();
		private var b1:Sprite = new Sprite();
		private var b2:Sprite = new Sprite();
		private var b3:Sprite = new Sprite();
		private var b4:Sprite = new Sprite();
		
		
		public function Thumb()
		{
			
		}
		public function feedvars(pfeed:Array,pw:int,ph:int)
		{
			
			feed = pfeed;
			gw = pw;
			gh = ph;
			if (feed[0] == '')
			return;
			
			this.name = "thumb";
			
			drawBorders();
			addChild(borders);
			
			addChildAt(thumbCon,0);
			
			for (i = 0; i < feed.length; i++)
			{
				if(feed[i]==null)
				continue;
				
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete)
			l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			l.load(new URLRequest(feed[i]));
			thumbArray.push(l);
			thumbCon.addChild(l);
			
			
			}
			
			sstimer.addEventListener(TimerEvent.TIMER, handleSlideshow);
			
		}
		private function onError(e:Event){
			trace('Thumb.as: asset not found');
		}
		
		private function onComplete(e:Event)
		{
			var aux_bit:Bitmap = new Bitmap();
				
				for (i = 0; i < thumbArray.length; i++)
				{
					thumbArray[i].width = gw;
					thumbArray[i].height = gh;
					
				}
				thumbCon.setChildIndex(thumbArray[0], thumbCon.numChildren - 1);
				
				if (smoothing == 'on') {
					bdata = new BitmapData(e.currentTarget.content.width, e.currentTarget.content.height);
					bdata.draw(e.currentTarget.content);
					bmp = new Bitmap(bdata);
					addChild(bmp);
					setChildIndex(borders, numChildren - 1);
					bmp.smoothing = true;
					bmp.width = gw;
					bmp.height = gh;
				}
		}
		public function drawBorders()
		{
			
			//function to draw borders of a asset
				b1.graphics.beginFill(borderColor);
				b1.graphics.drawRect(0, 0, bw, gh);
				borders.addChild(b1);
				b2.graphics.beginFill(borderColor);
				b2.graphics.drawRect(0, 0, gw, bw);
				borders.addChild(b2);
				b3.graphics.beginFill(borderColor);
				b3.graphics.drawRect(gw-bw, 0, bw, gh);
				borders.addChild(b3);
				b4.graphics.beginFill(borderColor);
				b4.graphics.drawRect(0, gh-bw,gw,  bw);
				borders.addChild(b4);
		}
		
		public function resizeBorders(arg:Number)
		{
			
				Tweener.addTween(b1, { width:arg, height:gh, time:1 } );	
				Tweener.addTween(b2, { width:gw, height:arg, time:1 } );
				Tweener.addTween(b3, { x:gw-arg, width:arg, height:gh, time:1 } );
				Tweener.addTween(b4, { y:gh-arg, width:gw, height:arg, time:1 } );
				
				
		}
		public function startSlideshow()
		{
			if(thumbArray.length>1)
			sstimer.start();
		}
		public function stopSlideshow()
		{
			sstimer.reset();
			if(thumbArray[0]){
			thumbCon.setChildIndex(thumbArray[0], thumbCon.numChildren - 1);
			thumbArray[0].alpha = 1;
			}
		}
		public function handleSlideshow(e:TimerEvent)
		{
			
			thumbCon.setChildIndex(thumbArray[currNr], thumbCon.numChildren - 1);
			thumbArray[currNr].alpha = 1;
			
			var tempNr:int = currNr + 1;
			if (tempNr == feed.length)
			{
				tempNr = 0;
			}
			currNr = tempNr;
			
			thumbArray[currNr].alpha = 0;
			thumbCon.setChildIndex(thumbArray[currNr], thumbCon.numChildren - 1);
			Tweener.addTween(thumbArray[currNr], { alpha:1, time:1 } );
			
			
		}
	}
}