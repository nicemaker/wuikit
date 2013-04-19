package org.wuikit.wui.layout
{
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import org.wuikit.wui.IWidget;
	import org.wuikit.wui.InteractiveSprite;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.WSizePolicy;
	import org.wuikit.wui.widgets.IListView;

	public class WLayoutVertical implements ILayout
	{
		
		public var pad:WPadding;
		public var gap:Number;
		public var align:int;
		public var children:Array;
		
		protected var hint:WSize;
		
		public function WLayoutVertical(gap:Number=0,align:int=0,padding:WPadding = null )
		{
			this.gap = gap;
			this.align = align;
			this.pad = padding ? padding : new WPadding(0,0,0,0);
		}
		
		public function apply(ui:IWidget):WSize{
			return (hint =  layout( ui,pad,gap,align ));
		}
		
		
		protected static function layout(ui:IWidget,pad:WPadding,gap:Number,align:int):WSize
		{
			var t:int =getTimer();
			var size:WSize = new WSize(0,0);
			
			if(! ui ||  ui.display().numChildren == 0) return  size;
					
			var i:int,l:int = ui.display().numChildren;
			
			var availableHeight:Number = ui.geometry.height - pad.sumY()- gap * (l-1);
			var availableWidth:Number = ui.geometry.width - pad.sumX();
			
			var hint:WSize;
			var wd:IWidget;false
			var sumStretch:Number=0;
			var maxWidth:Number = 0;
			var geo:Rectangle;
			var h:Number;
		
			
			for(i=0;i<l;i++){
				if( !(wd = ui.display().getChildAt( i ) as IWidget) ) 
					continue;
				geo = wd.geometry;
				hint = wd.sizeHint();
				
				geo.width = hint && wd.hPolicy == WSizePolicy.AUTO ? hint.x : wd.stretch.x * availableWidth;
				geo.width = Math.max( wd.minSize.x, Math.min( wd.maxSize.x,geo.width ) );

				if(hint && wd.vPolicy == WSizePolicy.AUTO){
					geo.height = Math.max( wd.minSize.y, Math.min( hint.y, wd.maxSize.y) );
					availableHeight -= geo.height;
				}
				else if( wd.vPolicy == WSizePolicy.NONE )
					sumStretch += wd.stretch.y;
			
				
				maxWidth = Math.max( maxWidth,geo.width ); 
			}
			
			var stretchBase:Number = availableHeight/sumStretch;
			var dy:Number = pad.left;
			for(i=0;i<l;i++){
				if( !(wd = ui.display().getChildAt( i ) as IWidget) ) 
					continue;
				geo = wd.geometry;
				hint = wd.sizeHint();
				
				if(wd.vPolicy == WSizePolicy.NONE)
					geo.height = Math.max( wd.minSize.y,Math.min( wd.maxSize.y,stretchBase * wd.stretch.y) );	
				geo.x = pad.top;
				if(align == 1 || align == 2)
					geo.x += align == 1 ? .5 * (maxWidth - geo.width) : maxWidth - geo.width;
			
				geo.y = dy;
				dy += geo.height + gap;
				wd.setGeometry( geo.x,geo.y,geo.width,geo.height);
			}
		
			size.y = geo.y + geo.height + pad.right;
			size.x = maxWidth + pad.sumY();
			return size;
		}
		
		public function sizeHint():WSize
		{
			return hint;
		}
		
	}
}