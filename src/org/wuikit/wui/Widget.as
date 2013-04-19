package org.wuikit.wui
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import org.wuikit.wui.frame.IFrameStyle;
	import org.wuikit.wui.layout.ILayout;
	import org.wuikit.wui.layout.WLayoutCanvas;
	

	public class Widget extends InteractiveSprite implements IWidget
	{
		
		
		protected var invalid:Boolean;
	
		public function Widget()
		{
			super();
			geometry = new Rectangle(0,0,0,0); 
			maxSize = new WSize(5000,5000);
			minSize = new WSize(0,0);
			stretch = new WSize( 0,0 );
		}
		
		private var layout_:ILayout;
		public function set layout(val:ILayout):void{
			layout_ = null;
			if(val == layout_) return
			layout_ = val;
			invalidate();
				
		}
		
		public function get layout():ILayout{
			return layout_;
		}
		
		
		override protected function onUiAddedToStage(e:Event):void{
			super.onUiAddedToStage(e);
			invalidate();
		}
		
		override public function uiStateChangeFor(who:IInteractive,state:UiState):void{
			if(who == this && frameStyle)
				refreshFrame();
		} 
		
		override protected function setupUiListeners():void{
			super.setupUiListeners();
			addEventListener( Event.RESIZE,onChildResize );
		}
		
		override protected function removeUiListeners():void{
			super.removeUiListeners();
			removeEventListener( Event.RESIZE, onChildResize );
		}
	
		protected function onChildResize(e:Event):void{
			if(e.target!=this){
				e.stopImmediatePropagation();
				e.stopPropagation();
				invalidate();
			}
		}
		
		public function validate():void{
			var hint:WSize = sizeHint();
			
			if(dataHasChanged()){
				refreshData(data);
				dataHasChanged( false )
			}
			resizeTo(geometry.width,geometry.height);
			move(geometry.x,geometry.y);
			refreshFrame();
			
			invalid = false;
			
			var newHint:WSize = sizeHint();
			if( newHint && !newHint.equals( hint ) )
				invalidMeasure();
			
		}
		
		
		protected function refreshData(data:*):void{
			
		}
		
		protected function resizeTo(w:Number,h:Number):void{
				if(layout) 
					layout.apply(this);		
		}
		
		protected function refreshFrame():void{
			if(stage&&frameStyle)
				frameStyle.render( this,getUiState(), geometry.width,geometry.height);
		}
		
		
		public function setGeometry(x:Number,y:Number,w:Number,h:Number):void{
			geometry = new Rectangle(x,y,w,h);
		}
		
		
		public function move(x:Number,y:Number):void{
			this.x = x;
			this.y = y;
		}
		
		
		private var frameStyle_:IFrameStyle;
		public function get frameStyle():IFrameStyle{
			return frameStyle_;
		}
		
		public function set frameStyle(val:IFrameStyle):void{
			frameStyle_=null;
			if(val==frameStyle_) return;
			frameStyle_ = val;
			refreshFrame();
		}
		
		
		private var minSize_:WSize;
		public function set minSize(val:WSize):void{
			minSize_ = val;
			invalidMeasure();
		}
		
		public function get minSize():WSize{
			return minSize_;
		}
		
		private var maxSize_:WSize;
		public function set maxSize(val:WSize):void{
			maxSize_ = val
			invalidMeasure()
		}
		
		public function get maxSize():WSize{
			return maxSize_;
		}
		
		private var stretch_:WSize = new WSize(1,1);
		public function set stretch(val:WSize):void{
			if(stretch_ == val)
			stretch_ = val
			invalidMeasure();
		}
		
		public function get stretch():WSize{
			return stretch_;
		}
		
		private var hPolicy_:String = 'none';
		public function set hPolicy(val:String):void{
			if(val == hPolicy_) return;
			hPolicy_ = val;
			invalidMeasure();
		}
		
		
		public function get hPolicy():String{
			return hPolicy_;
		}
		
		private var vPolicy_:String = 'none';
		public function set vPolicy(val :String):void{
			if(val == vPolicy) return;
			vPolicy_ = val;
			invalidMeasure();
		}
		
		public function get vPolicy():String{
			return vPolicy_;
		}
		
		protected function invalidate():void{
			if(!stage) return;
			if(!invalid){
				invalid = true;
				StageValidator.getInstance().push( validate );
			}				
		}
		
		private var sizeChanged_:Boolean;
		protected function sizeHasChanged(...args):Boolean{
			if(args && args.length > 0){
				sizeChanged_ = args[0]
			}
			return sizeChanged_;
		}
		
		protected function invalidMeasure():void{
			if(!stage) return;
				dispatchEvent( new Event( Event.RESIZE,true,true ) );
		}
		
		public function sizeHint():WSize{
			return layout ? layout.sizeHint() : null;
		}
		

		public function set widgets(val:Array):void 
		{
			while(numChildren>0)
				removeChildAt(0);
			
			var l:int = val.length;
			for(var i:int=0;i<l;i++)
				addChild(val[i]);
			
		}
		
		protected var geometry_:Rectangle;
		public function set geometry(val:Rectangle):void 
		{
		//	if(geometry && geometry.equals( val ))return;
			geometry_ = val;	
			invalidate();
		}
		
		public function get geometry():Rectangle 
		{
			return geometry_;
		}
		
		public function open():IEventDispatcher{
			dispatchEvent( new Event(Event.OPEN) );
			return this;
		}
		
		
		public function close():IEventDispatcher{
			dispatchEvent( new Event(Event.CLOSE) );
			return this;
		}
		
	}
}