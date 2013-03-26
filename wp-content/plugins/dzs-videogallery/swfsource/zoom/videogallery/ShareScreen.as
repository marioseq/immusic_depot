package zoom.videogallery
{
	//importing the main classes
	import flash.display.*;
	import flash.geom.*;
	import flash.media.*;
    import flash.net.*;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.utils.*;
    import flash.xml.*;
	import flash.text.*;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.*;
	public class ShareScreen extends MovieClip
	{
		
		public var l:Loader = new Loader;
		public var bg:Sprite = new Sprite();
		
		public var w:int;
		public var h:int;
		
		public var iconsCon:MovieClip = new MovieClip();
		public var iconsPos:int = 0;
		
		public var i:int = 0;
		
		public var iconArray:Array = [];
		public var linkArray:Array = [];
		public var toolArray:Array = [];
		
		public function ShareScreen()
		{
			
			DisplayShortcuts.init();
			visible = false;
			
			Tweener.addTween(tooltip_mc, { _autoAlpha:0, time:0 } );
			
		}
		public function init(warg:int, harg:int,wico:int, hico:int,piconArray:Array, plinkArray:Array, ptoolArray:Array)
		{
				iconArray = piconArray;
				linkArray = plinkArray;
				toolArray = ptoolArray;
				
				
				bg_mc.width = warg;
				bg_mc.height = harg;
				
				addChild(iconsCon);
				
				iconsCon.x = (warg >> 1) - (iconArray.length * ((wico >> 1) +10 ));
				iconsCon.y = (harg >> 1) - (hico >> 1);
				
				
				for (i = 0; i < iconArray.length; i++)
				{
				var icon_mc:SocialIcon = new SocialIcon(iconArray[i], wico, hico);
				iconsCon.addChild(icon_mc);
				
				icon_mc.x = iconsPos;
				iconsPos += wico + 10;
				
				icon_mc.buttonMode = true;
				icon_mc.addEventListener(MouseEvent.ROLL_OVER, handleIconMouse);
				icon_mc.addEventListener(MouseEvent.ROLL_OUT, handleIconMouse);
				icon_mc.addEventListener(MouseEvent.MOUSE_DOWN, handleIconMouse);
				
				}
				
				
			bg_mc.buttonMode = true;
			bg_mc.addEventListener(MouseEvent.MOUSE_DOWN, closeTransition);
			
			addEventListener(MouseEvent.MOUSE_MOVE, handleMove);
			
			//showTooltip("ceva");
		}
		public function openTransition()
		{
			Tweener.addTween(this, { _autoAlpha:1, time:1 } );
			for (i = 0; i < iconsCon.numChildren; i++)
			{
				Tweener.addTween(iconsCon.getChildAt(i), { y:30, _autoAlpha:0, time:0 } );
				Tweener.addTween(iconsCon.getChildAt(i), { y:0, time:1, delay:0.03 * i, rounded:true } );
				Tweener.addTween(iconsCon.getChildAt(i), { _autoAlpha:1, time:1, delay:0.03 * i } );
			}
			mouseChildren = true
			mouseEnabled = true;
		}
		public function closeTransition(e:Event = null)
		{
			Tweener.addTween(this, { _autoAlpha:0, time:.5, transition:"easeOutSine" } );
			mouseChildren = false;
			mouseEnabled = false;
		}
		public function handleIconMouse(e:MouseEvent)
		{
			if (e.type == "rollOver")
			{
				
				
				showTooltip(toolArray[iconsCon.getChildIndex(DisplayObject(e.currentTarget))]);
				tooltip_mc.y = e.currentTarget.parent.y - 5;
				
			}
			
			if (e.type == "rollOut")
			hideTooltip();
			
			if(e.type=="mouseDown")
			navigateToURL(new URLRequest(linkArray[iconsCon.getChildIndex(DisplayObject(e.currentTarget))]), "_blank");
		}
		public function showTooltip(arg:String)
		{
			
			if (arg + "dd" != "dd")
			{
				
				Tweener.addTween(tooltip_mc, { _autoAlpha:1,time:.5})	
				tooltip_mc.text_txt.htmlText = arg;
				tooltip_mc.text_txt.autoSize=TextFieldAutoSize.LEFT;
							
				tooltip_mc.bg_mc.width = tooltip_mc.text_txt.textWidth + 10;
			}
		}
		public function hideTooltip()
		{
			Tweener.addTween(tooltip_mc, { _autoAlpha:0, time:.5 } );
		}
		public function handleMove(e:MouseEvent)
		{
			if (tooltip_mc.visible == true)
			{
				Tweener.addTween(tooltip_mc, { x:this.mouseX - 12, time:.5, rounded:true } );
			}
		}
		
	}
}