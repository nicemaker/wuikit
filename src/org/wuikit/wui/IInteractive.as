package org.wuikit.wui
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	
	import org.wuikit.common.IClear;
	import org.wuikit.common.IDataObject;
	import org.wuikit.common.IDispose;
	
	public interface IInteractive extends IEventDispatcher,IDispose,IClear,IDataObject
	{
		function getUiState():UiState;
		function setUiState( type:int,on:Boolean,ignoreDelegate:Boolean=false):UiState;
		function uiStateChangeFor( who:IInteractive,state:UiState):void;
		
		function set id( value:String ):void;
		function get id():String;
		function set autoDispose( value:Boolean ):void;
		function set uiDelegate( value:Object ):void;
		function get uiDelegate():Object;
		function set selected( value:Boolean ):void;
		function get selected():Boolean;
		function set isSelectable( value:Boolean ):void;
		function get isSelectable():Boolean;
		function set disabled( value:Boolean ):void;
		function get disabled():Boolean;
		function set toolTip( value:String ):void;
		function get toolTip():String;
		function set dragable(val:Boolean):void;
		function get dragable():Boolean;
		
		function display():Sprite;
	}
}