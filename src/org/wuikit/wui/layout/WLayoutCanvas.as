package org.wuikit.wui.layout
{
	import flash.geom.Rectangle;
	
	import org.wuikit.wui.IWidget;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.WSizePolicy;
	
	public class WLayoutCanvas implements ILayout
	{
		
		protected var hint:WSize;
		
		public function WLayoutCanvas()
		{
			hint = new WSize;
		}
		
		public function apply(ui:IWidget):WSize
		{
			return (hint = layout(ui));
		}
		
		public static function layout(ui:IWidget):WSize{
			var w:IWidget;
			var whint:WSize;
			var hint:WSize = new WSize(0,0);
			var l:int = ui.display().numChildren;
			var geo:Rectangle;
			for(var i:int;i<l;i++){
				w = ui.display().getChildAt(i) as IWidget;
				whint = w.sizeHint();
				geo = w.geometry.clone();
				geo.width = Math.max( w.minSize.x,Math.min(w.maxSize.y, w.hPolicy == WSizePolicy.AUTO && hint ? hint.x : geo.width ));
				geo.height = Math.max(w.minSize.y,Math.min(w.maxSize.y, w.vPolicy == WSizePolicy.AUTO && hint ? hint.y : geo.height));
				w.setGeometry(geo.x,geo.y,geo.width,geo.height);
				hint.x = Math.max(geo.width+geo.x,hint.x);
				hint.y = Math.max(geo.height+geo.y,hint.y);
			}
			return hint;
		}
		
		public function sizeHint():WSize
		{
			return hint;
		}
		
	}
}