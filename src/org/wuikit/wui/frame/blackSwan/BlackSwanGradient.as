package org.wuikit.wui.frame.blackSwan
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	import org.wuikit.wui.UiState;
	import org.wuikit.wui.Widget;
	import org.wuikit.wui.frame.IFrameStyle;
	
	public class BlackSwanGradient implements IFrameStyle
	{
		
		protected var defaultColors:Array = [
			0x3E4748,
			0x0F1117,
			
			0x3eca5a,
			0xf9429,
			
			0x3e88d1,
			0xf52a0,
			
			0xcdcdcd,
			0xFFFFFF,
			
		]
			
		protected var angle:Number=90;
		protected var borderSize:Number=2;
		protected var cornerSize:Number;
		protected var colorSet:Array;
		
		public function BlackSwanGradient(colorSet:Array=null,angle:Number=90,borderSize:Number=2,cornerSize:Number=20)
		{
			this.colorSet = colorSet || defaultColors;
			this.borderSize = borderSize;
			this.cornerSize = cornerSize;
			this.angle = angle;
		}
		
		
		public function render(ui:Widget,state:UiState, w:Number, h:Number):*
		{

			w -=borderSize;
			h-=borderSize;
			
			var colors:Array = [colorSet[0],colorSet[1]];
			
			if(ui.buttonMode && state.type != UiState.NORMAL ){
				colors[0] = state.type==UiState.ACTIVE ? colorSet[2] : colorSet[4];
				colors[1] = state.type==UiState.ACTIVE ? colorSet[3] : colorSet[5];
			}

			var alphas:Array = [1,1];
			var ratios:Array = [5,250];
			
			var m:Matrix = new Matrix;
			m.createGradientBox(w,h,angle * Math.PI/180);
			
			ui.graphics.clear();

			var g:Graphics = ui.graphics;
			
			if(borderSize>0)
				g.lineStyle(borderSize,state.on?colorSet[6]:colorSet[7]);
			
			g.beginGradientFill( GradientType.LINEAR,colors,alphas,ratios,m);
			g.drawRoundRect(0,0,w,h,cornerSize,cornerSize);
			g.endFill();
			
			ui.filters = state.on ? [new GlowFilter(0xffffff,.4,20,20)] : null;
			
			
			return ui;
		}
	}
}