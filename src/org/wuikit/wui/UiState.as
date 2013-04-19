package org.wuikit.wui
{
	public class UiState
	{
		public static const NORMAL:int = 0;
		public static const SELECTED:int = 1;
		public static const ACTIVE:int = 2;
		public static const DISABLED:int = 3;
		
		public var type:int=0;
		public var on:Boolean;
		
		public function UiState(type:int=0,on:Boolean=false){
			this.type = type;
			this.on = on;
		}
		
		public function toString():String{
			return '[object UiState]' + 'type: ' + type + ' on: ' + on;
		}
		
		public function clone():UiState{
			return new UiState( type,on);
		}
		
		public function equals( val:UiState):Boolean{
			return val.on == on && val.type == type;
		}
		
	}
}