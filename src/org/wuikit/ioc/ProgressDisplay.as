package org.wuikit.ioc
{
	import org.wuikit.common.IProgress;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class ProgressDisplay extends Sprite implements IProgress
	{
		
		public var color:uint;
		public var bgColor:uint;
		public var defaultWidth:Number;
		public var defaultHeight:Number;
	
		
		public function ProgressDisplay(defaultWidth:Number=200,defaultHeight:Number=12,color:uint=0xffffff,bgColor:uint=0x666666)
		{
			this.color = color;
			this.bgColor = bgColor;
			this.defaultWidth = defaultWidth;
			this.defaultHeight = defaultHeight;
			drawBackground();
			super();
		}
		
		
		protected function drawProgress(nValue:Number):void{
			if(nValue > 0){
				var g:Graphics = this.graphics;
				g.beginFill(color);
				g.drawRect(0,0,defaultWidth*(nValue),defaultHeight)
				g.endFill();
			}
		}
		
		public function clear():void{
			this.graphics.clear();
		}
		
		protected function drawBackground():void{
			var g:Graphics = this.graphics;
			g.beginFill(bgColor,1);
			g.drawRect(0,0,defaultWidth,defaultHeight);
			g.endFill();
		}
		
		public function setProgress(total:Number, completed:Number):void
		{
				if(total > 0 && completed > 0)
					drawProgress(completed/total)
		}
		

		
		
	}
}