package org.wuikit.wui.widgets
{
	import flash.geom.Rectangle;
	
	import org.wuikit.wui.IInteractive;
	import org.wuikit.wui.UiState;
	import org.wuikit.wui.WAlign;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.WSizePolicy;
	import org.wuikit.wui.Widget;
	import org.wuikit.wui.frame.SimpleFrame;
	
	public class WButton extends WText
	{
		
		public function WButton()
		{
			super();
			frameStyle = new SimpleFrame(0xff,1);
			padding = new WPadding(10,10,10,10);
			hPolicy = WSizePolicy.AUTO;
			vPolicy = WSizePolicy.AUTO;
			mouseChildren = false;
			buttonMode = true;
		}
		
		override protected function resizeTo(w:Number, h:Number):void{
			if(icon){
				var size:WSize = icon.sizeHint();
				if(icon.hPolicy != WSizePolicy.AUTO)
					size.x = icon.geometry.width;
				if(icon.vPolicy != WSizePolicy.AUTO)
					size.y = icon.geometry.height;
				size = size.limit( icon.minSize,icon.maxSize );
				icon.setGeometry( padding.left,padding.right,size.x,size.y);
			}
			if(textField){
				textField.width = w - padding.sumX() - (icon ? icon.width + gap :0);
				textField.height = h - padding.sumY();
				textField.x = padding.left + (icon? icon.width + gap : 0);
				textField.y = padding.top;
			}
			
			var b:Rectangle = textField.getBounds(this);
				if(icon)
					b = b.union( icon.getBounds(this) );
			if(b.width + padding.right > w || b.height + padding.bottom >h)
				invalidMeasure();
			
		}
		
		
		private var label_:String;
		public function get label():String 
		{
			return htmlText;
		}

		public function set label(val:String):void 
		{
			htmlText = val
		}
		
		
		private var icon_:Widget;
		public function set icon(val:Widget):void 
		{
			if(icon==val)return;
			icon_=val;
			if(icon_)
				addChild(icon);
			invalidate();
			
			
		}
		
		public function get icon():Widget 
		{
			
			return icon_;
		}
		
		
		override public function uiStateChangeFor(who:IInteractive, state:UiState):void{
			super.uiStateChangeFor(who,state);
			if(who == this){
				if(icon)
					icon.setUiState( state.type,state.on,true);
			}
		}
		
		private var gap_:Number=5;
		public function set gap(val:Number):void 
		{
			if(val==gap_) return
			
			gap_=val;
			invalidate();
		}
		
		public function get gap():Number 
		{
			
			return gap_;
		}
		
		private var align_:String;
		public function set align(val:String):void 
		{
			if(align_ == val) 
				return;
			align_=val;
			invalidate();
		}
		
		public function get align():String 
		{
			
			return align_;
		}
		
		override public function sizeHint():WSize{
			var s:WSize = new WSize;
			s.x = textField.x + textField.textWidth + 4 + padding.right;
			s.y = textField.y +  textField.textHeight + 4 + padding.bottom;
			if(icon){
				s.x = Math.max( icon.x + icon.width + padding.right,s.x);
				s.y = Math.max( icon.y + icon.height + padding.right,s.y);
			}
			return s;
		}
		
	}
}