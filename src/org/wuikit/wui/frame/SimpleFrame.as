package org.wuikit.wui.frame
{
	import org.wuikit.wui.UiState;
	import org.wuikit.wui.Widget;
	
	import flash.display.Shape;
	
	public class SimpleFrame implements IFrameStyle
	{
		
		public var color:uint;
		public var alpha:Number;
		public var borderColor:Number;
		public var borderSize:Number;
		public var cornerSize:Number;
		
		public function SimpleFrame(color:uint=0x171B21,alpha:Number=1,borderColor:uint=0,borderSize:Number=0,cornerSize:Number=0)
		{
			this.color = color;
			this.cornerSize = cornerSize;
			this.alpha = alpha;
			this.borderColor = borderColor;
			this.borderSize = borderSize;
			
			super();
		}
		
		public function render(ui:Widget,state:UiState,w:Number,h:Number):*{
			
			ui.graphics.clear();
			if(borderSize>0)
				ui.graphics.lineStyle(borderSize,borderColor,alpha);
			ui.graphics.beginFill( color,alpha );
			ui.graphics.drawRoundRect(0,0,w,h,cornerSize,cornerSize);
			ui.graphics.endFill();
		}
	}
}