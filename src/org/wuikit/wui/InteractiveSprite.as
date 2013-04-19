package org.wuikit.wui
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class InteractiveSprite extends Sprite implements IInteractive
	{
		
		public function InteractiveSprite()
		{
			super();
			autoDispose = true;
			setupUiListeners();
		}
		
		private var dragable_:Boolean;
		public function set dragable(val:Boolean):void
		{
			dragable_=val;
		}
		
		public function get dragable():Boolean
		{
			return dragable_;
		}
		
		
		
		/**
		 * Dispose all properties and listeners for memory cleanup.
		 * @return UiView
		 * 
		 */		
		public function dispose():*
		{
			removeUiListeners();
			uiDelegate = null;
			data = null;
		}
		
		/**
		 * Setup EventListener for view.
		 * Default Listener are <code>Event.ADDED_TO_STAGE,MouseEvent.ROLL_OVER,MouseEvent.ROLL_OUT,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_UP,MouseEvent.CLICK,Event.RESIZE</code>
		 * 
		 * @see #onUiAddedToStage
		 * @see #onUiMouse
		 * @see #onUiChildResize
		 */		
		protected function setupUiListeners():void{
			addEventListener(Event.ADDED_TO_STAGE,onUiAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,onUiRemovedFromStage);
		}
		
		/**
		 * Called in <code>dispose()</code> to remove all EventListeners created in <code>setupUiListeners()</code>
		 * 
		 */		
		protected function removeUiListeners():void{
			removeEventListener(Event.ADDED_TO_STAGE,onUiAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE,onUiRemovedFromStage);
		}
		
		
		protected function onUiAddedToStage(e:Event):void{
		}
		
	
		protected function onUiRemovedFromStage(e:Event):void{
			if(autoDispose) dispose();
		}
		
	
		
		private var id_:String='';
		public function get id(  ):String{
			return id_
		}
		
		public function set id( val:String ):void{
			id_ = val;
		}
		
		private var uiDelegate_:Object;
		public function set uiDelegate(val:Object):void{
			uiDelegate_ = null;
			if(val && val.hasOwnProperty( 'uiStateChangeFor' ))
				uiDelegate_ = val;
		}
		
		public function get uiDelegate():Object{
			return uiDelegate_;
		}
		
		private var toolTip_:String;
		public function get toolTip(  ):String{
			return toolTip_
		}
		
		public function set toolTip( val:String ):void{
			toolTip_ = val;
		}
		
		private var uiState_:UiState = new UiState();
		public function getUiState():UiState{
			return uiState_;
		}
		
		public function setUiState( type:int,on:Boolean,ignoreDelegate:Boolean = false ):UiState{
			uiState_.on = on; uiState_.type = type;
			if(!ignoreDelegate && uiDelegate)
				uiDelegate['uiStateChangeFor'].call( null, this, uiState_ );
			else
				uiStateChangeFor( this,uiState_ );
			return uiState_;
		}
		
		private var _selected:Boolean;
		public function set selected( val:Boolean ):void{
			if(selected == val ) return;
			_selected = val
		}
		
		public function get selected():Boolean{
			return _selected
		}
		
		private var isSelectable_:Boolean;
		public function set isSelectable( val:Boolean ):void{
			if(isSelectable_ == val ) return;
			isSelectable_ = val;
		}
		
		public function get isSelectable():Boolean{
			return isSelectable_
		}
		
		
		private var disabled_:Boolean;
		public function set disabled( val:Boolean ):void{
			if(val==disabled_) return;
				disabled_ = val;
		}
		
		public function uiStateChangeFor( who:IInteractive,state:UiState ):void{
			
		}
		
		public function get disabled():Boolean{ 
			return disabled_ 
		}
		
		private var autoDispose_:Boolean;
		public function set autoDispose(val:Boolean):void{
			autoDispose_ = val;
		}
		
		public function get autoDispose():Boolean{
			return autoDispose_;
		}
		
		private var data_:Object;
		public function set data(val:Object):void{
			if( val == data) return;
			if( !isValidDataType( val ) && null!=val)
				throw new Error( WError.INVALID_DATA_TYPE )
			else{
				data_ = val;
				dataHasChanged(true) 
			}
		}
		
		public function	get data():*{
			return data_;
		}
		
		/**
		 * Is utilized in setData to check if assigned data is valid. 
		 * @param data
		 * @return 
		 * 
		 * @see #setData()
		 */		
		public function isValidDataType( data:Object ):Boolean{
			return true;
		}
		
		private var dataChanged_:Boolean;
		protected function dataHasChanged(...args):Boolean{
			if(args && args.length > 0){
				dataChanged_ = args[0]
			}
			return dataChanged_;
		}
		
		public function clear():*{
			return this;
		}
		
		/**
		 * If you code only against Interface this function makes it easy to acces all DisplayObject Properties.
		 * @return UiView
		 * 
		 */		
		public function display():Sprite{
			return this;
		}
		
		
	}
}