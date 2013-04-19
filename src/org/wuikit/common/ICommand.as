package org.wuikit.common
{
	
	public interface ICommand
	{
		function run( ... args ):*;
		function undo( ... args ):*;
		function skip():void;
		function pause():void;
		function resume():void;
		function clear():*;
	}
	
	
}