package org.wuikit.wui.widgets
{
	
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import org.wuikit.wui.IInteractive;
	import org.wuikit.wui.IWidget;
	import org.wuikit.wui.UiState;
	import org.wuikit.wui.Widget;
	
	public class WList extends Widget implements IListView 
	{
		
		
		public function WList()
		{
			super();
			
		}
		
		public function applySelection( f:Function ):Array{
			if(!items) return null
			
			var sel:Array = [];
			var i:int = 0,l:int=items.length;
			for(i;i<l;i++)
				if(f.call(null,items[i]))
					selectByIndex(i);
			return getSelection();			
		}
		
		private var multiSelect_:Boolean=false;
		public function set multiSelect(val:Boolean):void{
			multiSelect_ = val
		}
		
		public function get multiSelect():Boolean{
			return multiSelect_
		}
		
		private var autoSelect_:Boolean=true;
		public function set autoSelect(val:Boolean):void{
			autoSelect_ = val
		}
		
		public function get autoSelect():Boolean{
			return autoSelect_
		}
		
		private var selection_:Array;
		public function selectByIndex( i:int ):*{
			if(!multiSelect && selection_){
				while(selection_.length > 0)
					removeFromSelection( selection_.length-1 );	
			}
			return  items && i < items.length ?  addToSelection( items[i] ) : null;
		}
		
		protected function addToSelection(val:IInteractive):*{
			
			if(items.indexOf(val)  != -1){
				if(! selection_ ) selection_ = [];
				selection_.push( val );
				if(val.selected == false && !val.disabled )
					val.selected = true;
				if(listDelegate && listDelegate.hasOwnProperty('itemSelectedInListAt') ) 
					listDelegate.itemSelectedInListAt( this, indexOfItem( val ) );
				dispatchEvent( new Event(Event.SELECT) );
			}
			return val;
		}
		
		public function addItem(item:IInteractive,i:int=-1):*{
			if(!item) return null;
			if(!items) items = [];
			if(i>items.length) return item;
			item.uiDelegate = this;
			i = i==-1 ? items.length:i;
			items.splice(i,1,item);
			addChildAt( item.display(),i );
			invalidate();
			return item
		}
		
		public function removeItemAt(i:int):*{
			var item:IInteractive;
			if( (item = itemAt( i )) ){
				items.splice( i,1);
				removeChild( item.display() )
				invalidate();
			}
			return item;
		}
		
		protected function removeFromSelection(i:int):void{
			if(i != -1){
				var item:* = selection_.splice(i,1)[i];
				if(item is IInteractive)
					item.selected = false;
			}
		}
		
		
		public function getSelection():Array{
			if(!selection_) return null;
			return selection_;
		}
		
		public function indexOfItem(val:IInteractive):int{
			return items && items.length > 0 ? items.indexOf( val ):-1;
		}
		
		public function itemAt(i:int):IInteractive{
			if(!items || i<0 || i>items.length-1) return null;
			return items[i];
		}
		
		
		override protected function refreshData(data:*):void{
			if( ! dataHasChanged() ) return;
			clear();
	
			if(!data) return;
			
			if(!items) items = [];
			
			var itemData:Object;
			var item:DisplayObject;
			
			var l:int = data is XMLList ? (data as XMLList).length() : (data as Array).length;
			var i : int = 0;
			while(i < l)
				addItem( getItemRenderer( i ))
		}
		
		override public function uiStateChangeFor( who:IInteractive,state:UiState ):void{
			super.uiStateChangeFor(who,state);
			if(items && indexOfItem(who) !=-1){
				who.setUiState(state.type,state.on,true);
				if(listDelegate)
					listDelegate['uiStateChangeInListAt'].call(this,indexOfItem(who),who.getUiState());
			}
		}
		
		
		private var itemPrototype_:String;
		public function set itemPrototype(val:String):void{
			itemPrototype_ = val;
		}
		
		public function get itemPrototype():String{
			return itemPrototype_
		}
		
		override public function dispose():*{
			super.dispose();
			items = null;
			listDelegate = null;
			return this;
		}
		
		
		override public function set widgets(val:Array):void{
			items = val;
		} 
		
		private var items_:Array;
		public function set items(val:Array):void{
			clear();
			var l:int = val.length;
			var item:IInteractive;
			for(var i:int;i<l;i++){
				item = val[i];
				item.uiDelegate=this;
				addChild(item.display());
			}
			items_ = val;
			invalidate();
		}
		
	
		
		override public function clear():*{
			while(items && items.length > 0)
				removeChild(items.pop() );
		}
		
		public function get items():Array{
			return items_
		}
		
		
		private var listDelegate_:Object;
		public function set listDelegate(val : Object):void{
			listDelegate_ = val;
		}
		
		public function get listDelegate():Object{
			return listDelegate_;
		}
		
		protected function getItemRenderer( i:int ):IInteractive{
			var renderer:IInteractive;
			if(listDelegate && listDelegate.hasOwnProperty( 'getItemRendererInListAt' ) )
				renderer = listDelegate.getItemRendererInListAt(this,i);
			else{
				var itemClass : Class  =  getDefinitionByName( itemPrototype )  as Class;
				renderer =  new itemClass();
				renderer.data = data[i];
			}
			return renderer;
		}
		
		
		override public function isValidDataType( data:Object ):Boolean{
			return (data is Array || data is XMLList);
		}
		
		
		
		
	}
}