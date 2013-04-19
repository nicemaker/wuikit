package org.wuikit.wui.layout
{
	import flash.geom.Rectangle;
	
	import org.wuikit.wui.IWidget;
	import org.wuikit.wui.InteractiveSprite;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.WSizePolicy;
	import org.wuikit.wui.widgets.IListView;

	public class WLayoutHorizontal implements ILayout
	{
		
		public var pad:WPadding;
		public var gap:Number;
		public var align:int;
		public var children:Array;
		
		protected var hint:WSize;
		
		public function WLayoutHorizontal(gap:Number=0,align:int=0,padding:WPadding = null )
		{
			this.gap = gap;
			this.align = align;
			this.pad = padding ? padding : new WPadding(0,0,0,0);
		}
		
		public function apply(ui:IWidget):WSize{
			return (hint = layout( ui,pad,gap,align ));
		}
		
		
		protected static function layout(ui:IWidget,pad:WPadding,gap:Number,align:int):WSize
		{
			var size:WSize = new WSize(0,0);
			
			if(! ui ||  ui.display().numChildren == 0) return  size;
					
			var i:int,l:int = ui.display().numChildren;
			
			var availableWidth:Number = ui.geometry.width - pad.sumX()- gap * (l-1);
			var availableHeight:Number = ui.geometry.height - pad.sumY();
			
			var hint:WSize;
			var wd:IWidget;false
			var sumStretch:Number=0;
			var maxHeight:Number = 0;
			var geo:Rectangle;
			var h:Number;
		
			
			for(i=0;i<l;i++){
				if( !(wd = ui.display().getChildAt( i ) as IWidget) ) 
					continue;
				geo = wd.geometry;
				hint = wd.sizeHint();
				
				geo.height = hint && wd.vPolicy == WSizePolicy.AUTO ? hint.y : wd.stretch.y * availableHeight;
				geo.height = Math.max( wd.minSize.y, Math.min( wd.maxSize.y,geo.height ) );

				if(hint && wd.hPolicy == WSizePolicy.AUTO){
					geo.width = Math.max( wd.minSize.x, Math.min( hint.x, wd.maxSize.x) );
					availableWidth -= geo.width;
				}
				else if( wd.hPolicy == WSizePolicy.NONE )
					sumStretch += wd.stretch.x;
			
				
				maxHeight = Math.max( maxHeight,geo.height ); 
			}
			
			var stretchBase:Number = availableWidth/sumStretch;
			var dx:Number = pad.left;
			for(i=0;i<l;i++){
				if( !(wd = ui.display().getChildAt( i ) as IWidget) ) 
					continue;
				geo = wd.geometry;
				hint = wd.sizeHint();
				
				if(wd.hPolicy == WSizePolicy.NONE)
					geo.width = Math.max( wd.minSize.x,Math.min( wd.maxSize.x,stretchBase * wd.stretch.x) );	
				geo.y = pad.top;
				if(align == 1 || align == 2)
					geo.y += align == 1 ? .5 *(maxHeight - geo.height) : maxHeight - geo.height;
			
				geo.x = dx;
				dx += geo.width + gap;
				wd.setGeometry( geo.x,geo.y,geo.width,geo.height);
			}
		
			size.x = geo.x + geo.width + pad.right;
			size.y = maxHeight + pad.sumY();
			
			return size;
		}
		
		public function sizeHint():WSize
		{
			return hint;
		}
		
	}
}