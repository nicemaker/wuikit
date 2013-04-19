package org.wuikit.wui.frame
{
	import flash.geom.Rectangle;
	
	import org.wuikit.global.cnst.colors.BLUE;
	import org.wuikit.global.cnst.colors.GREEN;
	import org.wuikit.global.cnst.colors.RED;
	import org.wuikit.global.cnst.colors.YELLOW;
	import org.wuikit.wui.UiState;
	import org.wuikit.wui.Widget;
	
	public class DebugFrame implements IFrameStyle
	{
		public function DebugFrame()
		{
		}
		
		public function render(ui:Widget,state:UiState, w:Number, h:Number):*
		{
			var c:uint = state.type == UiState.NORMAL  || ui.buttonMode == false ? GREEN:
						state.type ==UiState.SELECTED ? RED:
						BLUE;
			
			var borderColor:uint = state.on ?   YELLOW : 0;
			
			ui.graphics.clear();
			ui.graphics.beginFill( c,1);
			ui.graphics.lineStyle(1,borderColor);
			ui.graphics.drawRect( .5,.5,w-.5 ,h -.5 );
			
			return null;
		}
		
	}
}