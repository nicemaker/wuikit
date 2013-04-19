package org.wuikit.wui.widgets
{
	import org.wuikit.wui.IInteractive;
	import org.wuikit.wui.IWidget;
	
	
	public interface IListView extends IWidget
	{

		function getSelection() : Array;
		
		function selectByIndex( index : int ) : *;
		
		function applySelection( f : Function ):Array;
		
		function set listDelegate( value : Object ) : void;
		function get listDelegate() : Object;
		
		function get items():Array;
		function set items(val:Array):void;
		
		function addItem(item:IInteractive,i:int=-1):*;
		function removeItemAt( i:int ):*;
		
		function indexOfItem( value : IInteractive ) : int;
		function itemAt( i:int ) : IInteractive;
		
	}
}