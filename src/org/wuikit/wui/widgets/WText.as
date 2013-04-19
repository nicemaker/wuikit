package org.wuikit.wui.widgets
{
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	
	import org.wuikit.wui.IInteractive;
	import org.wuikit.wui.UiState;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.WSizePolicy;
	import org.wuikit.wui.Widget;

	public class WText extends Widget
	{
		
		
		public function WText()
		{
			super();
			geometry = new Rectangle(0,0,100,100);
			vPolicy = WSizePolicy.AUTO;
			textField = new TextField;
		}
		
			override public function uiStateChangeFor(who:IInteractive, state:UiState):void{
				super.uiStateChangeFor(this,state);
				if(state.type == UiState.ACTIVE)
					invalidate();
			}
			
		 override public function validate():void{
			 refreshTextField();
			 super.validate();
		 }
		 
		protected function refreshTextField():void{
			if(!textField) return;
				textField.autoSize = autoSize;
			textField.multiline = textField.wordWrap =  multiline;
			if(htmlText) textField.htmlText = htmlText;
			if(formatText && styleSheet && textStyle)
				textField.defaultTextFormat = styleSheet.transform( styleSheet.getStyle( textStyle ));
			else if(styleSheet)
				textField.styleSheet = styleSheet;
			textField.selectable = textSelectable;
		}
		
		override protected function resizeTo(w:Number, h:Number):void{
			textField.width = w - padding.sumX();
			textField.height = h - padding.sumY();
			textField.x = padding.left;
			textField.y = padding.top;
		}
		
		private var multiline_:Boolean=true;
		public function set multiline(val:Boolean):void 
		{
			multiline_ = val;
			invalidate()
		}
		
		public function get multiline():Boolean 
		{
			
			return multiline_;
		}
		
		private var textField_:TextField;
		public function set textField(value:TextField):void{
			if(textField_) removeChild(textField_);
			textField_ = value;
			addChild(value);
		}
		
		
		
		public function get textField():TextField{
			return textField_;
		}
		
		private var htmlText_:String;
		public function set htmlText(value:String):void{
			htmlText_ = value;
			refreshTextField();
			invalidate();
		}
		
		public function get htmlText():String{
			return htmlText_;
		}
		
		private var styleSheet_:StyleSheet;
		public function set styleSheet(value:StyleSheet):void{
			styleSheet_ = value;
		}
		
		
		public function get styleSheet():StyleSheet{
			return styleSheet_;
		}
		
		private var textStyle_:String;
		public function set textStyle(value:String):void{
			textStyle_ = value;
		}
		
		public function get textStyle():String{
			return textStyle_;
		}
		
		private var formatText_:Boolean = true;
		public function get formatText():Boolean{
			return formatText_;
		}
		
		public function set formatText(value:Boolean):void{
			formatText_ =  value;
		}
		
		private var textSelectable_:Boolean = true;
		public function get textSelectable():Boolean{
			return textSelectable_;
		}
		
		public function set textSelectable(value:Boolean):void{
			textSelectable_ =  value;
		}
		
		protected var autoSize_:String='left';
		public function set autoSize(value:String):void{
			autoSize_ = value;
		}
		
		public function get autoSize():String{
			return autoSize_;
		}
		
		override public function sizeHint():WSize{
			var s:WSize = new WSize(0,0);
			s.x = textField.textWidth + 4 + padding.sumX();
			s.y = textField.textHeight + 4 + padding.sumY();
			return s;
		}
		
		private var padding_:WPadding = new WPadding(0,0,0,0);
		public function set padding(val:WPadding):void 
		{
			padding_ = val;
			invalidate();
		}
		
		public function get padding():WPadding 
		{
			
			return padding_;
		}
	}
}