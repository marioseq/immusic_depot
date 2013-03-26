package zoom
{
	/**
	 * ver 1.2
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
	import flash.net.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.ui.*;
	import caurina.transitions.*;
	import caurina.transitions.properties.FilterShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	
	import flash.system.Capabilities;
	
	
	
	public class Scroller extends MovieClip
	{
		
		private var source:DisplayObject = null;
		
		private var i:int = 0; //for the 'for' instruction
		private var buttonPos:int = 0;
		private var buttonCon:MovieClip = new MovieClip();
		
		private var w:int = 0;
		private var h:int = 0;
		private var dir:String = ""
		private var scrollbar:String = "";
		
		private var viewIndex:int = 0;
		private var errorOffset:int = 30;
		public var scrollOffset:int = 0;
		public var blurScroll:String = "on";//choose on/off if you want blur scroll
		public var scrollTime:Number = 0.9;
		
		private var mouseDown:Boolean = false;
		private var scrollIndex:int = 0;
		private var scrollbar_mc:MovieClip;
		public var gradientMask:String = "on";
		public var bg:Sprite = new Sprite();
		public var maskSize:int = 15;
		public var isScroll:Boolean = true;
		public function Scroller()
		{
			this.name = "scroller";
		}
		public function feedvars(psource:DisplayObject,pw:int,ph:int,pdir:String = "ver",pscrollbar:String = "off")
		{
			trace(scrollTime);
			w = pw;
			h = ph;
			dir = pdir;
			scrollbar = pscrollbar;
			DisplayShortcuts.init(); 
			
			FilterShortcuts.init();
			
			source = psource;
			
			//we set up the mask
			
			
			
			addChild(source);
			trace('Scroller.as: sh: ' + source.height);
			
			if (Capabilities.screenResolutionX < 1200)
			blurScroll = "off";
			trace("Scroller.as: sc" + scrollbar);
			if (scrollbar == "on")
			{
				
				addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
				if (dir == "ver")
				{
					if (h < source.height)
					{
					vscrollbar_mc.x = w;
					vscrollbar_mc.bg_mc.height = h;
					scrollbar_mc = vscrollbar_mc;
					
					hscrollbar_mc.visible = false;
					setChildIndex(vscrollbar_mc, numChildren - 1);
					}
					else
					isScroll = false;
				}
				else
				{
					if (w < source.width)
					{
					hscrollbar_mc.y = h;
					hscrollbar_mc.bg_mc.width = w;
					scrollbar_mc = hscrollbar_mc;
					
					vscrollbar_mc.visible = false;
					setChildIndex(hscrollbar_mc, numChildren - 1);
					}
					else
					isScroll = false;
				}
				if(scrollbar_mc!=null){
				scrollbar_mc.buttonMode = true;
					scrollbar_mc.mouseChildren = false;
				scrollbar_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleScrollbarMouse,false,0,true);}
					addEventListener(Event.ADDED_TO_STAGE, function onStage(e:Event) {
						trace('Scroller.as: on stage');
					stage.addEventListener(MouseEvent.MOUSE_UP, handleScrollbarMouse); 
					stage.addEventListener(Event.MOUSE_LEAVE, handleLeave);  }, false, 0, true);
				
			}
			else{
				vscrollbar_mc.visible = false;
				hscrollbar_mc.visible = false;
			}
			
			if (!isScroll)
			{
				vscrollbar_mc.visible = false;
				hscrollbar_mc.visible = false;
			}
			if (isScroll)
			{
				addChild(bg);
				createMask();
				bg.cacheAsBitmap = true;
				source.cacheAsBitmap = true;
				source.mask = bg;
				vscrollbar_mc.alpha = 1;
				hscrollbar_mc.alpha = 1;
			}
			
			
			//choose between mouse move and enter frame ghandling
			if ((dir=="ver" && source.height > ph) || (dir=="hor" && source.width > pw)){
			addEventListener(Event.ENTER_FRAME, handleMouse);
			addEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			}
			
		}
		public function handleMouse(e:Event){
			//trace(mouseDown);
			//the function which moves the source depending on mouse
			if (scrollbar == "on")
			{
			if (mouseDown == true)
			{
				
				if (dir == "ver")
				{
				scrollIndex = scrollbar_mc.mouseY - (scrollbar_mc.head_mc.height >> 1);
				
				if (scrollIndex < 0) scrollIndex = 0;
				if (scrollIndex > h - scrollbar_mc.head_mc.height) scrollIndex = h - scrollbar_mc.head_mc.height;
				Tweener.addTween(scrollbar_mc.head_mc, { y:scrollIndex, time:0.5 } );
				Tweener.addTween(scrollbar_mc.head_mc, { _frame:30, time:1 } );
				
				
				viewIndex = (scrollIndex / (h - scrollbar_mc.head_mc.height)) * -(source.height - h);
				Tweener.addTween(source, { y:viewIndex, rounded:true, time:scrollTime } );
				
				if (blurScroll == "on")
				Tweener.addTween(source, { _Blur_blurY:Math.abs(viewIndex-source.y)/5, time:scrollTime } );

				}
				else
				{
					scrollIndex = scrollbar_mc.mouseX - (scrollbar_mc.head_mc.width>>1);
					if (scrollIndex < 0) scrollIndex = 0;
					if (scrollIndex > w - scrollbar_mc.head_mc.width) scrollIndex = w - scrollbar_mc.head_mc.width;
					Tweener.addTween(scrollbar_mc.head_mc, { x:scrollIndex, time:0.5 } );
					Tweener.addTween(scrollbar_mc.head_mc, { _frame:30, time:1 } );
					
					
					viewIndex = (scrollIndex / (w - scrollbar_mc.head_mc.width)) * -(source.width - w);
					Tweener.addTween(source, { x:viewIndex, time:scrollTime } );
					
					if (blurScroll == "on")
					{
						Tweener.addTween(source, { _Blur_blurX:Math.abs(viewIndex-source.x)/5, time:scrollTime} );
					
					}
				}
				
			}
			}
			else
			{
			if (mouseY > 0 && mouseY < h && mouseX > 0 && mouseX < w)
			{
			if (dir == "ver")
			{
			viewIndex = (mouseY / h) * -(source.height - h + errorOffset * 2 + scrollOffset * 2) + scrollOffset + errorOffset;
			if (viewIndex > scrollOffset) viewIndex = scrollOffset;
			if (viewIndex < -(source.height-h-1 + scrollOffset)) viewIndex = -(source.height-h-1 + scrollOffset);
			
			Tweener.addTween(source, { y:viewIndex, transition:"easeOutSine", rounded:true, time:scrollTime } );
			
			//set up blur scrolling
			if (blurScroll == "on")
			{
				Tweener.addTween(source, { _Blur_blurY:Math.abs(viewIndex-source.y)/5, time:.2 } );
				
			}
			}
			else
			{
				
				viewIndex = (mouseX / w) * -(source.width - w + errorOffset * 2 + scrollOffset * 2) + scrollOffset + errorOffset;
				if (viewIndex > scrollOffset) viewIndex = scrollOffset;
				if (viewIndex < -(source.width-w + scrollOffset)) viewIndex = -(source.width-w + scrollOffset);
				
				Tweener.addTween(source, { x:viewIndex, transition:"easeOutSine", rounded:true, time:.3 } );
				
				//set up blur scrolling
				if (blurScroll == "on")
				{
					Tweener.addTween(source, { _Blur_blurX:Math.abs(viewIndex-source.x)/5, time:.2 } );
					
				}
			}
				
			}
			else
			{
				Tweener.addTween(source, { _Blur_blurY:0,_Blur_blurX:0, time:.2 } );
			}
			}
		}
		public function handleRemove(e:Event)
		{
			if(hasEventListener(Event.ENTER_FRAME))
			removeEventListener(Event.ENTER_FRAME, handleMouse);
			
			if(hasEventListener(Event.REMOVED_FROM_STAGE))
			removeEventListener(Event.REMOVED_FROM_STAGE, handleRemove);
			
			if(hasEventListener(MouseEvent.MOUSE_WHEEL))
			removeEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			
		}
		public function handleScrollbarMouse(e:MouseEvent)
		{
			//function which gets the scrollbars attention
			if (e.type == "mouseDown")
			{
				mouseDown = true;
				
			}
			if (e.type == "mouseUp")
			{
				
				mouseDown = false;
				if(scrollbar_mc!=null)
				Tweener.addTween(scrollbar_mc.head_mc, { _frame:1, time:1 } );
				if(blurScroll=="on")
				Tweener.addTween(source, { _Blur_blurY:0,_Blur_blurX:0, time:.2 } );
				
			}
		}
		public function handleMouseWheel(e:MouseEvent)
		{
			//mouse wheel function 
			scrollIndex -= e.delta;
				if (scrollIndex < 0) scrollIndex = 0;
				if (scrollIndex > h - scrollbar_mc.head_mc.height) scrollIndex = h - scrollbar_mc.head_mc.height;
				Tweener.addTween(scrollbar_mc.head_mc, { y:scrollIndex, time:0.5 } );
				
				
				viewIndex = (scrollIndex / (h - scrollbar_mc.head_mc.height)) * -(source.height - h);
				Tweener.addTween(source, { y:viewIndex, time:1 } );
		}
		public function handleLeave(e:Event){
			trace('Scroller.as: left stage');
			mouseDown = false;
			if(scrollbar_mc!=null)
			Tweener.addTween(scrollbar_mc.head_mc, { _frame:1, time:1 } );
			Tweener.addTween(source, { _Blur_blurY:0,_Blur_blurX:0, time:.2 } );
		}
		public function createMask()
		{
			var bgmain:Sprite = new Sprite();
				
			if (gradientMask != "on")
			{
			
				bgmain.graphics.beginFill(0x000000);
				bgmain.graphics.drawRect(0, 0, w, h);
				bg.addChild(bgmain);
			}
			else
			{
				var bgup:Sprite = new Sprite();
				var bgdown:Sprite = new Sprite();
				var matrix:Matrix= new Matrix();
				var colors:Array=[0x000000,0x000000];
				var alphas:Array=[0,1];
				var ratios:Array=[0,255];
				matrix.createGradientBox(maskSize,w);
				
				if (dir == "ver")
				{
					bgup.graphics.lineStyle();
					bgup.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
					bgup.graphics.drawRect(0,0,maskSize,w);
					bgup.graphics.endFill();
					bgup.rotation = 90;
					bgup.x = w;
					bg.addChild(bgup);
					bgmain.graphics.beginFill(0x000000);
					bgmain.graphics.drawRect(0, 0, w, h - maskSize * 2);
					bgmain.y = maskSize;
					bg.addChild(bgmain);
					alphas = [1, 0];
					bgdown.graphics.lineStyle();
					bgdown.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
					bgdown.graphics.drawRect(0,0,maskSize,w);
					bgdown.graphics.endFill();
					bgdown.rotation = 90;
					bgdown.x = w;
					bgdown.y = h - maskSize;
					bg.addChild(bgdown);
				}
				else
				{
					bgup.graphics.lineStyle();
					bgup.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
					bgup.graphics.drawRect(0,0,maskSize,h);
					bgup.graphics.endFill();
					//bgup.rotation = 90;
					//bgup.x = maskSize;
					bg.addChild(bgup);
					bgmain.graphics.beginFill(0x000000);
					bgmain.graphics.drawRect(0, 0, w - maskSize * 2, h);
					bgmain.x = maskSize;
					bg.addChild(bgmain);
					alphas = [1, 0];
					bgdown.graphics.lineStyle();
					bgdown.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
					bgdown.graphics.drawRect(0,0,maskSize,h);
					bgdown.graphics.endFill();
					//bgdown.rotation = 90;
					bgdown.x = w - maskSize;
					//bgdown.y = h - maskSize;
					bg.addChild(bgdown);
				}
			}
		}
		


	}
}