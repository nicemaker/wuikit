package org.wuikit.wui.widgets
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import org.wuikit.WuikitApp;
	import org.wuikit.wui.IInteractive;
	import org.wuikit.wui.UiState;
	import org.wuikit.wui.WPadding;
	import org.wuikit.wui.WSize;
	import org.wuikit.wui.WSizePolicy;
	import org.wuikit.wui.Widget;
	
	public class WIcon extends Widget
	{
		
		protected var icon:DisplayObject;
		protected var uiState:UiState = new UiState();
		
		public function WIcon()
		{
			super();
			hPolicy = vPolicy = WSizePolicy.AUTO;
		}
		
		
		override public function uiStateChangeFor(who:IInteractive, state:UiState):void{
			if(who!=this) return;
			uiState = state;
			updateIcon();
		}
		
		override protected function resizeTo(w:Number, h:Number):void{
			if(icon){
				icon.width = w-padding.sumX();
				icon.height = h-padding.sumY();
				icon.x = .5* (w - icon.width);
				icon.y = .5* (h - icon.height);
			}
		}
		
		override public function sizeHint():WSize{
			var s:Rectangle = new Rectangle(0,0,0,0);
			if(icon)
			 	s= icon.getBounds( icon );
			return new WSize(s.width+padding.sumX(),s.height+padding.sumY())
		}
		
		override public function validate():void{
			updateIcon();
			super.validate();
		}
		
		public function updateIcon():void{
			var state:UiState = uiState;
			var icon:DisplayObject= 
				uiState.type == UiState.ACTIVE && uiState.on ? activeOn : 
				uiState.type == UiState.NORMAL && uiState.on ? normalOn : 
				uiState.type == UiState.SELECTED && uiState.on ? selectedOn :
				uiState.type == UiState.DISABLED && uiState.on ? disabledOn :
				uiState.type == UiState.ACTIVE && !uiState.on ? activeOff :
				uiState.type == UiState.NORMAL && !uiState.on ? normalOff :
				uiState.type == UiState.SELECTED && !uiState.on ? selectedOff :
				disabledOff;
			if(!icon)
				icon = uiState.on ? defaultOn : defaultOff;
			
			exchangeIcon(icon);
		}
		
		protected function exchangeIcon( val:DisplayObject):void{
			if(icon)
				removeChild( icon );
			icon = val;
			if(icon)
				addChild( icon );
			resizeTo(geometry.width,geometry.height);
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
		
		
		private var activeOn_:DisplayObject;
		public function set activeOn(val:DisplayObject):void{
			if(val == activeOn_) return;
			activeOn_ = val;
			invalidate()
		}
		
		public function get activeOn():DisplayObject{
			return activeOn_
		}
		
		private var selectedOn_:DisplayObject;
		public function set selectedOn(val:DisplayObject):void{
			if(val == selectedOn_) return;
			selectedOn_ = val;
		}
		
		public function get selectedOn():DisplayObject{
			return selectedOn_
		}
		
		private var normalOn_:DisplayObject;
		public function set normalOn(val:DisplayObject):void{
			if(val == normalOn_) return;
			normalOn_ = val;
			invalidate()
		}
		
		public function get normalOn():DisplayObject{
			return normalOn_
		}
		
		private var disabledOn_:DisplayObject;
		public function set disabledOn(val:DisplayObject):void{
			if(val == disabledOn_) return;
			disabledOn_ = val;
			invalidate()
		}
		
		public function get disabledOn():DisplayObject{
			return disabledOn_
		}
		
		private var activeOff_:DisplayObject;
		public function set activeOff(val:DisplayObject):void{
			if(val == activeOff_) return;
			activeOff_ = val;
			invalidate()
		}
		
		public function get activeOff():DisplayObject{
			return activeOff_
		}
		
		private var selectedOff_:DisplayObject;
		public function set selectedOff(val:DisplayObject):void{
			if(val == selectedOff_) return;
			selectedOff_ = val;
			invalidate()
		}
		
		public function get selectedOff():DisplayObject{
			return selectedOff_
		}
		
		private var normalOff_:DisplayObject;
		public function set normalOff(val:DisplayObject):void{
			if(val == normalOff_) return;
			normalOff_ = val;
			invalidate()
		}
		
		public function get normalOff():DisplayObject{
			return normalOff_
		}
		
		private var disabledOff_:DisplayObject;
		public function set disabledOff(val:DisplayObject):void{
			if(val == disabledOff_) return;
			disabledOff_ = val;
			invalidate()
		}
		
		public function get disabledOff():DisplayObject{
			return disabledOff_
		}
		
		private var defaultOff_:DisplayObject;
		public function set defaultOff(val:DisplayObject):void{
			if(val == defaultOff_) return;
			defaultOff_ = val;
			invalidate()
		}
		
		public function get defaultOff():DisplayObject{
			return defaultOff_
		}
		
		private var defaultOn_:DisplayObject;
		public function set defaultOn(val:DisplayObject):void{
			if(val == defaultOn_) return;
			defaultOn_ = val;
			invalidate()
		}
		
		public function get defaultOn():DisplayObject{
			return defaultOn_
		}
		
	}
}